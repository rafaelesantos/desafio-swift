//
//  EventModelFactory.swift
//  DataTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Domain

func makeEventsModel() -> [EventModel] {
    return [
        EventModel(
            description: "any-description",
            date: 0,
            id: "any-id",
            image: "any-image",
            latitude: 0,
            longitude: 0,
            people: [],
            price: 0,
            title: "any-title"
        )
    ]
}

func makeAddCheckInModel() -> AddCheckInModel {
    return AddCheckInModel(
        name: "any-name",
        email: "any-email@mail.com",
        eventId: "0"
    )
}

func makeValidChackInModel() -> CheckInModel {
    return CheckInModel(
        name: "any-name",
        email: "any-email@mail.com",
        eventId: "0"
    )
}

func makeEventDetailModel() -> EventModel {
    return EventModel(
        description: "any-description",
        date: 0,
        id: "any-id",
        image: "any-image",
        latitude: 0,
        longitude: 0,
        people: [],
        price: 0,
        title: "any-title"
    )
}

func makeImageModel() -> Data {
    return Data("any-image".utf8)
}
