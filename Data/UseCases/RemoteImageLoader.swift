//
//  RemoteImageLoader.swift
//  Data
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Domain

public class RemoteImageLoader: ImageLoader {
    public var loadedImages: [URL : Data] = [:]
    public var runningRequests: [UUID : URLSessionDataTask] = [:]
    private let httpClient: HttpGetClient

    public init(httpClient: HttpGetClient) {
        self.httpClient = httpClient
    }
    
    public func loadImage(with url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> UUID? {
        if let data = loadedImages[url] {
            completion(.success(data))
            return nil
        }
        let uuid = UUID()
        let task = httpClient.get(to: url) { [weak self] result in
            guard let self = self else { return }
            defer { self.runningRequests.removeValue(forKey: uuid) }
            switch result {
            case .success(let data):
                if let data = data, data.isEmpty == false {
                    self.loadedImages[url] = data
                    completion(.success(data))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure: completion(.failure(.unexpected))
            }
        }
        runningRequests[uuid] = task
        return uuid
    }
    
    public func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
