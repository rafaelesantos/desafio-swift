//
//  GetEventDetail.swift
//  Domain
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation

public protocol GetEventDetail {
    typealias Result = Swift.Result<EventModel, DomainError>
    func getEventDetail(completion: @escaping (Result) -> Void)
}
