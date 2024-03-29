//
//  EventQueue.swift
//  PaltaAnalytics
//
//  Created by Vyacheslav Beltyukov on 06/06/2022.
//

import Foundation
import PaltaCore
import PaltaAnalyticsPrivateModel

struct EventQueueConfig {
    let maxBatchSize: Int
    let uploadInterval: TimeInterval
    let uploadThreshold: Int
    let maxEvents: Int
}

protocol EventQueue: AnyObject {
    typealias UploadHandler = ([UUID: BatchEvent], UUID, Telemetry, TriggerType) -> Bool
    typealias RemoveHandler = (ArraySlice<StorableEvent>) -> Void

    var sendHandler: UploadHandler? { get set }
    var removeHandler: RemoveHandler? { get set }

    func addEvent(_ event: StorableEvent)
    func addEvents(_ events: [StorableEvent])
    
    func sendEventsAvailable()
    func forceFlush()
}

final class EventQueueImpl: EventQueue, FunctionalExtension {
    var sendHandler: UploadHandler?
    var removeHandler: RemoveHandler?

    var isPaused = false
    
    private(set) var config: EventQueueConfig? {
        didSet {
            onNewEvents()
        }
    }

    private var events: [StorableEvent] = []

    private var droppedEventsCount = 0

    private var timerFired = false

    private var timerToken: TimerToken? {
        didSet {
            oldValue?.cancel()
        }
    }

    private let workingQueue = DispatchQueue(label: "com.paltabrain.analytics.eventQueueCore")
    private let serializationErrorsProvider: ErrorsProvider
    private let storageErrorsProvider: ErrorsProvider
    private let timer: PaltaTimer
    private let lock: NSLocking

    init(
        serializationErrorsProvider: ErrorsProvider,
        storageErrorsProvider: ErrorsProvider,
        timer: PaltaTimer,
        lock: NSLocking
    ) {
        self.serializationErrorsProvider = serializationErrorsProvider
        self.storageErrorsProvider = storageErrorsProvider
        self.timer = timer
        self.lock = lock
    }

    func addEvent(_ event: StorableEvent) {
        workingQueue.async {
            self.insert(event)
            self.onNewEvents()
        }
    }

    func addEvents(_ events: [StorableEvent]) {
        workingQueue.async {
            events.forEach(self.insert)
            self.onNewEvents()
        }
    }
    
    func sendEventsAvailable() {
        workingQueue.async { [self] in
            if timerFired {
                flush(.timer)
            } else {
                flushByCountOrContexts()
            }
        }
    }

    func apply(_ config: EventQueueConfig) {
        workingQueue.async {
            self.config = config
        }
    }
    
    func forceFlush() {
        workingQueue.async { [self] in
            flush(.minimise)
        }
    }
    
    #if DEBUG
    func addBarrier(_ block: @escaping () -> Void) {
        workingQueue.async(flags: .barrier, execute: block)
    }
    #endif

    private func insert(_ event: StorableEvent) {
        let index = events.firstIndex(where: {
            $0.event.event.timestamp > event.event.event.timestamp
        }) ?? events.endIndex
        events.insert(event, at: index)
    }

    private func onNewEvents() {
        stripEventsIfNeeded()
        scheduleTimerIfNeeded()
        flushByCountOrContexts()
    }

    private func stripEventsIfNeeded() {
        guard let config = config, events.count > config.maxEvents else {
            return
        }

        let stripCount = events.count - config.maxEvents
        let strippedEvents = events.prefix(stripCount)
        events = Array(events.suffix(config.maxEvents))

        droppedEventsCount += strippedEvents.count
        removeHandler?(strippedEvents)
    }

    private func scheduleTimerIfNeeded() {
        guard timerToken == nil, let config = config else {
            return
        }

        timerToken = timer.scheduleTimer(timeInterval: config.uploadInterval, on: workingQueue) { [weak self] in
            self?.timerFired = true
            self?.timerToken = nil
            self?.flush(.timer)
        }
    }

    private func flushIfNeededByCount() -> Bool {
        guard let config = config, events.count >= config.uploadThreshold else {
            return false
        }

        flush(.count)
        return true
    }
    
    private func flushIfMultipleContexts() -> Bool {
        guard
            config != nil,
            let firstContextId = events.first?.contextId,
            !events.allSatisfy({ $0.contextId == firstContextId })
        else {
            return false
        }
        
        flush(.context)
        return true
    }
    
    private func flushByCountOrContexts() {
        let flushedByCount = flushIfNeededByCount()
        
        guard !flushedByCount else {
            return
        }
        
        _ = flushIfMultipleContexts()
    }

    private func flush(_ triggerType: TriggerType) {
        lock.lock()
        defer { lock.unlock() }

        let timerWasFired = timerFired
        timerFired = false

        guard let config = config else {
            assertionFailure("Flush shouldn't be called unless we have a config")
            return
        }
        
        guard let contextId = events.first?.contextId else {
            return
        }

        let batchSize = config.maxBatchSize
        let firstIndexWithAnotherContext = events.firstIndex { $0.contextId != contextId } ?? .max

        let range = 0..<min(batchSize, events.count, firstIndexWithAnotherContext)

        let telemetry = Telemetry(
            eventsDroppedSinceLastBatch: droppedEventsCount,
            reportingSpeed: 0,
            storageErrors: storageErrorsProvider.getErrors(),
            serializationErrors: serializationErrorsProvider.getErrors()
        )

        let batchEvents = Dictionary(grouping: events[range], by: { $0.event.id })
            .compactMapValues { $0.first?.event.event }
        let batchFormed = sendHandler?(batchEvents, contextId, telemetry, triggerType) ?? false
        
        guard batchFormed else {
            timerFired = timerWasFired
            return
        }
        
        droppedEventsCount = 0

        events = Array(events.suffix(from: range.upperBound))

        if events.isEmpty {
            timerToken = nil
        }
    }
}
