//
//  PaltaAnalytics+Webview.swift
//  
//
//  Created by Vyacheslav Beltyukov on 25/05/2023.
//

import Foundation
import WebKit

extension PaltaAnalytics {
    func connect(to webview: WKWebView) {
        let observer = assembly?.eventQueueAssembly.makeWebviewObserver()
        observer?.attach(to: webview)
    }
}
