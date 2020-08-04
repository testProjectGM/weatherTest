//
//  CurrentWeatherPresenter.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import CoreLocation

typealias CurrentWeatherPresenterDependencies = (
    interactor: CurrentWeatherInteractor,
    router: CurrentWeatherRouterOutput
)

protocol CurrentWeatherPresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var didSelectItemTrigger: PublishSubject<IndexPath>  { get }
    var reloadTrigger: PublishSubject<Void> { get }
}

protocol CurrentWeatherPresenterOutputs {
    var weatherInLocationList: BehaviorRelay<[WeatherInLocation]> { get }
    var viewConfigure: Observable<CurrentWeatherEntryEntity> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<NSError> { get }
}

protocol CurrentWeatherPresenterInterface {
    var inputs: CurrentWeatherPresenterInputs { get }
    var outputs: CurrentWeatherPresenterOutputs { get }
    var city: String { get }
}

final class CurrentWeatherPresenter: CurrentWeatherPresenterInterface, CurrentWeatherPresenterInputs, CurrentWeatherPresenterOutputs {

    var inputs: CurrentWeatherPresenterInputs { return self }
    var outputs: CurrentWeatherPresenterOutputs { return self }

    // Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let didSelectItemTrigger = PublishSubject<IndexPath>()
    let reloadTrigger = PublishSubject<Void>()

    // Outputs
    let weatherInLocationList = BehaviorRelay<[WeatherInLocation]>(value: [])
    let viewConfigure: Observable<CurrentWeatherEntryEntity>
    let isLoading: Observable<Bool>
    let error: Observable<NSError>

    private let dependencies: CurrentWeatherPresenterDependencies
    private let disposeBag = DisposeBag()

    private(set) var city: String

    init(entryEntity: CurrentWeatherEntryEntity,
        dependencies: CurrentWeatherPresenterDependencies) {

        self.dependencies = dependencies

        self.error = dependencies.interactor.loadActionError
        self.isLoading = dependencies.interactor.isLoading
        city = entryEntity.city

        let _viewConfigure = PublishRelay<CurrentWeatherEntryEntity>()
        self.viewConfigure = _viewConfigure.asObservable().take(1)

        viewDidLoadTrigger.asObservable()
            .withLatestFrom(Observable.just(entryEntity))
            .bind(to: _viewConfigure)
            .disposed(by: disposeBag)

        didSelectItemTrigger.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .bind(onNext: transitionWeather)
            .disposed(by: disposeBag)

        reloadTrigger.asObservable()
            .withLatestFrom(Observable.just(entryEntity))
            .map { WeatherApi.WeatherInLocationRequest(location: $0.location) }
            .withLatestFrom(isLoading) { ($0, $1) }
            .filter { !$0.1 }
            .map { $0.0 }
            .bind(to: dependencies.interactor.loadActionTrigger)
            .disposed(by: disposeBag)

        dependencies.interactor.loadResponse
            .withLatestFrom(weatherInLocationList) { ($1, $0) }
            .map( { $0.0 + [$0.1] } )
            .subscribe(onNext: { [weak self] weatherInLocation in
                self?.weatherInLocationList.accept(weatherInLocation)
            })
            .disposed(by: disposeBag)
    }

    private func transitionWeather(indexPath: IndexPath) {
        guard let weather = weatherInLocationList.value[safe: indexPath.row] else { return }
        dependencies.router.transitionDetail(weather: weather, city: city)
    }
}
