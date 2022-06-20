//
//  RemoteImageLoader.swift
//  Data
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import RxSwift
import Domain

public class RemoteImageLoader: ImageLoader {
    public var loadedImages: [URL : Data] = [:]
    public var runningRequests: [UUID : URLSessionDataTask] = [:]
    private let httpClient: HttpGetClient
    public var tokenPublishSubject = PublishSubject<UUID>()

    public init(httpClient: HttpGetClient) {
        self.httpClient = httpClient
    }
    
    public func load(to url: URL) -> Observable<Data> {
        if let data = loadedImages[url] {
            return .just(data)
        }
        let uuid = UUID()
        tokenPublishSubject.onNext(uuid)
        return httpClient.get(to: url, completionTask: { [weak self] task in
            self?.runningRequests[uuid] = task
        }).catch { _ in return .error(DomainError.unexpected) }.flatMap { data -> Observable<Data> in
            guard data.isEmpty == false else { return .error(DomainError.unexpected) }
            return .just(data)
        }
    }
    
    public func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
