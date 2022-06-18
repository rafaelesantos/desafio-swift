//
//  StringExtensions.swift
//  Presentation
//
//  Created by Rafael Escaleira on 18/06/22.
//

import Foundation

extension String {
    public func isValidEmail() -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
