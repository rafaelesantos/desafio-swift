//
//  CheckInProtocol.swift
//  Presentation
//
//  Created by Rafael Escaleira on 18/06/22.
//

import Foundation
import Domain

public typealias CheckInModel = Domain.CheckInModel

public protocol CheckInProtocol {
    func recieved(checkIn: CheckInModel)
}
