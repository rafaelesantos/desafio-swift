//
//  GetEvents.swift
//  Domain
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

public protocol GetEvents {
    func getEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void)
}
