//
//  TestFactories.swift
//  DataTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid-data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}
