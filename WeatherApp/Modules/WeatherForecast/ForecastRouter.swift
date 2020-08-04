//
//  ForecastRouter.swift
//  WeatherApp
//
//  Created by Step on 03.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import UIKit

struct ForecastEntryEntity {
    let weatherInLocation: WeatherInLocation
    let city: String
    
    init(weatherInLocation: WeatherInLocation, city: String) {
        self.weatherInLocation = weatherInLocation
        self.city = city
    }
}

struct ForecastRouterInput {

    private func view(entryEntity: ForecastEntryEntity) -> ForecastViewController {
        let view = ForecastViewController()
        let interactor = ForecastInteractor()
        let dependencies = ForecastPresenterDependencies(interactor: interactor, router: ForecastRouterOutput(view))
        let presenter = ForecastPresenter(entryEntity: entryEntity, dependencies: dependencies)
        view.presenter = presenter
        return view
    }

    func push(from: Viewable, entryEntity: ForecastEntryEntity) {
        let view = self.view(entryEntity: entryEntity)
        from.push(view, animated: true)
    }

    func present(from: Viewable, entryEntity: ForecastEntryEntity) {
        let nav = UINavigationController(rootViewController: view(entryEntity: entryEntity))
        from.present(nav, animated: true)
    }
}

final class ForecastRouterOutput: Routerable {

    private(set) weak var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

}
