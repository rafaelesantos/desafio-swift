//
//  NavigationController.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UIKit

public final class NavigationController: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        navigationBar.isTranslucent = true
        navigationBar.prefersLargeTitles = true
    }
}
