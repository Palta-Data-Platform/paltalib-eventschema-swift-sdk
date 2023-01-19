//
//  BatchComposerMock.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 29/06/2022.
//

import Foundation
import PaltaAnalyticsPrivateModel
@testable import PaltaAnalytics

final class BatchComposerMock: BatchComposer {
    var events: [BatchEvent]?
    var contextId: UUID?
    
    func makeBatch(of events: [BatchEvent], with contextId: UUID) -> Batch {
        self.events = events
        self.contextId = contextId
        
        return Batch()
    }
}
