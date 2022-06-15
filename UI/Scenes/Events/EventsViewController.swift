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
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventTableViewCell.self)
        return tableView
    }()
    
    public var getAllEvents: (() -> Void)?
    public var imageLoader: UIImageLoader?
    
    private var events = [EventModel]() {
        didSet { tableView.reloadData() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Eventos"
        self.view.backgroundColor = .secondarySystemBackground
        setupActivityIndicatorView()
        setupTableView()
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
    
    private func setupTableView() {
        view.addSubview(tableView)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func loadData() {
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
}
