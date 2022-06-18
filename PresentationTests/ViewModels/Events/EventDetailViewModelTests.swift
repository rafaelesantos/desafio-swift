//
//  EventDetailViewModelTests.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 15/06/22.
//

import XCTest
import Domain
import Presentation

class EventDetailViewModelTests: XCTestCase {
    func testEventDetailShouldShowErrorMessageIfGetEventsFails() {
        let alertSpy = AlertSpy()
        let getEventDetailSpy = GetEventDetailSpy()
        let sut = makeSut(alert: alertSpy, getEventDetail: getEventDetailSpy)
        let exp = expectation(description: "waiting")
        alertSpy.observe { model in
            XCTAssertEqual(model, makeErrorAlertModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            exp.fulfill()
        }
        sut.get(with: "1")
        getEventDetailSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func testEventDetailShouldShowLoadingBeforeAndAfterGetEvents() {
        let loadingSpy = LoadingSpy()
        let getEventDetailSpy = GetEventDetailSpy()
        let sut = makeSut(loading: loadingSpy, getEventDetail: getEventDetailSpy)
        let exp = expectation(description: "waiting")
        loadingSpy.observe { model in
            XCTAssertEqual(model, .init(isLoading: true))
            exp.fulfill()
        }
        sut.get(with: "1")
        wait(for: [exp], timeout: 1)
        let exp2 = expectation(description: "waiting")
        loadingSpy.observe { model in
            XCTAssertEqual(model, .init(isLoading: false))
            exp2.fulfill()
        }
        getEventDetailSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
    
    func testEventDetailShouldShowAllEventsIfGetEventsSucceeds() {
        let loadingSpy = LoadingSpy()
        let getEventDetailSpy = GetEventDetailSpy()
        let eventDetailSpy = EventDetailSpy()
        let sut = makeSut(loading: loadingSpy, getEventDetail: getEventDetailSpy, eventDetail: eventDetailSpy)
        let exp = expectation(description: "waiting")
        eventDetailSpy.observe { event in
            XCTAssertEqual(makeEventDetailModel(), event)
            exp.fulfill()
        }
        sut.get(with: "1")
        getEventDetailSpy.completeWithSuccess(makeEventDetailModel())
        wait(for: [exp], timeout: 1)
    }
}

extension EventDetailViewModelTests {
    func makeSut(alert: AlertSpy = AlertSpy(), loading: LoadingSpy = LoadingSpy(), getEventDetail: GetEventDetailSpy = GetEventDetailSpy(), eventDetail: EventDetailSpy = EventDetailSpy(), addCheckIn: AddCheckIn = AddCheckInSpy(), checkIn: CheckInSpy = CheckInSpy(), file: StaticString = #file, line: UInt = #line) -> EventDetailViewModel {
        let sut = EventDetailViewModel(
            alert: alert,
            loading: loading,
            getEventDetail: getEventDetail,
            eventDetail: eventDetail,
            addCheckIn: addCheckIn,
            checkIn: checkIn
        )
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
