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

func makeValidData() -> Data {
    return Data("[{\"people\":[],\"date\":0,\"description\":\"any-description\",\"image\":\"https://any-image.com/image.png\",\"longitude\":0,\"latitude\":0,\"price\":0,\"title\":\"any-title\",\"id\":\"1\"}]".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}
