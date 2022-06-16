//
//  UIViewExtensions.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UIKit

extension UIView {
    func constraintsForAnchoringTo(boundsOf view: UIView, constant: CGFloat = 15) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant)
        ]
    }
    
    func constraintAspectRatio(ratio: (CGFloat, CGFloat)) -> [NSLayoutConstraint] {
        return [
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio.1 / ratio.0)
        ]
    }
}
