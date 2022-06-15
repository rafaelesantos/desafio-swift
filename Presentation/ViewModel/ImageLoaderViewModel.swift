//
//  ImageLoaderViewModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Domain

public class ImageLoaderViewModel {
    private let loading: LoadingProtocol
    private let imageLoader: ImageLoaderProtocol
    
    public init(loading: LoadingProtocol, imageLoader: ImageLoaderProtocol) {
        self.loading = loading
        self.imageLoader = imageLoader
    }

    public func load(with url: URL, for completion: @escaping (ImageLoader.Result) -> Void, completionDefer: @escaping () -> Void, completionToken: (UUID) -> Void) {
        loading.display(with: .init(isLoading: true))
        imageLoader.load(with: url, for: completion, completionDefer: completionDefer, completionToken: completionToken) { [weak self] loadingModel in
            guard let self = self else { return }
            self.loading.display(with: loadingModel)
        }
    }
    
    public func cancel(completionUUID: () -> UUID?, completion: () -> Void) {
        imageLoader.cancel(completionUUID: completionUUID) { [weak self] in
            guard let self = self else { return }
            self.loading.display(with: .init(isLoading: false))
            completion()
        }
    }
}
