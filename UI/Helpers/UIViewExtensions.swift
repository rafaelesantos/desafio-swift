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
    
    func addParallax() {
        let amount = 50

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }
}
