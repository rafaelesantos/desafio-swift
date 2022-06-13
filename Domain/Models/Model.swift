//
//  Model.swift
//  Domain
//
//  Created by Rafael Escaleira on 12/06/22.
//

import Foundation

public protocol Model: Codable, Equatable { }

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

public extension Array where Element: Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
