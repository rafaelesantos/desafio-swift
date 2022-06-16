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
    var eventView: EventView = {
        let view = EventView()
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
        contentView.addSubview(eventView)
        NSLayoutConstraint.activate(eventView.constraintsForAnchoringTo(boundsOf: contentView))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupCell(with event: EventModel, loader: UIImageLoader) {
        eventView.eventTitle.text = event.title
        eventView.eventDescription.text = event.description?.replacingOccurrences(of: "\n", with: " ")
        eventView.eventDate.text = event.date?.toDate()
        if let price = event.price { eventView.eventPrice.text = price.formatted(.currency(code: "BRL")) }
    }
}
