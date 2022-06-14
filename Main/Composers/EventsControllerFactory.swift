//
//  EventsControllerFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UI
import Presentation
import Domain

public func makeEventsController(getEvents: GetEvents) -> EventsViewController {
    let controller = EventsViewController()
    let viewModel = EventsViewModel(alert: WeakProxy(controller), loading: WeakProxy(controller), getEvents: getEvents, events: WeakProxy(controller))
    controller.getAllEvents = viewModel.getAllEvents
    return controller
}
