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
        let exp = expectation(description: "waiting")
        sut.getEvents() { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func testGetEventsShouldCompleteWithEventsIfClientCompletesWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedEvents = makeEventsModel()
        sut.getEvents() { result in
            switch result {
            case .failure: XCTFail("Expected success received \(result) instead")
            case .success(let receivedAccount): XCTAssertEqual(receivedAccount, expectedEvents)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(expectedEvents.toData()!)
        wait(for: [exp], timeout: 1)
    }
    
    func testGetEventsShouldCompleteWithEventsIfClientCompletesWithInvalidData() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.getEvents() { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(Data("invalid_data".utf8))
        wait(for: [exp], timeout: 1)
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
