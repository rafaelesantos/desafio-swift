//
//  EventDetailViewController.swift
//  UI
//
//  Created by Rafael Escaleira on 15/06/22.
//

import UIKit
import RxSwift
import Presentation

public final class EventDetailViewController: UIViewController {
    @UsesAutoLayout
    var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = .accent
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var checkInView: CheckInView = {
        return setupCheckInView()
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
    
    lazy var shareButtonItem: UIBarButtonItem = {
        let buttomItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareEvent))
        return buttomItem
    }()
    
    lazy var checkInButtonItem: UIBarButtonItem = {
        let buttomItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.seal.fill"), style: .done, target: self, action: #selector(checkInAction))
        return buttomItem
    }()
    
    private let eventID: String
    private let viewModel: EventDetailViewModel
    private let checkInViewModel: CheckInViewModel
    private let imageLoader: UIImageLoader
    private let disposeBag = DisposeBag()
    
    private var event: EventModel? {
        didSet { tableView.reloadData() }
    }
    
    private var checkIn: CheckInModel? {
        didSet { activityIndicatorView.stopAnimating() }
    }
    
    public init(eventID: String, viewModel: EventDetailViewModel, checkInViewModel: CheckInViewModel, imageLoader: UIImageLoader) {
        self.eventID = eventID
        self.viewModel = viewModel
        self.checkInViewModel = checkInViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
        setupObservePublish()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        title = "Detalhes do Evento"
        view.backgroundColor = .systemBackground
        navigationItem.setRightBarButtonItems([checkInButtonItem, shareButtonItem], animated: true)
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
        setupActivityIndicatorView()
        loadData()
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
        viewModel.eventDetailPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            self?.event = model
        }).disposed(by: disposeBag)
        
        checkInViewModel.loadingPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            if model.isLoading { self?.activityIndicatorView.startAnimating() }
            else { self?.activityIndicatorView.stopAnimating() }
        }).disposed(by: disposeBag)
        checkInViewModel.alertPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            let alerController = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
            alerController.addAction(.init(title: "Ok", style: .default))
            self?.present(alerController, animated: true)
        }).disposed(by: disposeBag)
        checkInViewModel.checkInPublishSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] model in
            self?.checkIn = model
            self?.checkInView.dismiss()
        }).disposed(by: disposeBag)
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        let constraints = [
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCheckInView() -> CheckInView {
        let view = CheckInView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func loadData() {
        viewModel.get(with: eventID)
    }
}

extension EventDetailViewController {
    @objc private func shareEvent() {
        guard event != nil else { return }
        let content = "\(event?.title ?? "")\n\n\(event?.date?.toDate() ?? "")\t\(event?.price?.formatted(.currency(code: "BRL")) ?? "")\n\n\(event?.description ?? "")\n"
        let viewController = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        present(viewController, animated: true, completion: nil)
    }
    
    @objc private func checkInAction() {
        if let event = event {
            checkInButtonItem.isEnabled = false
            shareButtonItem.isEnabled = false
            checkInView = setupCheckInView()
            checkInView.onDismiss = { [weak self] in
                self?.checkInButtonItem.isEnabled = true
                self?.shareButtonItem.isEnabled = true
            }
            checkInView.onCheckIn = { [weak self] in
                if let name = self?.checkInView.nameTextField.text, let email = self?.checkInView.emailTextField.text {
                    self?.checkInViewModel.addCheckIn(with: .init(name: name, email: email, eventId: event.id))
                }
            }
            checkInView.descriptionLabel.text = "Para efetuar o check in em - \(event.title ?? "") - informe seu nome e e-mail abaixo."
            view.addSubview(checkInView)
            NSLayoutConstraint.activate([
                checkInView.topAnchor.constraint(equalTo: navigationController?.navigationBar != nil ? navigationController!.navigationBar.bottomAnchor : view.safeAreaLayoutGuide.topAnchor),
                checkInView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                checkInView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                checkInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        checkInView.constraintY?.constant = -keyboardSize.height - 15
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.checkInView.layoutIfNeeded()
        }
    }
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event == nil ? 0 : 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cell(EventDetailTableViewCell.self, for: indexPath), let event = event else { return .init() }
        cell.setupCell(with: event, loader: imageLoader) {
            tableView.beginUpdates()
            tableView.setNeedsDisplay()
            tableView.endUpdates()
        }
        cell.selectionStyle = .none
        return cell
    }
}
