//
//  LoadingSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Presentation

class LoadingSpy: LoadingProtocol {
    var model: LoadingModel?
    var emit: ((LoadingModel) -> Void)?
    
    func observe(completion: @escaping (LoadingModel) -> Void) {
        self.emit = completion
    }
    
    func display(with model: LoadingModel) {
        self.emit?(model)
    }
}
