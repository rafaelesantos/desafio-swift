//
//  GetEventDetailSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation
import Domain

class GetEventDetailSpy: GetEventDetail {
    var completion: ((GetEventDetail.Result) -> Void)?
    
    func getEventDetail(eventID: String, completion: @escaping (GetEventDetail.Result) -> Void) {
        self.completion = completion
    }
    
    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }
    
    func completeWithSuccess(_ event: EventModel) {
        completion?(.success(event))
    }
}
