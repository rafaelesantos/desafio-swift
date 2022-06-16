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
    
    public init(alert: AlertProtocol, loading: LoadingProtocol, getEventDetail: GetEventDetail, eventDetail: EventDetailProtocol) {
        self.alert = alert
        self.loading = loading
        self.getEventDetail = getEventDetail
        self.eventDetail = eventDetail
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
}
