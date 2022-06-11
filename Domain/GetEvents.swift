//
//  GetEvents.swift
//  Domain
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

public protocol GetEvents {
    func get(completion: @escaping (Result<EventModel, Error>) -> Void)
}
