//
//  RemoteGetEventDetail.swift
//  Data
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation
import RxSwift
import Domain

public class RemoteGetEventDetail: GetEventDetail {
    private let url: URL
    private let httpClient: HttpGetClient

    public init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func get(with eventID: String) -> Observable<EventModel> {
        return httpClient.get(to: url.appendingPathComponent(eventID), completionTask: nil)
            .catch { return .error($0) }
            .flatMap { data -> Observable<EventModel> in
                guard let model: EventModel = data.toModel() else { return .error(DomainError.unexpected) }
                return .just(model)
            }
    }
}
