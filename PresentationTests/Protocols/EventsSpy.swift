//
//  EventsSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Presentation
import Domain

class EventsSpy: EventsProtocol {
    var events: [EventModel]?
    var emit: (([EventModel]) -> Void)?
    
    func observe(completion: @escaping ([EventModel]) -> Void) {
        self.emit = completion
    }
    
    func recieved(events: [EventModel]) {
        self.emit?(events)
    }
}
