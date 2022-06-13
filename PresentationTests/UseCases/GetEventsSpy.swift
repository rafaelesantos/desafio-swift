//
//  GetEventsSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Domain

class GetEventsSpy: GetEvents {
    var completion: ((Result<[EventModel], DomainError>) -> Void)?
    
    func getEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
        self.completion = completion
    }
    
    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }
    
    func completeWithSuccess(_ events: [EventModel]) {
        completion?(.success(events))
    }
}
