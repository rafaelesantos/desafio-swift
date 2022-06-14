//
//  EventsViewControllerTests.swift
//  UITests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest
import UIKit
import Presentation
@testable import UI

class EventsViewControllerTests: XCTestCase {
    func testLoadingIsHiddenOnStart() {
        XCTAssertEqual(makeSut().activityIndicatorView.isAnimating, false)
    }
    
    func testSutImplementsLoadingProtocol() {
        XCTAssertNotNil(makeSut() as LoadingProtocol)
    }
    
    func testSutImplementsAlertProtocol() {
        XCTAssertNotNil(makeSut() as AlertProtocol)
    }
    
    func testSutImplementsEventsProtocol() {
        XCTAssertNotNil(makeSut() as EventsProtocol)
    }
}

extension EventsViewControllerTests {
    func makeSut() -> EventsViewController {
        let sut = EventsViewController()
        sut.loadViewIfNeeded()
        return sut
    }
}
