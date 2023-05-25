//
//  WebviewObserver.swift
//  
//
//  Created by Vyacheslav Beltyukov on 25/05/2023.
//

import Foundation
import WebKit

final class WebviewObserver: NSObject {
    private let eventFacade: EventFacade
    
    init(eventFacade: EventFacade) {
        self.eventFacade = eventFacade
    }
    
    func attach(to webview: WKWebView) {
        webview.configuration.userContentController.add(self, name: "PaltaBrainEventScheme")
    }
}

extension WebviewObserver: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            let content = message.body as? [String: Any],
            let payloadStr = content["payload"] as? String,
            let payloadData = Data(base64Encoded: payloadStr)
        else {
            return
        }
        
        let headerData = content["header"].flatMap { $0 as? String }.flatMap { Data(base64Encoded: $0) }
        
        eventFacade.logEvent(
            with: headerData,
            and: payloadData
        )
    }
}
