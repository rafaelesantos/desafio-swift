//
//  DataTests.swift
//  DataTests
//
//  Created by Rafael Escaleira on 11/06/22.
//

import XCTest

class RemoteGetEvents {
    private let url: URL
    private let httpGetClient: HttpGetClient

    init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }

    func getEvents() {
        httpGetClient.get(url: url)
    }
}

protocol HttpGetClient {
    func get(url: URL)
}

class RemoteGetEventsTests: XCTestCase {
    func testGetEventsShouldCallHttpClientWithCorrectUrl() {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteGetEvents(url: url, httpGetClient: httpClientSpy)
        sut.getEvents()
        XCTAssertEqual(httpClientSpy.url, url)
    }
}

extension RemoteGetEventsTests {
    class HttpClientSpy: HttpGetClient {
        var url: URL?

        func get(url: URL) {
            self.url = url
        }
    }
}
