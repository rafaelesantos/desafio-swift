//
//  DataTests.swift
//  DataTests
//
//  Created by Rafael Escaleira on 11/06/22.
//

import XCTest
import Data

class RemoteGetEventsTests: XCTestCase {
    func testGetEventsShouldCallHttpClientWithCorrectUrl() {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteGetEvents(url: url, httpGetClient: httpClientSpy)
        sut.getEvents()
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
}

extension RemoteGetEventsTests {
    class HttpClientSpy: HttpGetClient {
        var urls = [URL]()

        func get(url: URL) {
            self.urls.append(url)
        }
    }
}
