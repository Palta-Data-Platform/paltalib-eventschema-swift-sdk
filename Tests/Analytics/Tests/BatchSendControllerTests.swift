//
//  BatchSendControllerTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 29/06/2022.
//

import Foundation
import XCTest
import PaltaAnalyticsPrivateModel
@testable import PaltaAnalytics

final class BatchSendControllerTests: XCTestCase {
    private var composerMock: BatchComposerMock!
    private var storageMock: BatchStorageMock!
    private var senderMock: BatchSenderMock!
    private var timerMock: TimerMock!
    
    private var controller: BatchSendControllerImpl!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        composerMock = .init()
        storageMock = .init()
        senderMock = .init()
        timerMock = .init()
        
        controller = BatchSendControllerImpl(
            batchComposer: composerMock,
            batchStorage: storageMock,
            batchSender: senderMock,
            timer: timerMock
        )
    }
    
    func testSuccessfulSend() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = Dictionary(
            grouping: (0...10).map { _ in BatchEvent.mock() },
            by: { _ in UUID() }
        )
            .compactMapValues { $0.first }
        
        senderMock.result = .success(())
        
        controller.sendBatch(of: events, with: contextId)
        
        wait(for: [isReadyCalled], timeout: 0.1)
        
        XCTAssertEqual(Set(composerMock.events ?? []), Set(events.values))
        XCTAssertEqual(composerMock.contextId, contextId)
        XCTAssertNotNil(senderMock.batch)
        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssertEqual(storageMock.eventIds.count, 11)
        XCTAssert(controller.isReady)
    }
    
    func testSequentalSend() {
        controller.configurationFinished()

        let isReadyNotCalled = expectation(description: "Is Ready called")
        isReadyNotCalled.isInverted = true
        controller.isReadyCallback = isReadyNotCalled.fulfill
        
        let contextId = UUID()
        let events1 = [UUID(): BatchEvent.mock()]
        let events2 = [UUID(): BatchEvent.mock()]
        
        controller.sendBatch(of: events1, with: contextId)
        
        composerMock.events = nil
        composerMock.contextId = nil
        senderMock.batch = nil
        storageMock.savedBatch = nil
        storageMock.eventIds = []
        
        controller.sendBatch(of: events2, with: contextId)
        
        wait(for: [isReadyNotCalled], timeout: 0.1)
        
        XCTAssertNil(composerMock.events)
        XCTAssertNil(senderMock.batch)
        XCTAssertNil(storageMock.savedBatch)
        XCTAssert(storageMock.eventIds.isEmpty)
        XCTAssertFalse(controller.isReady)
    }
    
    func testUnknownError() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.unknown)
        
        controller.sendBatch(of: events, with: contextId)
        
        wait(for: [isReadyCalled], timeout: 0.1)

        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testSerializationError() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.serializationError(NSError(domain: "", code: 0)))
        
        controller.sendBatch(of: events, with: contextId)
        
        wait(for: [isReadyCalled], timeout: 0.1)

        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testServerError() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.serverError)
        
        controller.sendBatch(of: events, with: contextId)
        
        XCTAssertNotNil(timerMock.passedInterval)
        XCTAssertFalse(storageMock.batchRemoved)
        XCTAssertFalse(controller.isReady)
        
        senderMock.result = .success(())
        timerMock.fire()
        
        wait(for: [isReadyCalled], timeout: 0.1)

        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testNoInternet() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.noInternet)
        
        controller.sendBatch(of: events, with: contextId)
        
        XCTAssertNotNil(timerMock.passedInterval)
        XCTAssertFalse(storageMock.batchRemoved)
        XCTAssertFalse(controller.isReady)
        
        senderMock.result = .success(())
        timerMock.fire()
        
        wait(for: [isReadyCalled], timeout: 0.1)

        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testTimeoutError() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.timeout)
        
        controller.sendBatch(of: events, with: contextId)
        
        XCTAssertNotNil(timerMock.passedInterval)
        XCTAssertFalse(storageMock.batchRemoved)
        XCTAssertFalse(controller.isReady)
        
        senderMock.result = .success(())
        timerMock.fire()
        
        wait(for: [isReadyCalled], timeout: 0.1)

        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testURLError() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.networkError(URLError(.cannotConnectToHost)))
        
        controller.sendBatch(of: events, with: contextId)
        
        XCTAssertNotNil(timerMock.passedInterval)
        XCTAssertFalse(storageMock.batchRemoved)
        XCTAssertFalse(controller.isReady)
        
        senderMock.result = .success(())
        timerMock.fire()
        
        wait(for: [isReadyCalled], timeout: 0.1)

        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testNotConfiguredError() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.notConfigured)
        
        controller.sendBatch(of: events, with: contextId)
        
        XCTAssertNotNil(timerMock.passedInterval)
        XCTAssertFalse(storageMock.batchRemoved)
        XCTAssertFalse(controller.isReady)
        
        senderMock.result = .success(())
        timerMock.fire()
        
        wait(for: [isReadyCalled], timeout: 0.1)

        XCTAssertNotNil(storageMock.savedBatch)
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testMaxRetry() {
        controller.configurationFinished()

        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        
        var retryCount = 0
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .failure(.notConfigured)
        
        controller.sendBatch(of: events, with: contextId)
        
        repeat {
            timerMock.passedInterval = nil
            timerMock.fireAndWait()
            retryCount += 1
            
            if retryCount > 10 {
                XCTAssert(false)
            }
        } while timerMock.passedInterval != nil
        
        XCTAssertEqual(retryCount, 10)
        
        wait(for: [isReadyCalled], timeout: 0.1)
        
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testSendOldBatch() {
        storageMock.batchToLoad = Batch.mock()
        senderMock.result = .failure(.noInternet)
        
        controller.configurationFinished()
        
        XCTAssertFalse(controller.isReady)
        XCTAssertNil(composerMock.events)
        XCTAssertNil(composerMock.contextId)
        XCTAssertNotNil(senderMock.batch)
        XCTAssert(storageMock.eventIds.isEmpty)
        
        senderMock.result = .success(())
        let isReadyCalled = expectation(description: "Is Ready called")
        controller.isReadyCallback = isReadyCalled.fulfill
        timerMock.fire()
        
        wait(for: [isReadyCalled], timeout: 0.1)
        
        XCTAssert(storageMock.batchRemoved)
        XCTAssert(controller.isReady)
    }
    
    func testNoSendWithoutConfig() {
        let isReadyCalled = expectation(description: "Is Ready called")
        isReadyCalled.isInverted = true
        controller.isReadyCallback = isReadyCalled.fulfill
        
        XCTAssertFalse(controller.isReady)
        
        let contextId = UUID()
        let events = [UUID(): BatchEvent.mock()]
        
        senderMock.result = .success(())
        
        controller.sendBatch(of: events, with: contextId)
        
        wait(for: [isReadyCalled], timeout: 0.1)
        
        XCTAssertNil(senderMock.batch)
        XCTAssertFalse(storageMock.batchRemoved)
        XCTAssertFalse(controller.isReady)
    }
}
