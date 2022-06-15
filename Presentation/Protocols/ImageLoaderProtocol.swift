//
//  ImageLoaderProtocol.swift
//  Presentation
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Domain

public protocol ImageLoaderProtocol {
    var loader: ImageLoader { get set }
    func load(with url: URL, for completion: @escaping (ImageLoader.Result) -> Void, completionDefer: @escaping () -> Void, completionToken: (UUID) -> Void, completionLoading: @escaping (LoadingModel) -> Void)
    func cancel(completionUUID: () -> UUID?, completion: () -> Void)
}

public class ImageLoaderModel: ImageLoaderProtocol {
    public var loader: ImageLoader
    
    public init(loader: ImageLoader) {
        self.loader = loader
    }
    
    public func load(with url: URL, for completion: @escaping (Result<Data, DomainError>) -> Void, completionDefer: @escaping () -> Void, completionToken: (UUID) -> Void, completionLoading: @escaping (LoadingModel) -> Void) {
        let token = loader.loadImage(with: url) { [weak self] result in
            guard let _ = self else { return }
            defer { completionDefer() }
            switch result {
            case .success(let data): completion(.success(data))
            case .failure(let error): completion(.failure(error))
            }
            completionLoading(.init(isLoading: false))
        }
        if let token = token { completionToken(token) }
    }
    
    public func cancel(completionUUID: () -> UUID?, completion: () -> Void) {
        if let uuid = completionUUID() {
            loader.cancelLoad(uuid)
            completion()
        }
    }
}
