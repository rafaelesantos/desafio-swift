//
//  ImageLoader.swift
//  Domain
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import RxSwift

public protocol ImageLoader {
    var loadedImages: [URL: Data] { get set }
    var runningRequests: [UUID: URLSessionDataTask] { get set }
    var tokenPublishSubject: PublishSubject<UUID> { get set }
    func load(to url: URL) -> Observable<Data>
    func cancelLoad(_ uuid: UUID)
}
