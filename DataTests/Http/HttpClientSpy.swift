//
//  HttpClientSpy.swift
//  DataTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Data

class HttpClientSpy: HttpGetClient {
    var urls = [URL]()
    var completion: ((Result<Data?, HttpError>) -> Void)?
    
    @discardableResult
    func get(to url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void) -> URLSessionDataTask {
        self.urls.append(url)
        self.completion = completion
        return URLSession.shared.dataTask(with: url)
    }
    
    func completeWithError(_ error: HttpError) {
        completion?(.failure(error))
    }
    
    func completeWithData(_ data: Data) {
        completion?(.success(data))
    }
}
