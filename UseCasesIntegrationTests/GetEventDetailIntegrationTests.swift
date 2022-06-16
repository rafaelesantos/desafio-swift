//
//  GetEventDetailIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by Rafael Escaleira on 16/06/22.
//

import XCTest
import Data
import Infra
import Domain

class GetEventDetailIntegrationTests: XCTestCase {
    func testGetEvents() {
        let networkAdapter = NetworkAdapter()
        let url = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events/")!
        let sut = RemoteGetEventDetail(url: url, httpClient: networkAdapter)
        let exp = expectation(description: "waiting")
        sut.getEventDetail(eventID: "1") { result in
            switch result {
            case .failure: XCTFail("Expect success got \(result) instead")
            case .success(let event):
                XCTAssertNotNil(event)
                XCTAssertNotNil(event.id)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
