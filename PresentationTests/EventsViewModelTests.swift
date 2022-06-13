//
//  EventsViewModelTests.swift
//  EventsViewModelTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest
import Domain
import Data

class EventsViewModel {
    private let alert: AlertProtocol
    private let getEvents: GetEvents
    
    init(alert: AlertProtocol, getEvents: GetEvents) {
        self.alert = alert
        self.getEvents = getEvents
    }

    func getAllEvents() {
        getEvents.getEvents { result in
            switch result {
            case .failure: self.alert.show(with: AlertModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            case .success: break
            }
        }
    }
}

protocol AlertProtocol {
    func show(with model: AlertModel)
}

struct AlertModel: Equatable {
    var title: String
    var message: String
}

class EventsViewModelTests: XCTestCase {
    func testListEventsShouldShowErrorMessageIfGetEventsFails() {
        let alertSpy = AlertSpy()
        let getEventsSpy = GetEventsSpy()
        let sut = makeSut(alert: alertSpy, getEvents: getEventsSpy)
        sut.getAllEvents()
        getEventsSpy.completeWithError(.unexpected)
        XCTAssertEqual(alertSpy.model, makeErrorAlertModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
    }
}

extension EventsViewModelTests {
    func makeSut(alert: AlertSpy = AlertSpy(), getEvents: GetEventsSpy = GetEventsSpy()) -> EventsViewModel {
        let sut = EventsViewModel(alert: alert, getEvents: getEvents)
        return sut
    }
    
    func makeErrorAlertModel(message: String) -> AlertModel {
        return AlertModel(title: "Erro", message: message)
    }
    
    class AlertSpy: AlertProtocol {
        var model: AlertModel?
        
        func show(with model: AlertModel) {
            self.model = model
        }
    }
    
    class GetEventsSpy: GetEvents {
        var completion: ((Result<[EventModel], DomainError>) -> Void)?
        
        func getEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
            self.completion = completion
        }
        
        func completeWithError(_ error: DomainError) {
            completion?(.failure(error))
        }
    }
}
