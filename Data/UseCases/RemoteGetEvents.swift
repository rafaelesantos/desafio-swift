//
//  RemoteGetEvents.swift
//  Data
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation
import RxSwift
import Domain

public class RemoteGetEvents: GetEvents {
    private let url: URL
    private let httpClient: HttpGetClient

    public init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func get() -> Observable<[EventModel]> {
        return httpClient.get(to: url)
            .catch { error in
                return .error(error)
            }
            .flatMap { data -> Observable<[EventModel]> in
                guard let model: [EventModel] = data.toModel() else { return .error(DomainError.unexpected) }
                return .just(model)
            }
    }
}
