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
    
    func testCallsGetAllEventsOnSetupUI() {
        var hasCompletion = false
        let sut = makeSut { hasCompletion = true }
        sut.viewDidLoad()
        XCTAssertTrue(hasCompletion)
    }
}

extension EventsViewControllerTests {
    func makeSut(getAllEventsSpy: (() -> Void)? = nil) -> EventsViewController {
        let sut = EventsViewController()
        sut.getAllEvents = getAllEventsSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
