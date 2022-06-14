//
//  RemoteGetEventsFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Data
import Domain

func makeRemoteGetEvents(httpClient: HttpGetClient) -> GetEvents {
    let remoteGetEvents = RemoteGetEvents(url: makeApiUrl(path: "events"), httpClient: httpClient)
    return MainQueueDispatchDecorator(remoteGetEvents)
}
