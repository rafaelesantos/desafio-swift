//
//  EventsComposersTests.swift
//  MainTests
//
//  Created by Rafael Escaleira on 14/06/22.
//

import XCTest
import Main
import UI
import Domain

class EventsComposersTests: XCTestCase {
    func testBackgroundRequestShouldCompleteOnMainThread() {
        let (sut, getEventsSpy) = makeSut()
        sut.loadViewIfNeeded()
        sut.getAllEvents?()
        let exp = expectation(description: "waiting")
        DispatchQueue.global().async {
            getEventsSpy.completeWithError(.unexpected)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension EventsComposersTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: EventsViewController, getEventsSpy: GetEventsSpy) {
        let getEventsSpy = GetEventsSpy()
        let imageLoaderSpy = ImageLoaderSpy()
        let sut = makeEventsController(getEvents: MainQueueDispatchDecorator(getEventsSpy), imageLoader: MainQueueDispatchDecorator(imageLoaderSpy))
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: getEventsSpy, file: file, line: line)
        return (sut, getEventsSpy)
    }
}
