//
//  AddCheckIn.swift
//  Domain
//
//  Created by Rafael Escaleira on 16/06/22.
//

import Foundation
import RxSwift

public protocol AddCheckIn {
    func add(with model: AddCheckInModel) -> Observable<CheckInModel>
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
