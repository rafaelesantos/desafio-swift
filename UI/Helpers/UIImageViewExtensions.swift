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
}
