//
//  EventsControllerFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UI
import Presentation
import Domain

public func makeEventsController(getEvents: GetEvents, imageLoader: ImageLoader) -> EventsViewController {
    let viewModel = EventsViewModel(getEvents: getEvents)
    let imageLoaderModel = ImageLoaderModel(loader: imageLoader)
    let imageLoaderViewModel = ImageLoaderViewModel(imageLoader: imageLoaderModel)
    let uiImageLoader = UIImageLoader(viewModel: imageLoaderViewModel)
    let controller = EventsViewController(viewModel: viewModel, imageLoader: uiImageLoader) { eventID in
        let httpClient = makeNetworkAdapter()
        let getEventDetail = makeRemoteGetEventDetail(httpClient: httpClient)
        let addCheckIn = makeRemoteAddCheckIn(httpClient: httpClient)
        return makeEventDetailController(eventID: eventID, imageLoader: imageLoader, getEventDetail: getEventDetail, addCheckIn: addCheckIn)
    }
    return controller
}
