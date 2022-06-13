//
//  HttpGetClient.swift
//  Data
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

public protocol HttpGetClient {
    func get(url: URL, completion: @escaping (HttpError) -> Void)
}
