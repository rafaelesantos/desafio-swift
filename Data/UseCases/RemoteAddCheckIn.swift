//
//  RemoteAddCheckIn.swift
//  Data
//
//  Created by Rafael Escaleira on 17/06/22.
//

import Foundation
import RxSwift
import Domain

public final class RemoteAddCheckIn: AddCheckIn {
    private let url: URL
    private let httpClient: HttpPostClient

    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(with model: AddCheckInModel) -> Observable<CheckInModel> {
        return httpClient.post(to: url, with: model.toData())
            .catch { return .error($0) }
            .flatMap { data -> Observable<CheckInModel> in
                guard let model: CheckInModel = data.toModel() else { return .error(DomainError.unexpected) }
                return .just(model)
            }
    }
}
