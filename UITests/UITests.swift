//
//  UITests.swift
//  UITests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest
import UIKit
import Presentation
@testable import UI

class UITests: XCTestCase {
    func testLoadingIsHiddenOnStart() {
        let sut = EventsViewController()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.activityIndicatorView.isAnimating, false)
    }
    
    func testSutImplementsLoadingProtocol() {
        let sut = EventsViewController()
        XCTAssertNotNil(sut as LoadingProtocol)
    }
}
