//
//  EventView.swift
//  UI
//
//  Created by Rafael Escaleira on 15/06/22.
//

import UIKit

final class EventView: UIView {
    var eventPrice: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote).bold()
        label.textColor = .accent
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    var eventDate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote).bold()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    var eventTitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    var eventDescription: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    @UsesAutoLayout
    var textDateStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    @UsesAutoLayout
    var textStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        textDateStack.addArrangedSubview(eventPrice)
        textDateStack.addArrangedSubview(eventDate)
        textStack.addArrangedSubview(textDateStack)
        textStack.addArrangedSubview(eventTitle)
        textStack.addArrangedSubview(eventDescription)
        addSubview(textStack)
        let constraints = textStack.constraintsForAnchoringTo(boundsOf: self, constant: 0)
        NSLayoutConstraint.activate(constraints)
    }
}
