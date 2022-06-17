//
//  AddCheckIn.swift
//  Domain
//
//  Created by Rafael Escaleira on 16/06/22.
//

import Foundation

public protocol AddCheckIn {
    typealias Result = Swift.Result<Data, DomainError>
    func add(addCheckInModel: AddCheckInModel, completion: @escaping (Result) -> Void)
}

public struct AddCheckInModel: Model {
    public var name: String
    public var email: String
    public var eventId: String
    
    public init(name: String, email: String, eventId: String) {
        self.name = name
        self.email = email
        self.eventId = eventId
    }
}
