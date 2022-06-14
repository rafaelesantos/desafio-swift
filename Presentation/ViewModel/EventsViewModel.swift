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
    private let loading: LoadingProtocol
    private let getEvents: GetEvents
    private let events: EventsProtocol
    
    public init(alert: AlertProtocol, loading: LoadingProtocol, getEvents: GetEvents, events: EventsProtocol) {
        self.alert = alert
        self.loading = loading
        self.getEvents = getEvents
        self.events = events
    }

    public func getAllEvents() {
        loading.display(with: .init(isLoading: true))
        getEvents.getEvents { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure: self.alert.show(with: AlertModel(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
                case .success(let events): self.events.recieved(events: events)
                }
                self.loading.display(with: .init(isLoading: false))
            }
        }
    }
}
