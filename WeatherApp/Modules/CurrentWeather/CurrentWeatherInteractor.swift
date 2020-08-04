//
//  CurrentWeatherInteractor.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action
import APIKit

final class CurrentWeatherInteractor {

    //Inputs
    let loadActionTrigger = PublishSubject<WeatherApi.WeatherInLocationRequest>()

    //Outputs
    private let loadAction: Action<WeatherApi.WeatherInLocationRequest, WeatherInLocation>
    let loadResponse: Observable<WeatherInLocation>
    let isLoading: Observable<Bool>
    let loadActionError: Observable<NSError>

    private let disposeBag = DisposeBag()

    init() {
        self.loadAction = Action { request in
            return Session.shared.rx.send(request)
        }

        let _loadResponse = PublishRelay<WeatherInLocation>()
        self.loadResponse = _loadResponse.asObservable()

        self.isLoading = loadAction.executing.startWith(false)
        self.loadActionError = loadAction.errors.map { _ in NSError(domain: "Network Error", code: 0, userInfo: nil) }

        loadAction.elements.asObservable()
            .bind(to: _loadResponse)
            .disposed(by: disposeBag)

        loadActionTrigger.asObservable()
            .bind(to: loadAction.inputs)
            .disposed(by: disposeBag)
    }
}
