//
//  HttpPostClient.swift
//  Data
//
//  Created by Rafael Escaleira on 17/06/22.
//

import Foundation
import RxSwift

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?) -> Observable<Data>
}
