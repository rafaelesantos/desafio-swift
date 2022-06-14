//
//  ApiUrlFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation

func makeApiUrl(path: String) -> URL {
    return URL(string: "\(Environment.variable(.apiBaseUrl))/\(path)")!
}
