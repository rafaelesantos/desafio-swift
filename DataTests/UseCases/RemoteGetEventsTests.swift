//
//  RemoteGetEventsTests.swift
//  DataTests
//
//  Created by Rafael Escaleira on 11/06/22.
//

import XCTest
import Data

class RemoteGetEventsTests: XCTestCase {
    func testGetEventsShouldCallHttpClientWithCorrectUrl() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.getEvents() { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func testGetEventsShouldCompleteWithErrorIfClientFails() {
            let (sut, httpClientSpy) = makeSut()
            let exp = expectation(description: "waiting")
            sut.getEvents() { error in
                XCTAssertEqual(error, .unexpected)
                exp.fulfill()
            }
            httpClientSpy.completeWithError(.noConnectivity)
            wait(for: [exp], timeout: 1)
        }
}

extension RemoteGetEventsTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteGetEvents, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteGetEvents(url: url, httpGetClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    class HttpClientSpy: HttpGetClient {
        var urls = [URL]()
        var completion: ((HttpError) -> Void)?

        func get(url: URL, completion: @escaping (HttpError) -> Void) {
            self.urls.append(url)
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(error)
        }
    }
}
