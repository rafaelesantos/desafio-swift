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

class WeakProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(_ instance: T) {
        self.instance = instance
    }
}

extension WeakProxy: AlertProtocol where T: AlertProtocol {
    func show(with model: AlertModel) {
        instance?.show(with: model)
    }
}

extension WeakProxy: LoadingProtocol where T: LoadingProtocol {
    func display(with model: LoadingModel) {
        instance?.display(with: model)
    }
}

extension WeakProxy: EventsProtocol where T: EventsProtocol {
    func recieved(events: Events) {
        instance?.recieved(events: events)
    }
}
