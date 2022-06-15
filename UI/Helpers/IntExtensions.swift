//
//  IntExtensions.swift
//  UI
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation

extension Int {
    func toDate(with format: String = "dd/MM/yyyy") -> String {
        let date = Date(timeIntervalSince1970: Double(self / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
