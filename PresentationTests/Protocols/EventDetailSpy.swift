//
//  EventDetailSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation
import Presentation
import Domain

class EventDetailSpy: EventDetailProtocol {
    var event: EventModel?
    var emit: ((EventModel) -> Void)?
    
    func observe(completion: @escaping (EventModel) -> Void) {
        self.emit = completion
    }
    
    func recieved(eventDetail: EventModel) {
        self.emit?(eventDetail)
    }
}
