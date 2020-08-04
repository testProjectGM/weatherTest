//
//  ForecastPresenter.swift
//  WeatherApp
//
//  Created by Step on 03.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import WebKit
import RxCocoa
import RxSwift


protocol ForecastPresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
}

protocol ForecastPresenterOutputs {
    var viewConfigure: Observable<ForecastEntryEntity> { get }
    var forecastData: BehaviorRelay<[WeatherInLocation]> { get }
}

protocol ForecastPresenterInterface {
    var inputs: ForecastPresenterInputs { get }
    var outputs: ForecastPresenterOutputs { get }
}

typealias ForecastPresenterDependencies = (
    interactor: ForecastInteractor,
    router: ForecastRouterOutput
)

final class ForecastPresenter: ForecastPresenterInterface, ForecastPresenterInputs, ForecastPresenterOutputs {

    var inputs: ForecastPresenterInputs { return self }
    var outputs: ForecastPresenterOutputs { return self }

    // Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()

    // Outputs
    let forecastData = BehaviorRelay<[WeatherInLocation]>(value: [])
    let viewConfigure: Observable<ForecastEntryEntity>

    private let entryEntity: ForecastEntryEntity
    private let dependencies: ForecastPresenterDependencies
    private let disposeBag = DisposeBag()

    init(entryEntity: ForecastEntryEntity,
         dependencies: ForecastPresenterDependencies)
    {
        self.entryEntity = entryEntity
        self.dependencies = dependencies

        let _viewConfigure = PublishRelay<ForecastEntryEntity>()
        self.viewConfigure = _viewConfigure.asObservable().take(1)

        viewDidLoadTrigger.asObservable()
            .withLatestFrom(Observable.just(entryEntity))
            .bind(to: _viewConfigure)
            .disposed(by: disposeBag)

        forecastData.accept([entryEntity.weatherInLocation])
    }
}

