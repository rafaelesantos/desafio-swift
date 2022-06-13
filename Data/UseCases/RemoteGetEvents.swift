//
//  RemoteGetEvents.swift
//  Data
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation
import Domain

public class RemoteGetEvents: GetEvents {
    private let url: URL
    private let httpGetClient: HttpGetClient

    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }

    public func getEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
        httpGetClient.get(url: url) { result in
            switch result {
            case .success(let data):
                if let model: [EventModel] = data.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
