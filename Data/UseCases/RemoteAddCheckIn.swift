//
//  RemoteAddCheckIn.swift
//  Data
//
//  Created by Rafael Escaleira on 17/06/22.
//

import Foundation
import Domain

public final class RemoteAddCheckIn: AddCheckIn {
    private let url: URL
    private let httpClient: HttpPostClient

    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addCheckInModel: AddCheckInModel, completion: @escaping (AddCheckIn.Result) -> Void) {
        httpClient.post(to: url, with: addCheckInModel.toData()) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                if let model: CheckInModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure:
                completion(.failure(.unexpected))
            }
        }
    }
}
