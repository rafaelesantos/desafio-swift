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
    static func makeRemoteGetEvents() -> GetEvents {
        let networkAdapter = NetworkAdapter()
        let url = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!
        return RemoteGetEvents(url: url, httpGetClient: networkAdapter)
    }
}
