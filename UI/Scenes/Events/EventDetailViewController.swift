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
    
    public var getEventDetail: ((String) -> Void)?
    public var addCheckIn: ((AddCheckInModel) -> Void)?
    public var eventID: String?
    public var imageLoader: UIImageLoader?
    
    private var event: EventModel? {
        didSet {
            activityIndicatorView.stopAnimating()
            tableView.reloadData()
        }
    }
    
    private var checkIn: CheckInModel? {
        didSet {
            activityIndicatorView.stopAnimating()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
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
                    self?.addCheckIn?(AddCheckInModel(name: name, email: email, eventId: event.id))
                }
            }
            checkInView.descriptionLabel.text = "Para efetuar o check in em - \(event.title ?? "") - informe seu nome e e-mail abaixo."
            view.addSubview(checkInView)
            NSLayoutConstraint.activate(checkInView.constraintsForAnchoringTo(boundsOf: view, constant: 0))
        }
    }
    
    private func setupCheckInView() -> CheckInView {
        let view = CheckInView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        checkInView.constraintY?.constant = -keyboardSize.height - 15
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.checkInView.layoutIfNeeded()
        }
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

extension EventDetailViewController: CheckInProtocol {
    public func recieved(checkIn: CheckInModel) {
        self.checkIn = checkIn
        checkInView.dismiss()
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
