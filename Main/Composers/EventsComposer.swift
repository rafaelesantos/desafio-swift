//
//  EventsComposer.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Domain
import UI

final class EventsComposer {
    static func composeControllerWith(getEvents: GetEvents) -> EventsViewController {
        return ControllerFactory.makeEvents(getEvents: getEvents)
    }
}
