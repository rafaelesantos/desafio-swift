//
//  RemoteGetEventsTests.swift
//  RemoteGetEventsTests
//
//  Created by Rafael Escaleira on 11/06/22.
//

import XCTest
import Data
import Domain

class RemoteGetEventsTests: XCTestCase {
    func testGetEventsShouldCallHttpClientWithCorrectUrl() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.getEvents() { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func testGetEventsShouldCompleteWithErrorIfClientCompletesWithError() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func testGetEventsShouldCompleteWithEventsIfClientCompletesWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let expectedEvents = makeEventsModel()
        expect(sut, completeWith: .success(expectedEvents), when: {
            httpClientSpy.completeWithData(expectedEvents.toData()!)
        })
    }
    
    func testGetEventsShouldCompleteWithEventsIfClientCompletesWithInvalidData() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func testGetEventsShouldNotCompleteIfSutHasBeenDeallocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteGetEvents? = RemoteGetEvents(url: makeUrl(), httpGetClient: httpClientSpy)
        var result: Result<[EventModel], DomainError>?
        sut?.getEvents() { result = $0 }
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteGetEventsTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteGetEvents, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteGetEvents(url: url, httpGetClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }
    
    func expect(_ sut: RemoteGetEvents, completeWith expectedResult: Result<[EventModel], DomainError>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "waiting")
        sut.getEvents() { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedEvents), .success(let receivedEvents)): XCTAssertEqual(expectedEvents, receivedEvents, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
}
