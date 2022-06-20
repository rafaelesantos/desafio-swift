//
//  UIImageLoader.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import RxSwift
import UIKit
import Presentation

public final class UIImageLoader {
    private let viewModel: ImageLoaderViewModel
    private var uuidMap = [UIImageView: UUID]()
    public let completePublishSubject = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    public init(viewModel: ImageLoaderViewModel) {
        self.viewModel = viewModel
    }
    
    func load(_ url: URL, for imageView: UIImageView) {
        var completeWithSuccess = false
        viewModel.dataPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { data in
            imageView.image = UIImage(data: data)
            completeWithSuccess = true
        }, onCompleted: { [weak self] in
            self?.completePublishSubject.onNext(completeWithSuccess)
        }).disposed(by: disposeBag)
        
        viewModel.deferPublishSubject.subscribe(onNext: { [weak self] in
            self?.uuidMap.removeValue(forKey: imageView)
        }).disposed(by: disposeBag)
        
        viewModel.tokenPublishSubject.subscribe(onNext: { [weak self] token in
            self?.uuidMap[imageView] = token
        }).disposed(by: disposeBag)
        
        viewModel.load(to: url)
    }
    
    func cancel(for imageView: UIImageView) {
        viewModel.cancelPublishSubject.subscribe(onNext: { [weak self] in
            self?.uuidMap.removeValue(forKey: imageView)
        }).disposed(by: disposeBag)
        viewModel.cancel()
        viewModel.uuidPublishSubject.onNext(uuidMap[imageView])
    }
}
