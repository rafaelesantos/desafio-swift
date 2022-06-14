//
//  ControllerFactory.swift
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

final class ControllerFactory {
    static func makeEvents(getEvents: GetEvents) -> EventsViewController {
        let controller = EventsViewController()
        let viewModel = EventsViewModel(alert: WeakProxy(controller), loading: WeakProxy(controller), getEvents: getEvents, events: WeakProxy(controller))
        controller.getAllEvents = viewModel.getAllEvents
        return controller
    }
}
