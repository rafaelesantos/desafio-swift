//
//  EventTableViewCell.swift
//  UI
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import UIKit
import Presentation

final class EventTableViewCell: UITableViewCell {
    @UsesAutoLayout
    var eventImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
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
        label.numberOfLines = 1
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
    
    @UsesAutoLayout
    var imageTextStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = String(describing: self)) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupUI() {
        textDateStack.addArrangedSubview(eventPrice)
        textDateStack.addArrangedSubview(eventDate)
        textStack.addArrangedSubview(textDateStack)
        textStack.addArrangedSubview(eventTitle)
        textStack.addArrangedSubview(eventDescription)
        imageTextStack.addArrangedSubview(textStack)
        contentView.addSubview(imageTextStack)
        let constraints = imageTextStack.constraintsForAnchoringTo(boundsOf: contentView)
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupCell(with event: EventModel, loader: UIImageLoader) {
        eventTitle.text = event.title
        eventDescription.text = event.description?.replacingOccurrences(of: "\n", with: " ")
        eventDate.text = event.date?.toDate()
        if let price = event.price { eventPrice.text = price.formatted(.currency(code: "BRL")) }
        if let urlString = event.image, let url = URL(string: urlString) {
            eventImage.loadImage(at: url, with: loader) { [weak self] hasImage in
                guard let self = self else { return }
                if hasImage {
                    self.imageTextStack.insertArrangedSubview(self.eventImage, at: 0)
                    let constraints = self.eventImage.constraintAspectRatio(ratio: (1, 1)) + [self.eventImage.heightAnchor.constraint(equalToConstant: 80)]
                    NSLayoutConstraint.activate(constraints)
                }
            }
        }
    }
}
