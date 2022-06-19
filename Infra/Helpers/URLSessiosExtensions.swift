//
//  URLSessiosExtensions.swift
//  Infra
//
//  Created by Rafael Escaleira on 19/06/22.
//

import Foundation
import RxSwift
import Data

extension URLSession {
    func data(request: URLRequest) -> Observable<Data> {
        Observable.create { [weak self] observer in
            let task = self?.dataTask(with: request, completionHandler: { data, response, error in
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return observer.onError(HttpError.noConnectivity) }
                if error != nil { return observer.onError(HttpError.noConnectivity) }
                if let data = data { self?.completion(with: observer, statusCode: statusCode, data: data) }
                observer.onCompleted()
            })
            task?.resume()
            return Disposables.create { task?.cancel() }
        }
    }
    
    private func completion(with observer: AnyObserver<Data>, statusCode: Int, data: Data) {
        switch statusCode {
        case 204: observer.onNext(data)
        case 200...299: observer.onNext(data)
        case 401: observer.onError(HttpError.unauthorized)
        case 403: observer.onError(HttpError.forbidden)
        case 400...499: observer.onError(HttpError.badRequest)
        case 500...599: observer.onError(HttpError.serverError)
        default: observer.onError(HttpError.noConnectivity)
        }
    }
}
