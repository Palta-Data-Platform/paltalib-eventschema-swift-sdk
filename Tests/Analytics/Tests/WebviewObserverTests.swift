//
//  WebviewObserverTests.swift
//  
//
//  Created by Vyacheslav Beltyukov on 25/05/2023.
//

import Foundation
import XCTest
import WebKit
@testable import PaltaAnalytics

final class WebviewObserverTests: XCTestCase {
    var facadeMock: EventFacadeMock!
    var webview: WKWebView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        facadeMock = .init()
        webview = .init()
        
        let observer = WebviewObserver(eventFacade: facadeMock)
        
        observer.attach(to: webview)
        webview.load(URLRequest(url: URL(string: "https://example.com")!))
    }
    
    func testFullMessage() {
        let eventLogged = self.expectation(description: "Event logged")
        facadeMock.onEventSet = eventLogged.fulfill
        
        webview.evaluateJavaScript(
            "window.webkit.messageHandlers.PaltaBrainEventScheme.postMessage({\"header\": \"QmlsbGlvbmFpcmUsIHBsYXlib3ksIHBoaWxhbnRocm9waXN0\", \"payload\": \"SSdtIElyb24gbWFu\"})"
        )
        
        wait(for: [eventLogged], timeout: 10)
        
        XCTAssertEqual(facadeMock.header, "Billionaire, playboy, philanthropist".data(using: .utf8))
        XCTAssertEqual(facadeMock.payload, "I'm Iron man".data(using: .utf8))
    }
    
    func testNoHeaderMessage() {
        let eventLogged = self.expectation(description: "Event logged")
        facadeMock.onEventSet = eventLogged.fulfill
        
        webview.evaluateJavaScript(
            "window.webkit.messageHandlers.PaltaBrainEventScheme.postMessage({\"header\": null, \"payload\": \"SSdtIElyb24gbWFu\"})"
        )
        
        wait(for: [eventLogged], timeout: 10)
        
        XCTAssertNil(facadeMock.header)
        XCTAssertEqual(facadeMock.payload, "I'm Iron man".data(using: .utf8))
    }
    
    func testSequental() {
        let eventLogged = self.expectation(description: "Event logged")
        eventLogged.expectedFulfillmentCount = 2
        facadeMock.onEventSet = eventLogged.fulfill
        
        webview.evaluateJavaScript(
            "window.webkit.messageHandlers.PaltaBrainEventScheme.postMessage({\"header\": null, \"payload\": \"SSdtIElyb24gbWFu\"})"
        )
        webview.evaluateJavaScript(
            "window.webkit.messageHandlers.PaltaBrainEventScheme.postMessage({\"header\": \"SGVsbG8=\", \"payload\": \"RnVjayB5b3UgaWYgeW91IGRlY29kZWQgaXQh\"})"
        )
        
        wait(for: [eventLogged], timeout: 10)
    }
}
