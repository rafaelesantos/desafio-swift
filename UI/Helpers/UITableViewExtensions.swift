//
//  UITableViewExtensions.swift
//  UI
//
//  Created by Rafael Escaleira on 14/06/22.
//

import Foundation
import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        register(cell.self, forCellReuseIdentifier: cell.identifier)
    }
    
    func cell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as? T
    }
}
