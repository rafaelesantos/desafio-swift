//
//  MainQueueDispatchDecorator.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import RxSwift
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
    public func get() -> Observable<[EventModel]> {
        instance.get().observe(on: MainScheduler.instance)
    }
}

extension MainQueueDispatchDecorator: GetEventDetail where T: GetEventDetail {
    public func get(with eventID: String) -> Observable<EventModel> {
        instance.get(with: eventID).observe(on: MainScheduler.instance)
    }
}

extension MainQueueDispatchDecorator: AddCheckIn where T: AddCheckIn {
    public func add(with model: AddCheckInModel) -> Observable<CheckInModel> {
        instance.add(with: model).observe(on: MainScheduler.instance)
    }
}
