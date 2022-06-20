//
//  WeakProxy.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import Presentation
import Domain

class WeakProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(_ instance: T) {
        self.instance = instance
    }
}
