//
//  EventDetailTableViewCell.swift
//  UI
//
//  Created by Rafael Escaleira on 16/06/22.
//

import Foundation
import UIKit
import Presentation

final class EventDetailTableViewCell: UITableViewCell {
    @UsesAutoLayout
    var eventDetailView: EventDetailView = {
        let view = EventDetailView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = String(describing: self)) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(eventDetailView)
        NSLayoutConstraint.activate(eventDetailView.constraintsForAnchoringTo(boundsOf: contentView))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupCell(with event: EventModel, loader: UIImageLoader, completion: @escaping () -> Void) {
        eventDetailView.eventTitle.text = event.title
        eventDetailView.eventDescription.text = event.description
        eventDetailView.eventDate.text = event.date?.toDate()
        if let price = event.price { eventDetailView.eventPrice.text = price.formatted(.currency(code: "BRL")) }
        if let urlString = event.image, let url = URL(string: urlString) {
            eventDetailView.eventImage.loadImage(at: url, with: loader) { [weak self] hasImage in
                guard let self = self else { return }
                if hasImage {
                    self.eventDetailView.imageTextStack.insertArrangedSubview(self.eventDetailView.eventImage, at: 0)
                    let constraints = self.eventDetailView.eventImage.constraintAspectRatio(ratio: (16, 9)) + [self.eventDetailView.eventImage.widthAnchor.constraint(equalTo: self.eventDetailView.imageTextStack.widthAnchor)]
                    NSLayoutConstraint.activate(constraints)
                    completion()
                }
            }
        }
    }
}
