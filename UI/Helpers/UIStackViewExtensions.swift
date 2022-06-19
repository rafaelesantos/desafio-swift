//
//  UIStackViewExtensions.swift
//  UI
//
//  Created by Rafael Escaleira on 18/06/22.
//

import UIKit

extension UIStackView {
    static func setup(with axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .center, spacing: CGFloat = 12) -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
}
