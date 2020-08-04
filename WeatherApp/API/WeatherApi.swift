//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import APIKit
import CoreLocation

final class WeatherApi {}

// MARK: API struct & Enums
extension WeatherApi {

    struct WeatherInLocationRequest: WeatherRequest {

        // MARK: - Initialize
        let apiKey = "91e775d2847134bfde62d5f733b83723"
        let location: CLLocationCoordinate2D

        init(location: CLLocationCoordinate2D) {
            self.location = location
        }

        // MARK: - Request Type
        typealias Response = WeatherInLocation

        let method: HTTPMethod = .get
        let path: String = "/2.5/onecall"

        var parameters: Any? {
            var params = [String: Any]()
            params["lat"] = location.latitude
            params["lon"] = location.longitude
            params["apiKey"] = apiKey
            params["exclude"] = "hourly"
            params["units"] = "metric"
            return params
        }
    }

}
