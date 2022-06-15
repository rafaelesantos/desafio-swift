//
//  ImageLoader.swift
//  Domain
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation

public protocol ImageLoader {
    typealias Result = Swift.Result<Data, DomainError>
    var loadedImages: [URL: Data] { get set }
    var runningRequests: [UUID: URLSessionDataTask] { get set }
    func loadImage(with url: URL, completion: @escaping (Result) -> Void) -> UUID?
    func cancelLoad(_ uuid: UUID)
}
