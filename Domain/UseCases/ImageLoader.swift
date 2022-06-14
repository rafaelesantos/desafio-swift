//
//  ImageLoader.swift
//  Domain
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation

public protocol ImageLoader {
    func loadImage(with url: URL, completion: @escaping (Result<Data, DomainError>) -> Void) -> UUID?
}
