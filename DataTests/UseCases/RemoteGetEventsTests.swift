//
//  RemoteGetEventsTests.swift
//  DataTests
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
}

extension RemoteGetEventsTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteGetEvents, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteGetEvents(url: url, httpGetClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }
    
    func makeInvalidData() -> Data {
        return Data("invalid_data".utf8)
    }
    
    func makeUrl() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    func makeEventsModel() -> [EventModel] {
        return [
            EventModel(
                date: 0,
                id: "any-id",
                image: "any-image",
                latitude: 0,
                longitude: 0,
                people: [],
                price: 0,
                title: "any-title",
                welcomeDescription: "any-description"
            )
        ]
    }
    
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
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
    
    class HttpClientSpy: HttpGetClient {
        var urls = [URL]()
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func get(url: URL, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}
