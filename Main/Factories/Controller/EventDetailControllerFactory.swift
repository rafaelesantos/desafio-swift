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

public func makeEventDetailController(eventID: String, imageLoader: ImageLoader, getEventDetail: GetEventDetail, addCheckIn: AddCheckIn) -> EventDetailViewController {
    let viewModel = EventDetailViewModel(getEventDetail: getEventDetail)
    let checkInViewModel = CheckInViewModel(addCheckIn: addCheckIn)
    let imageLoaderViewModel = ImageLoaderViewModel(imageLoader: imageLoader)
    let uiImageLoader = UIImageLoader(viewModel: imageLoaderViewModel)
    let controller = EventDetailViewController(eventID: eventID, viewModel: viewModel, checkInViewModel: checkInViewModel, imageLoader: uiImageLoader)
    return controller
}
