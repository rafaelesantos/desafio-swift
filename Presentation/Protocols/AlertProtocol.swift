//
//  AlertProtocol.swift
//  Presentation
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation

public protocol AlertProtocol {
    func show(with model: AlertModel)
}

public struct AlertModel: Equatable {
    public var title: String
    public var message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
