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
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()
    
    @UsesAutoLayout
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventTableViewCell.self)
        return tableView
    }()
    
    public var getAllEvents: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
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
        tableView.dataSource = self
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

extension EventsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cell(EventTableViewCell.self, for: indexPath) else { return .init() }
        return cell
    }
}
