//
//  UIImageLoader.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UIKit
import Presentation

public final class UIImageLoader {
    private let viewModel: ImageLoaderViewModel
    private var uuidMap = [UIImageView: UUID]()
    
    public init(viewModel: ImageLoaderViewModel) {
        self.viewModel = viewModel
    }
    
    func load(_ url: URL, for imageView: UIImageView) {
        viewModel.load(with: url) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                imageView.image = UIImage(data: data)
                NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalToConstant: 80)])
            case .failure:
                NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalToConstant: 0)])
            }
        } completionDefer: { [weak self] in
            guard let self = self else { return }
            self.uuidMap.removeValue(forKey: imageView)
        } completionToken: { token in
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        viewModel.cancel {
            return uuidMap[imageView]
        } completion: {
            uuidMap.removeValue(forKey: imageView)
        }
    }
}
