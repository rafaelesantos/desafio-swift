//
//  NetworkAdapter.swift
//  Infra
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import RxSwift
import Data

public class NetworkAdapter {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
}

extension NetworkAdapter: HttpGetClient {
    public func get(to url: URL, completionTask: ((URLSessionDataTask) -> Void)? = nil) -> Observable<Data> {
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
