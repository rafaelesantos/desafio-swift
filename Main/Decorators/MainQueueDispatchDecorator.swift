//
//  MainQueueDispatchDecorator.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Domain

public final class MainQueueDispatchDecorator<T> {
    private let instance: T

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
