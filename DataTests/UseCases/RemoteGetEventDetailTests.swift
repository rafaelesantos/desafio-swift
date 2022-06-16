//
//  RemoteGetEventDetailTests.swift
//  DataTests
//
//  Created by Rafael Escaleira on 15/06/22.
//

import XCTest
import Data
import Domain

class RemoteGetEventDetailTests: XCTestCase {
    func testGetEventDetailShouldCallHttpClientWithCorrectUrl() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.getEventDetail(eventID: makeValidPath()) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url.appendingPathComponent(makeValidPath())])
    }
    
    func testGetEventDetailShouldCompleteWithErrorIfClientCompletesWithError() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func testGetEventDetailShouldCompleteWithEventsIfClientCompletesWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let expectedEvents = makeEventDetailModel()
        expect(sut, completeWith: .success(expectedEvents), when: {
            httpClientSpy.completeWithData(expectedEvents.toData()!)
        })
    }
    
    func testGetEventDetailShouldCompleteWithEventsIfClientCompletesWithInvalidData() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func testGetEventDetailShouldNotCompleteIfSutHasBeenDeallocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteGetEventDetail? = RemoteGetEventDetail(url: makeUrl(), httpClient: httpClientSpy)
        var result: GetEventDetail.Result?
        sut?.getEventDetail(eventID: makeValidPath()) { result = $0 }
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteGetEventDetailTests {
    func makeSut(url: URL = URL(string: "http://any-url.com/")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteGetEventDetail, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteGetEventDetail(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }
    
    func expect(_ sut: RemoteGetEventDetail, completeWith expectedResult: GetEventDetail.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "waiting")
        sut.getEventDetail(eventID: makeValidPath()) { receivedResult in
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
