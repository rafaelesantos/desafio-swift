//
//  EventDetailControllerFactory.swift
//  Main
//
//  Created by Rafael Escaleira on 16/06/22.
//

import Foundation
import UI
import Presentation
import Domain

public func makeEventDetailController(eventID: String, getEventDetail: GetEventDetail, imageLoader: ImageLoader) -> EventDetailViewController {
    let controller = EventDetailViewController()
    let viewModel = EventDetailViewModel(alert: WeakProxy(controller), loading: WeakProxy(controller), getEventDetail: getEventDetail, eventDetail: WeakProxy(controller))
    let imageLoaderModel = ImageLoaderModel(loader: imageLoader)
    let imageLoaderViewModel = ImageLoaderViewModel(loading: WeakProxy(controller), imageLoader: imageLoaderModel)
    controller.imageLoader = UIImageLoader(viewModel: imageLoaderViewModel)
    controller.getEventDetail = viewModel.get
    controller.eventID = eventID
    return controller
}
