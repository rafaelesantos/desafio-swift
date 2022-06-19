//
//  EventsViewModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 13/06/22.
//

import Foundation
import RxSwift
import Domain

public typealias EventModel = Domain.EventModel

public class EventsViewModel {
    private let getEvents: GetEvents
    public let alertPublishSubject = PublishSubject<AlertModel>()
    public let loadingPublishSubject = PublishSubject<LoadingModel>()
    public let eventsPublishSubject = PublishSubject<[EventModel]>()
    private let disposeBag = DisposeBag()
    
    public init(getEvents: GetEvents) {
        self.getEvents = getEvents
    }

    public func getAll() {
        loadingPublishSubject.onNext(.init(isLoading: true))
        getEvents.get().subscribe(onNext: { [weak self] events in
            self?.eventsPublishSubject.onNext(events)
        }, onError: { [weak self] _ in
            self?.alertPublishSubject.onNext(.init(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
        }, onCompleted: { [weak self] in
            self?.loadingPublishSubject.onNext(.init(isLoading: false))
        }).disposed(by: disposeBag)
    }
}
