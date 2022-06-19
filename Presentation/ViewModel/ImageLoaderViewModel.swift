//
//  ImageLoaderViewModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import RxSwift
import Domain

public class ImageLoaderViewModel {
    public let loadingPublishSubject = PublishSubject<LoadingModel>()
    private let imageLoader: ImageLoaderProtocol
    
    public init(imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
    }

    public func load(with url: URL, for completion: @escaping (ImageLoader.Result) -> Void, completionDefer: @escaping () -> Void, completionToken: (UUID) -> Void) {
        imageLoader.load(with: url, for: completion, completionDefer: completionDefer, completionToken: completionToken) { _ in }
    }
    
    public func cancel(completionUUID: () -> UUID?, completion: () -> Void) {
        imageLoader.cancel(completionUUID: completionUUID) { completion()}
    }
}
