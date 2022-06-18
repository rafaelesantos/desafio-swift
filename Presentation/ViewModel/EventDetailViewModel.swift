//
//  EventDetailViewModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation
import Domain

public class EventDetailViewModel {
    private let alert: AlertProtocol
    private let loading: LoadingProtocol
    private let getEventDetail: GetEventDetail
    private let eventDetail: EventDetailProtocol
    private let addCheckIn: AddCheckIn
    private let checkIn: CheckInProtocol
    
    public init(
        alert: AlertProtocol,
        loading: LoadingProtocol,
        getEventDetail: GetEventDetail,
        eventDetail: EventDetailProtocol,
        addCheckIn: AddCheckIn,
        checkIn: CheckInProtocol
    ) {
        self.alert = alert
        self.loading = loading
        self.getEventDetail = getEventDetail
        self.eventDetail = eventDetail
        self.addCheckIn = addCheckIn
        self.checkIn = checkIn
    }

    public func get(with eventID: String) {
        loading.display(with: .init(isLoading: true))
        getEventDetail.getEventDetail(eventID: eventID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure: self.alert.show(with: AlertModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            case .success(let eventDetail): self.eventDetail.recieved(eventDetail: eventDetail)
            }
            self.loading.display(with: .init(isLoading: false))
        }
    }
    
    public func addCheckIn(with model: AddCheckInModel) {
        loading.display(with: .init(isLoading: true))
        if model.email.isEmpty == false, model.email.isValidEmail() {
            if model.name.isEmpty == false {
                addCheckIn.add(addCheckInModel: model) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .failure: self.alert.show(with: AlertModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
                    case .success(let model): self.checkIn.recieved(checkIn: model)
                    }
                    self.loading.display(with: .init(isLoading: false))
                }
            } else {
                alert.show(with: .init(title: "Nome", message: "Nenhum nome foi informado"))
                self.loading.display(with: .init(isLoading: false))
            }
        } else {
            alert.show(with: .init(title: "E-mail", message: "E-mail inválido, informe um e-mail válido"))
            self.loading.display(with: .init(isLoading: false))
        }
    }
}
