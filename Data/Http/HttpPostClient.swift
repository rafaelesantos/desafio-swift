//
//  HttpPostClient.swift
//  Data
//
//  Created by Rafael Escaleira on 17/06/22.
//

import Foundation

public protocol HttpPostClient {
    @discardableResult
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) -> URLSessionDataTask
}
