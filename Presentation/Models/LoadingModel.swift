//
//  LoadingModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation

public struct LoadingModel: Equatable {
    public var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
