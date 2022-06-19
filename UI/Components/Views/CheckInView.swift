//
//  CheckInView.swift
//  UI
//
//  Created by Rafael Escaleira on 18/06/22.
//

import UIKit

final class CheckInView: UIView {
    var constraintY: NSLayoutConstraint?
    var onDismiss: (() -> Void)?
    
    @UsesAutoLayout
    var visualEffectView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        return view
    }()
    
    @UsesAutoLayout
    var contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 6
        view.addParallax()
        return view
    }()
    
    @UsesAutoLayout
    var contentStackView: UIStackView = {
        let stackView = UIStackView.setup(with: .vertical, distribution: .fill, alignment: .leading, spacing: 15)
        return stackView
    }()
    
    @UsesAutoLayout
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Check In"
        label.font = .preferredFont(forTextStyle: .title1).bold()
        return label
    }()
    
    @UsesAutoLayout
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    @UsesAutoLayout
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .words
        textField.placeholder = "Informe seu nome"
        return textField
    }()
    
    @UsesAutoLayout
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Informe seu e-mail"
        return textField
    }()
    
    @UsesAutoLayout
    var textFieldStackView: UIStackView = {
        let stackView = UIStackView.setup(with: .vertical, distribution: .fill, alignment: .center, spacing: 10)
        return stackView
    }()
    
    @UsesAutoLayout
    var textFieldView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var buttonStackView: UIStackView = {
        let stackView = UIStackView.setup(with: .horizontal, distribution: .fillEqually, alignment: .center, spacing: 15)
        return stackView
    }()
    
    lazy var addCheckInButton: UIButton = {
        let primaryAction = UIAction { _ in  }
        let button = UIButton(primaryAction: primaryAction)
        button.setTitle("CheckIn".uppercased(), for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote).bold()
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = .accent
        button.layer.cornerRadius = 6
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let primaryAction = UIAction { [weak self] _ in self?.dismiss() }
        let button = UIButton(primaryAction: primaryAction)
        button.setTitle("Cancelar".uppercased(), for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote).bold()
        button.clipsToBounds = true
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 6
        return button
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
        textFieldStackView.addArrangedSubview(nameTextField)
        let separatedView = UIView()
        separatedView.backgroundColor = .secondarySystemBackground
        separatedView.clipsToBounds = true
        separatedView.layer.cornerRadius = 1
        textFieldStackView.addArrangedSubview(separatedView)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldView.addSubview(textFieldStackView)
        buttonStackView.addArrangedSubview(addCheckInButton)
        buttonStackView.addArrangedSubview(dismissButton)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(textFieldView)
        contentStackView.addArrangedSubview(buttonStackView)
        contentView.addSubview(contentStackView)
        visualEffectView.addSubview(contentView)
        addSubview(visualEffectView)
        
        constraintY = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: visualEffectView, attribute: .bottom, multiplier: 1, constant: 0)
        constraintY?.isActive = true
        
        NSLayoutConstraint.activate(visualEffectView.constraintsForAnchoringTo(boundsOf: self, constant: 0))
        NSLayoutConstraint.activate(textFieldStackView.constraintsForAnchoringTo(boundsOf: textFieldView, constant: 0))
        NSLayoutConstraint.activate(contentStackView.constraintsForAnchoringTo(boundsOf: contentView, constant: 20))
        NSLayoutConstraint.activate([
            addCheckInButton.heightAnchor.constraint(equalTo: dismissButton.heightAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            separatedView.heightAnchor.constraint(equalToConstant: 2)
        ])
        NSLayoutConstraint.activate([
            textFieldView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            textFieldView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor, constant: 15),
            nameTextField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor, constant: -15),
            nameTextField.topAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor, constant: 15),
            emailTextField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor, constant: -15),
            separatedView.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            separatedView.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            textFieldStackView.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -5),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        visualEffectView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentView.addGestureRecognizer(tap2)
    }
    
    @objc private func hideKeyboard() {
        constraintY?.constant = 0
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.layoutIfNeeded()
        }
        contentView.endEditing(true)
    }
    
    @objc private func dismiss() {
        contentView.endEditing(true)
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let self = self else { return }
            self.contentView.frame = CGRect(origin: .init(x: self.contentView.frame.minX, y: self.frame.height), size: self.contentView.frame.size)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            for subview in self.textFieldStackView.arrangedSubviews { subview.removeFromSuperview() }
            self.textFieldStackView.removeFromSuperview()
            self.textFieldView.removeFromSuperview()
            for subview in self.buttonStackView.arrangedSubviews { subview.removeFromSuperview() }
            self.buttonStackView.removeFromSuperview()
            self.contentStackView.removeFromSuperview()
            self.contentView.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
            self.removeFromSuperview()
            self.onDismiss?()
        }
    }
}
