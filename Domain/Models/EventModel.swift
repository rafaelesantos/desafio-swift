//
//  EventModel.swift
//  Domain
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation

public struct EventModel: Model {
    public var description: String?
    public var date: Int?
    public var id: String
    public var image: String?
    public var latitude: Double?
    public var longitude: Double?
    public var people: [String]?
    public var price: Double?
    public var title: String?
    
    
    public init(description: String? = nil, date: Int? = nil, id: String, image: String? = nil, latitude: Double? = nil, longitude: Double? = nil, people: [String]? = nil, price: Double? = nil, title: String? = nil) {
        self.description = description
        self.date = date
        self.id = id
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.people = people
        self.price = price
        self.title = title
    }
}
