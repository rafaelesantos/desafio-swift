//
//  GetEventDetail.swift
//  Domain
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation
import RxSwift

public protocol GetEventDetail {
    func get(with eventID: String) -> Observable<EventModel>
}
