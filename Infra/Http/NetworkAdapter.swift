//
//  NetworkAdapter.swift
//  Infra
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import RxSwift
import Data

public class NetworkAdapter: HttpGetClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    @discardableResult
    public func get(to url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return completion(.failure(.noConnectivity)) }
            if error != nil { return completion(.failure(.noConnectivity)) }
            if let data = data { self.handler(statusCode: statusCode, with: data, completion: completion) }
        }
        task.resume()
        return task
    }
    
    public func get(to url: URL) -> Observable<Data> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return session.data(request: request)
    }
}

extension NetworkAdapter: HttpPostClient {
    public func post(to url: URL, with data: Data?) -> Observable<Data> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        return session.data(request: request)
    }
}

extension NetworkAdapter {
    private func handler(statusCode: Int, with data: Data, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        switch statusCode {
        case 204: completion(.success(nil))
        case 200...299: completion(.success(data))
        case 401: completion(.failure(.unauthorized))
        case 403: completion(.failure(.forbidden))
        case 400...499: completion(.failure(.badRequest))
        case 500...599: completion(.failure(.serverError))
        default: completion(.failure(.noConnectivity))
        }
    }
}
