//
//  RemoteGetEvents.swift
//  Data
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

public class RemoteGetEvents {
    private let url: URL
    private let httpGetClient: HttpGetClient

    public init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }

    public func getEvents() {
        httpGetClient.get(url: url)
    }
}
