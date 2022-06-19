//
//  GetEvents.swift
//  Domain
//
//  Created by Rafael Escaleira on 11/06/22.
//

import Foundation
import RxSwift

public protocol GetEvents {
    func get() -> Observable<[EventModel]>
}
