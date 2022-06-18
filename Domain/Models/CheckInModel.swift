//
//  CheckInModel.swift
//  Domain
//
//  Created by Rafael Escaleira on 16/06/22.
//

import Foundation

public struct CheckInModel: Model {
    public var value: String?
    
    public init(value: String? = nil) {
        self.value = value
    }
}
