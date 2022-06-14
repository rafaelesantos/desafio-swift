//
//  WeakProxy.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Presentation

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
    func recieved(events: [EventModel]) {
        instance?.recieved(events: events)
    }
}
