//
//  CheckInSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 18/06/22.
//

import Foundation
import Presentation
import Domain

class CheckInSpy: CheckInProtocol {
    var event: CheckInModel?
    var emit: ((CheckInModel) -> Void)?
    
    func observe(completion: @escaping (CheckInModel) -> Void) {
        self.emit = completion
    }
    
    func recieved(checkIn: CheckInModel) {
        self.emit?(checkIn)
    }
}
