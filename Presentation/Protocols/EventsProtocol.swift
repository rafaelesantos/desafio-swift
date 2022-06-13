//
//  EventsProtocol.swift
//  Presentation
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Domain

public protocol EventsProtocol {
    func recieved(events: [EventModel])
}