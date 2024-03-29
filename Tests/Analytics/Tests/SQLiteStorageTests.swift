//
//  SQLiteStorageTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 19/12/2022.
//

import Foundation
import XCTest
import PaltaAnalyticsPrivateModel
@testable import PaltaAnalytics

final class SQLiteStorageTests: XCTestCase {
    private var errorLoggerMock: ErrorsCollectorMock!
    private var fileManager: FileManager!
    private var testURL: URL!
    
    private var storage: SQLiteStorage!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        errorLoggerMock = .init()
        fileManager = FileManager()
        testURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        try fileManager.createDirectory(at: testURL, withIntermediateDirectories: true)
        
        try reinitStorage()
    }
    
    override func tearDown() async throws {
        try fileManager.removeItem(at: testURL)
    }
    
    func testSaveEventInOneSession() throws {
        let event = StorableEvent(
            event: IdentifiableEvent(id: .init(), event: BatchEvent()),
            contextId: .init()
        )
        
        storage.storeEvent(event)
        
        var restoredEvent: StorableEvent?
        let loadFinished = expectation(description: "Load finished")
        
        storage.loadEvents {
            restoredEvent = $0.first
            loadFinished.fulfill()
        }
        
        wait(for: [loadFinished], timeout: 0.5)
        
        XCTAssertEqual(restoredEvent?.contextId, event.contextId)
        XCTAssertEqual(restoredEvent?.event.id, event.event.id)
        XCTAssertEqual(restoredEvent?.event.event.timestamp, event.event.event.timestamp)
    }
    
    func testSaveEvent() throws {
        let event = StorableEvent(
            event: IdentifiableEvent(id: .init(), event: BatchEvent()),
            contextId: .init()
        )
        
        storage.storeEvent(event)
        
        try reinitStorage()
        var restoredEvent: StorableEvent?
        let loadFinished = expectation(description: "Load finished")
        
        storage.loadEvents {
            restoredEvent = $0.first
            loadFinished.fulfill()
        }
        
        wait(for: [loadFinished], timeout: 0.5)
        
        XCTAssertEqual(restoredEvent?.contextId, event.contextId)
        XCTAssertEqual(restoredEvent?.event.id, event.event.id)
        XCTAssertEqual(restoredEvent?.event.event.timestamp, event.event.event.timestamp)
    }
    
    func testSaveEventError() throws {
        // TODO: Think how emulate error
//        let event = StorableEvent(
//            event: IdentifiableEvent(id: .init(), event: BatchEventMock(shouldFailSerialize: true)),
//            contextId: .init()
//        )
//
//        storage.storeEvent(event)
//
//        try reinitStorage()
//        var restoredEvent: StorableEvent?
//        let loadFinished = expectation(description: "Load finished")
//
//        storage.loadEvents {
//            restoredEvent = $0.first
//            loadFinished.fulfill()
//        }
//
//        wait(for: [loadFinished], timeout: 0.5)
//
//        XCTAssertNil(restoredEvent)
    }
    
    func testRemoveEvent() throws {
        let event = StorableEvent(
            event: IdentifiableEvent(id: .init(), event: .mock()),
            contextId: .init()
        )
        
        storage.storeEvent(event)
        try reinitStorage()
        storage.removeEvent(with: event.event.id)
        
        try reinitStorage()
        var restoredEvent: StorableEvent?
        let loadFinished = expectation(description: "Load finished")
        
        storage.loadEvents {
            restoredEvent = $0.first
            loadFinished.fulfill()
        }
        
        wait(for: [loadFinished], timeout: 0.5)
        
        XCTAssertNil(restoredEvent)
    }
    
    func testRemoveEventWrongId() throws {
        let event = StorableEvent(
            event: IdentifiableEvent(id: .init(), event: .mock()),
            contextId: .init()
        )
        
        storage.storeEvent(event)
        try reinitStorage()
        storage.removeEvent(with: UUID())
        
        try reinitStorage()
        var restoredEvent: StorableEvent?
        let loadFinished = expectation(description: "Load finished")
        
        storage.loadEvents {
            restoredEvent = $0.first
            loadFinished.fulfill()
        }
        
        wait(for: [loadFinished], timeout: 0.5)
        
        XCTAssertNotNil(restoredEvent)
    }
    
    func testLoadEvents() throws {
        // TODO: Think how emulate error
        let events = [
//            BatchEventMock(shouldFailDeserialize: true),
            BatchEvent.mock(),
//            BatchEventMock(shouldFailDeserialize: true),
            BatchEvent.mock(),
            BatchEvent.mock()
        ].map {
            StorableEvent(event: IdentifiableEvent(id: .init(), event: $0), contextId: .init())
        }
        
        events.forEach(storage.storeEvent)
        
        try reinitStorage()
        let loadCompleted = expectation(description: "Load completed")
        
        storage.loadEvents { events in
            XCTAssertEqual(events.count, 3)
            loadCompleted.fulfill()
        }
        
        wait(for: [loadCompleted], timeout: 0.5)
    }
    
    func testBatchStore() throws {
        let expectedEvents = (0...20).map {
            StorableEvent.mock(timestamp: $0)
        }
        
        var batch = Batch()
        batch.common.batchID = UUID().uuidString
        
        expectedEvents.forEach(storage.storeEvent(_:))
        
        try reinitStorage()
        try storage.saveBatch(batch, with: expectedEvents[0...10].map { $0.event.id })

        try reinitStorage()
        let eventsLoaded = expectation(description: "Events loaded")

        storage.loadEvents { events in
            let sortedEvents = events.sorted(by: { $0.event.event.timestamp < $1.event.event.timestamp })

            XCTAssertEqual(sortedEvents.map { $0.event.id }, expectedEvents[11...20].map { $0.event.id })
            eventsLoaded.fulfill()
        }

        wait(for: [eventsLoaded], timeout: 0.05)
        
        XCTAssertEqual(try storage.loadBatches().first, batch)
    }
    
    func testLoadBatches() throws {
        var batch1 = Batch()
        batch1.common.batchID = UUID().uuidString
        
        var batch2 = Batch()
        batch2.common.batchID = UUID().uuidString
        
        var batch3 = Batch()
        batch3.common.batchID = UUID().uuidString
        
        try storage.saveBatch(batch1, with: [])
        try storage.saveBatch(batch2, with: [])
        try storage.saveBatch(batch3, with: [])
        
        try reinitStorage()
        
        try reinitStorage()
        XCTAssertEqual(Set(try storage.loadBatches()), [batch1, batch2, batch3])
    }
    
    func testSpecificBatchRemoval() throws {
        var batch1 = Batch()
        batch1.common.batchID = UUID().uuidString
        
        var batch2 = Batch()
        batch2.common.batchID = UUID().uuidString
        
        var batch3 = Batch()
        batch3.common.batchID = UUID().uuidString
        
        try storage.saveBatch(batch1, with: [])
        try storage.saveBatch(batch2, with: [])
        try storage.saveBatch(batch3, with: [])
        
        try reinitStorage()
        try storage.removeBatch(batch2)
        
        try reinitStorage()
        XCTAssertEqual(Set(try storage.loadBatches()), [batch1, batch3])
    }
    
    func testSaveErrors() throws {
        let code1 = Int.random(in: 1000...10000)
        let code2 = Int.random(in: 1000...10000)
        let code3 = code2
        
        let batch: Batch = .mock()
        
        try storage.addErrorCode(code1, for: batch)
        try storage.addErrorCode(code2, for: batch)
        try storage.addErrorCode(code3, for: batch)
        
        try reinitStorage()
        
        let retrievedCodes = try storage.getErrorCodes(for: batch)
        
        XCTAssertEqual(retrievedCodes, [code1, code2, code3])
    }
    
    func testGetNoErrors() throws {
        XCTAssertEqual(try storage.getErrorCodes(for: .mock()), [])
    }
    
    func testErrorCodesRemovedWithBatch() throws {
        let batch: Batch = .mock()
        
        try storage.saveBatch(batch, with: [])
        
        try storage.addErrorCode(101, for: batch)
        try storage.addErrorCode(102, for: batch)
        
        try reinitStorage()
        
        try storage.removeBatch(batch)
        
        try reinitStorage()
        
        XCTAssertEqual(try storage.getErrorCodes(for: batch), [])
    }
    
    private func reinitStorage() throws {
        storage = try SQLiteStorage(
            errorsLogger: errorLoggerMock,
            folderURL: testURL,
            logger: DefaultLogger(messageTypes: .all)
        )
    }
}
