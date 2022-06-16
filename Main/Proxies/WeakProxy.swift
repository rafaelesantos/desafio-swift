//
//  WeakProxy.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Presentation
import Domain

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

extension WeakProxy: EventDetailProtocol where T: EventDetailProtocol {
    func recieved(eventDetail: EventModel) {
        instance?.recieved(eventDetail: eventDetail)
    }
}

extension WeakProxy: ImageLoaderProtocol where T: ImageLoaderProtocol {
    var loader: ImageLoader {
        get { return instance!.loader }
        set(newValue) { instance!.loader = newValue }
    }
    
    func load(with url: URL, for completion: @escaping (Result<Data, DomainError>) -> Void, completionDefer: @escaping () -> Void, completionToken: (UUID) -> Void, completionLoading: @escaping (LoadingModel) -> Void) {
        instance?.load(with: url, for: completion, completionDefer: completionDefer, completionToken: completionToken, completionLoading: completionLoading)
    }
    
    func cancel(completionUUID: () -> UUID?, completion: () -> Void) {
        instance?.cancel(completionUUID: completionUUID, completion: completion)
    }
}
