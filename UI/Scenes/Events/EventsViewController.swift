//
//  EventsViewController.swift
//  UI
//
//  Created by Rafael Escaleira on 13/06/22.
//

import UIKit
import Presentation

public final class EventsViewController: UIViewController {
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
        tableView.register(EventTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    public var getAllEvents: (() -> Void)?
    public var imageLoader: UIImageLoader?
    public var getEventDetailViewController: ((String) -> EventDetailViewController)?
    
    private var events = [EventModel]() {
        didSet { tableView.reloadData() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Eventos"
        self.view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupActivityIndicatorView()
        loadData()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicatorView.removeFromSuperview()
    }
    
    private func setupActivityIndicatorView() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.addSubview(activityIndicatorView)
        let constraints = [
            activityIndicatorView.trailingAnchor.constraint(equalTo: navigationController.navigationBar.trailingAnchor, constant: -15),
            activityIndicatorView.bottomAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
    }
    
    public func loadData() {
        getAllEvents?()
    }
}

extension EventsViewController: LoadingProtocol {
    public func display(with model: LoadingModel) {
        if model.isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}

extension EventsViewController: AlertProtocol {
    public func show(with model: AlertModel) {
        let alerController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alerController.addAction(.init(title: "Ok", style: .default))
        present(alerController, animated: true)
    }
}

extension EventsViewController: EventsProtocol {
    public func recieved(events: [EventModel]) {
        self.events = events
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cell(EventTableViewCell.self, for: indexPath) else { return .init() }
        let event = events[indexPath.row]
        if let imageLoader = imageLoader {
            cell.setupCell(with: event, loader: imageLoader)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        guard let eventDetailViewController = getEventDetailViewController?(event.id) else { return }
        self.navigationController?.pushViewController(eventDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
