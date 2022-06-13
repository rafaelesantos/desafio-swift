//
//  RemoteGetEvents.swift
//  Data
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation
import Domain

public class RemoteGetEvents {
    private let url: URL
    private let httpGetClient: HttpGetClient

    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }

    public func getEvents(completion: @escaping (DomainError) -> Void) {
        httpGetClient.get(url: url) { error in
            completion(.unexpected)
        }
    }
}
