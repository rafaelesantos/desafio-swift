//
//  EventTableViewCell.swift
//  UI
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import UIKit

final class EventTableViewCell: UITableViewCell {
    @UsesAutoLayout
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = String(describing: self)) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    private func setupUI() {
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate(titleLabel.constraintsForAnchoringTo(boundsOf: contentView))
    }
}
