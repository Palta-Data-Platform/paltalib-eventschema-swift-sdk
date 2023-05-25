//
//  EventFacadeMock.swift
//  
//
//  Created by Vyacheslav Beltyukov on 25/05/2023.
//

import Foundation
import PaltaAnalyticsModel
@testable import PaltaAnalytics

final class EventFacadeMock: EventFacade {
    var event: (any Event)?
    var header: Data?
    var payload: Data?
    
    var onEventSet: (() -> Void)?
    
    func logEvent(_ incomingEvent: some Event) {
        self.event = incomingEvent
    }
    
    func logEvent(with header: Data?, and payload: Data) {
        self.header = header
        self.payload = payload
        
        onEventSet?()
    }
}
