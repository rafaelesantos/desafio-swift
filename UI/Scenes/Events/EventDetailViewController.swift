//
//  EventDetailViewController.swift
//  UI
//
//  Created by Rafael Escaleira on 15/06/22.
//

import UIKit
import Presentation

public final class EventDetailViewController: UIViewController {
    @UsesAutoLayout
    var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = .accent
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(EventDetailTableViewCell.self)
        return tableView
    }()
    
    public var getEventDetail: ((String) -> Void)?
    public var eventID: String?
    public var imageLoader: UIImageLoader?
    
    private var event: EventModel? {
        didSet {
            activityIndicatorView.stopAnimating()
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Detalhes do Evento"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
        setupActivityIndicatorView()
        loadData()
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        let constraints = [
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func loadData() {
        guard let eventID = eventID else { return }
        getEventDetail?(eventID)
    }
}

extension EventDetailViewController: LoadingProtocol {
    public func display(with model: LoadingModel) {
        if model.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}

extension EventDetailViewController: AlertProtocol {
    public func show(with model: AlertModel) {
        let alerController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alerController.addAction(.init(title: "Ok", style: .default))
        present(alerController, animated: true)
    }
}

extension EventDetailViewController: EventDetailProtocol {
    public func recieved(eventDetail: EventModel) {
        self.event = eventDetail
    }
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event == nil ? 0 : 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.cell(EventDetailTableViewCell.self, for: indexPath),
            let event = event,
            let imageLoader = imageLoader else { return .init() }
        cell.setupCell(with: event, loader: imageLoader) {
            tableView.beginUpdates()
            tableView.setNeedsDisplay()
            tableView.endUpdates()
        }
        cell.selectionStyle = .none
        return cell
    }
}
