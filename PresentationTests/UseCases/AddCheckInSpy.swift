//
//  AddCheckInSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 18/06/22.
//

import Foundation
import Domain

class AddCheckInSpy: AddCheckIn {
    var completion: ((AddCheckIn.Result) -> Void)?
    
    func add(addCheckInModel: AddCheckInModel, completion: @escaping (AddCheckIn.Result) -> Void) {
        self.completion = completion
    }
    
    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }
    
    func completeWithSuccess(_ event: CheckInModel) {
        completion?(.success(event))
    }
}
