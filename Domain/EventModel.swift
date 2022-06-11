//
//  EventModel.swift
//  Domain
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

struct EventModel {
    var date: Int?
    var id: String
    var image: String?
    var latitude: Double?
    var longitude: Double?
    var people: [Any]?
    var price: Double?
    var title: String?
    var welcomeDescription: String
}
