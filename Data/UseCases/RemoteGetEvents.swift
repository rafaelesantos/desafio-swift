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
    private let httpClient: HttpGetClient

    public init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }

    public func getEvents(completion: @escaping (Result<[EventModel], DomainError>) -> Void) {
        httpClient.get(to: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                if let model: [EventModel] = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
