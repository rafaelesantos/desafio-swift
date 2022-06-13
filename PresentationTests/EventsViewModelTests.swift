//
//  EventsViewModelTests.swift
//  EventsViewModelTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest
import Domain
import Presentation

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

// MARK: Make

extension EventsViewModelTests {
    func makeSut(alert: AlertSpy = AlertSpy(), getEvents: GetEventsSpy = GetEventsSpy(), file: StaticString = #file, line: UInt = #line) -> EventsViewModel {
        let sut = EventsViewModel(alert: alert, getEvents: getEvents)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func makeErrorAlertModel(message: String) -> AlertModel {
        return AlertModel(title: "Erro", message: message)
    }
}

// MARK: - Spy

extension EventsViewModelTests {
    class AlertSpy: AlertProtocol {
        var model: AlertModel?
        var emit: ((AlertModel) -> Void)?
        
        func observe(completion: @escaping (AlertModel) -> Void) {
            self.emit = completion
        }
        
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
