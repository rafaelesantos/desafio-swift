//
//  MainQueueDispatchDecorator.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Domain

public final class MainQueueDispatchDecorator<T> {
    private var instance: T

    public init(_ instance: T) {
        self.instance = instance
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}

extension MainQueueDispatchDecorator: GetEvents where T: GetEvents {
    public func getEvents(completion: @escaping (GetEvents.Result) -> Void) {
        instance.getEvents { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: GetEventDetail where T: GetEventDetail {
    public func getEventDetail(eventID: String, completion: @escaping (GetEventDetail.Result) -> Void) {
        instance.getEventDetail(eventID: eventID) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: ImageLoader where T: ImageLoader {
    public var loadedImages: [URL : Data] {
        get { return instance.loadedImages }
        set(newValue) { instance.loadedImages = newValue }
    }
    
    public var runningRequests: [UUID : URLSessionDataTask] {
        get { return instance.runningRequests }
        set(newValue) { instance.runningRequests = newValue }
    }
    
    public func cancelLoad(_ uuid: UUID) {
        instance.cancelLoad(uuid)
    }
    
    public func loadImage(with url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> UUID? {
        instance.loadImage(with: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
