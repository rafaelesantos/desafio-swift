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
    public var imageLoader: ImageLoader
    public let dataPublishSubject = PublishSubject<Data>()
    public let deferPublishSubject = PublishSubject<Void>()
    public let tokenPublishSubject = PublishSubject<UUID>()
    public let loadingPublishSubject = PublishSubject<LoadingModel>()
    public let uuidPublishSubject = PublishSubject<UUID?>()
    public let cancelPublishSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    public init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
    }
    
    public func load(to url: URL) {
        loadingPublishSubject.onNext(.init(isLoading: true))
        imageLoader.tokenPublishSubject.subscribe(onNext: { [weak self] token in
            self?.tokenPublishSubject.onNext(token)
        }).disposed(by: disposeBag)
        imageLoader.load(to: url).subscribe(onNext: { [weak self] data in
            self?.dataPublishSubject.onNext(data)
            self?.dataPublishSubject.onCompleted()
        }, onCompleted: { [weak self] in
            defer { self?.deferPublishSubject.onNext(()) }
            self?.loadingPublishSubject.onNext(.init(isLoading: false))
        }).disposed(by: disposeBag)
    }
    
    public func cancel() {
        uuidPublishSubject.subscribe(onNext: { [weak self] uuid in
            if let uuid = uuid {
                self?.imageLoader.cancelLoad(uuid)
                self?.cancelPublishSubject.onNext(())
            }
        }).disposed(by: disposeBag)
    }
}
