//
//  UITests.swift
//  UITests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest
import UIKit
@testable import UI

class UITests: XCTestCase {
    func testLoadingIsHiddenOnStart() {
        let sut = EventsViewController()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.activityIndicatorView.isAnimating, false)
    }
}
