//
//  ViewController.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import RxCoreLocation

class ViewController: UIViewController {

    var locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        locationManager.rx
        .placemark
        .subscribe(onNext: { [weak self] placemark in
            self?.startMainFlow(with: placemark)
        })
        .disposed(by: disposeBag)
    }

    //TODO: extend with another cities
    func startMainFlow(with placemark: CLPlacemark) {
        guard let name = placemark.locality, let location = placemark.location?.coordinate else { return }
        CurrentWeatherRouterInput().present(from: self,
                                            entryEntity: CurrentWeatherEntryEntity(location: CLLocationCoordinate2D(latitude: location.latitude,
                                                                                                                    longitude: location.longitude),
                                                                                   city: name))
    }
}

extension ViewController: Viewable {}
