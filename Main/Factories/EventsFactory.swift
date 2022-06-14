//
//  EventsFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UI
import Presentation
import Data
import Infra
import Domain

class EventsFactory {
    static func makeController() -> EventsViewController {
        let controller = EventsViewController()
        let url = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!
        let networkAdapter = NetworkAdapter()
        let getEvents = RemoteGetEvents(url: url, httpGetClient: networkAdapter)
        let presenter = EventsViewModel(alert: controller, loading: controller, getEvents: getEvents, events: controller)
        controller.getAllEvents = presenter.getAllEvents
        return controller
    }
}

extension EventsViewController: EventsProtocol {
    public func recieved(events: [EventModel]) {
        
    }
}
