//
//  HttpGetClient.swift
//  Data
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation
import RxSwift

public protocol HttpGetClient {
    @discardableResult
    func get(to url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void) -> URLSessionDataTask
    func get(to url: URL) -> Observable<Data>
}
