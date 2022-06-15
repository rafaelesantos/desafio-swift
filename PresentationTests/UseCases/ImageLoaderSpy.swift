//
//  ImageLoaderSpy.swift
//  PresentationTests
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation
import Domain

class ImageLoaderSpy: ImageLoader {
    var completion: ((ImageLoader.Result) -> Void)?
    var url: URL?
    var loadedImages: [URL : Data] = [:]
    var runningRequests: [UUID : URLSessionDataTask] = [:]
    
    func loadImage(with url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> UUID? {
        self.url = url
        self.completion = completion
        return nil
    }
    
    func cancelLoad(_ uuid: UUID) {}
    
    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }
    
    func completeWithSuccess(_ imageData: Data) {
        completion?(.success(imageData))
    }
}
