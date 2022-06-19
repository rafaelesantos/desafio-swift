//
//  EventsViewController.swift
//  UI
//
//  Created by Rafael Escaleira on 13/06/22.
//

import UIKit
import RxSwift
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
    
    private var viewModel: EventsViewModel
    private var imageLoader: UIImageLoader
    private var getEventDetailViewController: (_ eventID: String) -> EventDetailViewController
    private let disposeBag = DisposeBag()
    
    public init(viewModel: EventsViewModel, imageLoader: UIImageLoader, getEventDetailViewController: @escaping (_ eventID: String) -> EventDetailViewController) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.getEventDetailViewController = getEventDetailViewController
        super.init(nibName: nil, bundle: nil)
        setupObservePublish()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var events = [EventModel]() {
        didSet { tableView.reloadData() }
    }
    
    private func setupUI() {
        title = "Eventos"
        self.view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupObservePublish() {
        viewModel.loadingPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            if model.isLoading { self?.activityIndicatorView.startAnimating() }
            else { self?.activityIndicatorView.stopAnimating() }
        }).disposed(by: disposeBag)
        viewModel.alertPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            let alerController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
            alerController.addAction(.init(title: "Ok", style: .default))
            self?.present(alerController, animated: true)
        }).disposed(by: disposeBag)
        viewModel.eventsPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            self?.events = model
        }).disposed(by: disposeBag)
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
        viewModel.getAll()
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cell(EventTableViewCell.self, for: indexPath) else { return .init() }
        let event = events[indexPath.row]
        cell.setupCell(with: event, loader: imageLoader)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let eventDetailViewController = getEventDetailViewController(event.id)
        self.navigationController?.pushViewController(eventDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
