//
//  StorableEvent.swift
//  PaltaAnalytics
//
//  Created by Vyacheslav Beltyukov on 17/06/2022.
//

import Foundation
import PaltaAnalyticsPrivateModel

struct StorableEvent {
    private struct Container: Codable {
        let eventData: Data
        let eventId: UUID
        let contextId: UUID
    }
    
    let event: IdentifiableEvent
    let contextId: UUID
    
    init(data: Data) throws {
        let container = try JSONDecoder().decode(Container.self, from: data)
        
        self.event = IdentifiableEvent(
            id: container.eventId,
            event: try BatchEvent(data: container.eventData)
        )
        self.contextId = container.contextId
    }
    
    init(event: IdentifiableEvent, contextId: UUID) {
        self.event = event
        self.contextId = contextId
    }
    
    func serialize() throws -> Data {
        let container = Container(
            eventData: try event.event.serialize(),
            eventId: event.id,
            contextId: contextId
        )
        
        return try JSONEncoder().encode(container)
    }
}
