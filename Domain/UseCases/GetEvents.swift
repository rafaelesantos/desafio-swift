//
//  GetEvents.swift
//  Domain
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

public protocol GetEvents {
    typealias Result = Swift.Result<[EventModel], DomainError>
    func getEvents(completion: @escaping (Result) -> Void)
}
