//
//  EventsComposersTests.swift
//  MainTests
//
//  Created by Rafael Escaleira on 14/06/22.
//

import XCTest
import Main

class EventsComposersTests: XCTestCase {
    func testUIPresentationIntegration() {
        let sut = EventsComposer.composeControllerWith(getEvents: GetEventsSpy())
        checkMemoryLeak(for: sut)
    }
}
