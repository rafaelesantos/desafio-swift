//
//  HttpGetClient.swift
//  Data
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation
import RxSwift

public protocol HttpGetClient {
    func get(to url: URL, completionTask: ((URLSessionDataTask) -> Void)?) -> Observable<Data>
}
