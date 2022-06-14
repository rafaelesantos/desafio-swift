//
//  GetEventsSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Domain

class GetEventsSpy: GetEvents {
    var completion: ((GetEvents.Result) -> Void)?
    
    func getEvents(completion: @escaping (GetEvents.Result) -> Void) {
        self.completion = completion
    }
    
    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }
    
    func completeWithSuccess(_ events: [EventModel]) {
        completion?(.success(events))
    }
}
