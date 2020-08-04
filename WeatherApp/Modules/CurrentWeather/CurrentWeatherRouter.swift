//
//  CurrentWeatherRouter.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct CurrentWeatherEntryEntity {
    let location: CLLocationCoordinate2D
    let city: String
}

struct CurrentWeatherRouterInput {

    private func view(entryEntity: CurrentWeatherEntryEntity) -> CurrentWeatherViewController {
        let view = CurrentWeatherViewController()
        let interactor = CurrentWeatherInteractor()
        let dependencies = CurrentWeatherPresenterDependencies(interactor: interactor, router: CurrentWeatherRouterOutput(view))
        let presenter = CurrentWeatherPresenter(entryEntity: entryEntity, dependencies: dependencies)
        view.presenter = presenter
        return view
    }

    func push(from: Viewable, entryEntity: CurrentWeatherEntryEntity) {
        let view = self.view(entryEntity: entryEntity)
        from.push(view, animated: true)
    }

    func present(from: Viewable, entryEntity: CurrentWeatherEntryEntity) {
        let nav = UINavigationController(rootViewController: view(entryEntity: entryEntity))
        from.present(nav, animated: true)
    }
}

final class CurrentWeatherRouterOutput: Routerable {

    private(set) weak var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

    func transitionDetail(weather: WeatherInLocation, city: String) {
        ForecastRouterInput().push(from: view, entryEntity: ForecastEntryEntity(weatherInLocation: weather, city: city))
    }
}
