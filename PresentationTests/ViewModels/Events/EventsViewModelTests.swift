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
        let exp = expectation(description: "waiting")
        alertSpy.observe { model in
            XCTAssertEqual(model, makeErrorAlertModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            exp.fulfill()
        }
        sut.getAllEvents()
        getEventsSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func testListEventsShouldShowLoadingBeforeAndAfterGetEvents() {
        let loadingSpy = LoadingSpy()
        let getEventsSpy = GetEventsSpy()
        let sut = makeSut(loading: loadingSpy, getEvents: getEventsSpy)
        let exp = expectation(description: "waiting")
        loadingSpy.observe { model in
            XCTAssertEqual(model, .init(isLoading: true))
            exp.fulfill()
        }
        sut.getAllEvents()
        wait(for: [exp], timeout: 1)
        let exp2 = expectation(description: "waiting")
        loadingSpy.observe { model in
            XCTAssertEqual(model, .init(isLoading: false))
            exp2.fulfill()
        }
        getEventsSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
    
    func testListEventsShouldShowAllEventsIfGetEventsSucceeds() {
        let loadingSpy = LoadingSpy()
        let getEventsSpy = GetEventsSpy()
        let eventsSpy = EventsSpy()
        let sut = makeSut(loading: loadingSpy, getEvents: getEventsSpy, events: eventsSpy)
        let exp = expectation(description: "waiting")
        eventsSpy.observe { events in
            XCTAssertEqual(makeEventsModel(), events)
            exp.fulfill()
        }
        sut.getAllEvents()
        getEventsSpy.completeWithSuccess(makeEventsModel())
        wait(for: [exp], timeout: 1)
    }
}

extension EventsViewModelTests {
    func makeSut(alert: AlertSpy = AlertSpy(), loading: LoadingSpy = LoadingSpy(), getEvents: GetEventsSpy = GetEventsSpy(), events: EventsSpy = EventsSpy(), file: StaticString = #file, line: UInt = #line) -> EventsViewModel {
        let sut = EventsViewModel(alert: alert, loading: loading, getEvents: getEvents, events: events)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
