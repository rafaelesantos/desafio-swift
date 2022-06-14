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
