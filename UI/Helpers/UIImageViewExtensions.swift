//
//  UIImageViewExtensions.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UIKit
import Presentation

extension UIImageView {
    func loadImage(at url: URL, with loader: UIImageLoader, completion: @escaping (Bool) -> Void) {
        loader.load(url, for: self, completion: completion)
    }
    
    func cancelImageLoad(with loader: UIImageLoader) {
        loader.cancel(for: self)
    }
    
    func addParallax() {
        let amount = 30

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
