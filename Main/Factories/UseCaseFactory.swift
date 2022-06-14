//
//  UseCaseFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Data
import Infra
import Domain

final class UseCaseFactory {
    private static let httpClient = NetworkAdapter()
    private static let apiBaseUrl = "http://5f5a8f24d44d640016169133.mockapi.io/api/"
    
    private static func makeUrl(path: String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(path)")!
    }
    
    static func makeRemoteGetEvents() -> GetEvents {
        return RemoteGetEvents(url: makeUrl(path: "events"), httpClient: httpClient)
    }
}
