//
//  RemoteFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Data
import Domain

func makeRemoteGetEvents(httpClient: HttpGetClient) -> GetEvents {
    let remoteGetEvents = RemoteGetEvents(url: makeApiUrl(path: "events"), httpClient: httpClient)
    return remoteGetEvents
}

func makeRemoteGetEventDetail(httpClient: HttpGetClient) -> GetEventDetail {
    let remoteGetEventDetail = RemoteGetEventDetail(url: makeApiUrl(path: "events"), httpClient: httpClient)
    return MainQueueDispatchDecorator(remoteGetEventDetail)
}

func makeRemoteImageLoader(httpClient: HttpGetClient) -> ImageLoader {
    let remoteImageLoader = RemoteImageLoader(httpClient: httpClient)
    return remoteImageLoader
}

func makeRemoteAddCheckIn(httpClient: HttpPostClient) -> AddCheckIn {
    let remoteAddCheckIn = RemoteAddCheckIn(url: makeApiUrl(path: "checkin"), httpClient: httpClient)
    return MainQueueDispatchDecorator(remoteAddCheckIn)
}
