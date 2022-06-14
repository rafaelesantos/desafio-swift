//
//  UseCaseFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Data
import Infra
import Domain

final class UseCaseFactory {
    private static let httpClient = NetworkAdapter()
    private static let apiBaseUrl = Environment.variable(.apiBaseUrl)
    
    private static func makeUrl(path: String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(path)")!
    }
    
    static func makeRemoteGetEvents() -> GetEvents {
        let remoteGetEvents = RemoteGetEvents(url: makeUrl(path: "events"), httpClient: httpClient)
        return MainQueueDispatchDecorator(remoteGetEvents)
    }
}

public final class RemoteGetEventsDecorator: GetEvents {
    private let instance: GetEvents
    
    public init(_ instance: GetEvents) {
        self.instance = instance
    }
    
    public func getEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
        instance.getEvents { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
