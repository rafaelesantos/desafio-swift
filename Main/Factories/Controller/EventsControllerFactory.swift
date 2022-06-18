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
    let controller = EventsViewController()
    let viewModel = EventsViewModel(alert: WeakProxy(controller), loading: WeakProxy(controller), getEvents: getEvents, events: WeakProxy(controller))
    let imageLoaderModel = ImageLoaderModel(loader: imageLoader)
    let imageLoaderViewModel = ImageLoaderViewModel(loading: WeakProxy(controller), imageLoader: imageLoaderModel)
    controller.imageLoader = UIImageLoader(viewModel: imageLoaderViewModel)
    controller.getAllEvents = viewModel.getAllEvents
    controller.getEventDetailViewController = { eventID in
        let httpClient = makeNetworkAdapter()
        let getEventDetail = makeRemoteGetEventDetail(httpClient: httpClient)
        let addCheckIn = makeRemoteAddCheckIn(httpClient: httpClient)
        return makeEventDetailController(eventID: eventID, imageLoader: imageLoader, getEventDetail: getEventDetail, addCheckIn: addCheckIn)
    }
    return controller
}
