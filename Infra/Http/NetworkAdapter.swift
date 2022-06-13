//
//  NetworkAdapter.swift
//  Infra
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Data

class NetworkAdapter: HttpGetClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(to url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return completion(.failure(.noConnectivity)) }
            if error != nil { completion(.failure(.noConnectivity)) }
            if let data = data {
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
        }.resume()
    }
}
