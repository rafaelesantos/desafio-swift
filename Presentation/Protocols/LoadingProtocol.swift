//
//  LoadingProtocol.swift
//  Presentation
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation

public protocol LoadingProtocol {
    func display(with model: LoadingModel)
}

public struct LoadingModel: Equatable {
    public var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
