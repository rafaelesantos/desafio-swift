//
//  UIImageViewExtensions.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import RxSwift
import UIKit
import Presentation

extension UIImageView {
    func loadImage(at url: URL, with uiImageLoader: UIImageLoader) -> Observable<Bool> {
        uiImageLoader.load(url, for: self)
        return uiImageLoader.completePublishSubject.asObserver().observe(on: MainScheduler.instance)
    }
    
    func cancelImageLoad(with uiImageLoader: UIImageLoader) {
        uiImageLoader.cancel(for: self)
    }
}
