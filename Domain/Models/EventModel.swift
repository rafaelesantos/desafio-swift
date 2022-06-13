//
//  EventModel.swift
//  Domain
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

public struct EventModel {
    public var date: Int?
    public var id: String
    public var image: String?
    public var latitude: Double?
    public var longitude: Double?
    public var people: [Any]?
    public var price: Double?
    public var title: String?
    public var welcomeDescription: String
}
