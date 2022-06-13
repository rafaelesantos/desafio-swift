//
//  AlertSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Presentation

class AlertSpy: AlertProtocol {
    var model: AlertModel?
    var emit: ((AlertModel) -> Void)?
    
    func observe(completion: @escaping (AlertModel) -> Void) {
        self.emit = completion
    }
    
    func show(with model: AlertModel) {
        self.emit?(model)
    }
}
