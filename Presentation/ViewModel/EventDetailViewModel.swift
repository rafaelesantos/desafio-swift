//
//  EventDetailViewModel.swift
//  Presentation
//
//  Created by Rafael Escaleira on 15/06/22.
//

import Foundation
import RxSwift
import Domain

public typealias CheckInModel = Domain.CheckInModel

public class EventDetailViewModel {
    private let getEventDetail: GetEventDetail
    public let alertPublishSubject = PublishSubject<AlertModel>()
    public let loadingPublishSubject = PublishSubject<LoadingModel>()
    public let eventDetailPublishSubject = PublishSubject<EventModel>()
    private let disposeBag = DisposeBag()
    
    public init(getEventDetail: GetEventDetail) {
        self.getEventDetail = getEventDetail
    }

    public func get(with eventID: String) {
        loadingPublishSubject.onNext(.init(isLoading: true))
        getEventDetail.get(with: eventID).subscribe(onNext: { [weak self] eventDetail in
            self?.eventDetailPublishSubject.onNext(eventDetail)
        }, onError: { [weak self] _ in
            self?.alertPublishSubject.onNext(.init(title: "Erro", message: "Algo inesperado aconteceu, tente novamente em alguns instantes."))
        }, onCompleted: { [weak self] in
            self?.loadingPublishSubject.onNext(.init(isLoading: false))
        }).disposed(by: disposeBag)
    }
}
