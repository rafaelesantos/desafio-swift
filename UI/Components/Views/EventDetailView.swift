//
//  EventDetailView.swift
//  UI
//
//  Created by Rafael Escaleira on 15/06/22.
//

import UIKit
import MapKit

final class EventDetailView: UIView {
    @UsesAutoLayout
    var eventImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.addParallax()
        return imageView
    }()
    
    lazy var eventPriceView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var eventPrice: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle).bold()
        label.textColor = .accent
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = .secondarySystemBackground
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    
    var eventDate: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote).bold()
        label.textColor = .accent
        label.numberOfLines = 1
        return label
    }()
    
    var eventTitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1).bold()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    var eventDescription: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    @UsesAutoLayout
    var textStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    @UsesAutoLayout
    var imageTextStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    @UsesAutoLayout
    var headingMapLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2).bold()
        label.textColor = .label
        label.text = "Localização"
        return label
    }()
    
    @UsesAutoLayout
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 6
        return mapView
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
        textStack.addArrangedSubview(eventTitle)
        textStack.addArrangedSubview(eventDate)
        textStack.addArrangedSubview(eventDescription)
        textStack.addArrangedSubview(eventPrice)
        textStack.addArrangedSubview(headingMapLabel)
        imageTextStack.addArrangedSubview(textStack)
        imageTextStack.addArrangedSubview(mapView)
        addSubview(imageTextStack)
        NSLayoutConstraint.activate([
            eventPrice.heightAnchor.constraint(equalToConstant: 80),
            eventPrice.widthAnchor.constraint(equalTo: textStack.widthAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.widthAnchor.constraint(equalTo: imageTextStack.widthAnchor)
        ])
        NSLayoutConstraint.activate(imageTextStack.constraintsForAnchoringTo(boundsOf: self, constant: 0))
    }
}
