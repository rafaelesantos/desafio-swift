//
//  UIViewExtensions.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UIKit

extension UIView {
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ]
    }
    
    func constraintAspectRatio(ratio: (CGFloat, CGFloat)) -> [NSLayoutConstraint] {
        return [
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio.1 / ratio.0)
        ]
    }
}
