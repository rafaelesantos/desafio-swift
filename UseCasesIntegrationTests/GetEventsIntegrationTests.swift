//
//  GetEventsIntegrationTests.swift
//  GetEventsIntegrationTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest
import Data
import Infra
import Domain

class GetEventsIntegrationTests: XCTestCase {
    func testGetEvents() {
        let networkAdapter = NetworkAdapter()
        let url = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!
        let sut = RemoteGetEvents(url: url, httpGetClient: networkAdapter)
        let exp = expectation(description: "waiting")
        sut.getEvents() { result in
            switch result {
            case .failure: XCTFail("Expect success got \(result) instead")
            case .success(let events):
                XCTAssertNotNil(events)
                XCTAssertNotNil(events.first?.id)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
