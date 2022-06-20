//
//  CheckInViewModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 19/06/22.
//

import Foundation
import RxSwift
import Domain

public typealias AddCheckInModel = Domain.AddCheckInModel
public typealias CheckInModel = Domain.CheckInModel

public class CheckInViewModel {
    private let addCheckIn: AddCheckIn
    public let alertPublishSubject = PublishSubject<AlertModel>()
    public let loadingPublishSubject = PublishSubject<LoadingModel>()
    public let checkInPublishSubject = PublishSubject<CheckInModel>()
    private let disposeBag = DisposeBag()
    
    public init(addCheckIn: AddCheckIn) {
        self.addCheckIn = addCheckIn
    }
    
    public func addCheckIn(with model: AddCheckInModel) {
        loadingPublishSubject.onNext(.init(isLoading: true))
        if model.name.isEmpty == false {
            if model.email.isEmpty == false, model.email.isValidEmail() {
                addCheckIn.add(with: model).subscribe(onNext: { [weak self] checkIn in
                    self?.checkInPublishSubject.onNext(checkIn)
                    self?.loadingPublishSubject.onNext(.init(isLoading: false))
                }, onError: { [weak self] _ in
                    self?.alertPublishSubject.onNext(.init(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
                    self?.loadingPublishSubject.onNext(.init(isLoading: false))
                }, onCompleted: { [weak self] in
                    self?.loadingPublishSubject.onNext(.init(isLoading: false))
                }).disposed(by: disposeBag)
            } else {
                alertPublishSubject.onNext(.init(title: "Campo Inválido", message: "E-mail inválido, informe um e-mail válido"))
                loadingPublishSubject.onNext(.init(isLoading: false))
            }
        } else {
            alertPublishSubject.onNext(.init(title: "Campo Inválido", message: "Nenhum nome foi informado"))
            loadingPublishSubject.onNext(.init(isLoading: false))
        }
    }
}
