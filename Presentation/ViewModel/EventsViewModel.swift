//
//  EventsViewModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import Domain

public class EventsViewModel {
    private let alert: AlertProtocol
    private let getEvents: GetEvents
    
    public init(alert: AlertProtocol, getEvents: GetEvents) {
        self.alert = alert
        self.getEvents = getEvents
    }

    public func getAllEvents() {
        getEvents.getEvents { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure: self.alert.show(with: AlertModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
            case .success: break
            }
        }
    }
}
