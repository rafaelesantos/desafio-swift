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
        let url = URL(string: "http://any-url.com")!
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
            httpClientSpy.completeWithData(Data("invalid_data".utf8))
        })
    }
}

extension RemoteGetEventsTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteGetEvents, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteGetEvents(url: url, httpGetClient: httpClientSpy)
        return (sut, httpClientSpy)
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
    
    func expect(_ sut: RemoteGetEvents, completeWith expectedResult: Result<[EventModel], DomainError>, when action: () -> Void) {
        let exp = expectation(description: "waiting")
        sut.getEvents() { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError)
            case (.success(let expectedEvents), .success(let receivedEvents)): XCTAssertEqual(expectedEvents, receivedEvents)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead")
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
