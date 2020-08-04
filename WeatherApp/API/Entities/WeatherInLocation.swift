//
//  Weather.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct WeatherInLocation: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeather?
    let daily: [DailyWeather]?

    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case timezone
        case current
        case daily
    }
}

struct CurrentWeather: Decodable {
    let dayTime: Date
    let temperature: Double
    let weatherDetails: [WeatherDetails]

    private enum CodingKeys: String, CodingKey {
        case dayTime = "dt"
        case temperature = "temp"
        case weatherDetails = "weather"
    }
}

struct DailyWeather: Decodable {
    let dayTime: TimeInterval
    let temperature: DetailedTemperature
    let weatherDetails: [WeatherDetails]
    let humidity: Int
    let sunrise: Date
    let sunset: Date
    let windDegree: Int
    let windSpeed: Double
    let clouds: Int
    let pressure: Int
    let dewPoint: Double
    let rain: Double?

    private enum CodingKeys: String, CodingKey {
        case dayTime = "dt"
        case temperature = "temp"
        case weatherDetails = "weather"
        case humidity
        case sunrise
        case sunset
        case windDegree = "wind_deg"
        case windSpeed = "wind_speed"
        case clouds
        case pressure
        case dewPoint = "dew_point"
        case rain
    }
}

struct DetailedTemperature: Decodable {
    let night: Double
    let day: Double
    let min: Double
    let max: Double
}

struct WeatherDetails: Decodable {
    let id: Int
    let shortTitle: String
    let fullTitle: String
    let icon: String

    private enum CodingKeys: String, CodingKey {
        case id
        case shortTitle = "main"
        case fullTitle = "description"
        case icon
    }
}
