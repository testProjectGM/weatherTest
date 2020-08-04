//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import APIKit

protocol WeatherRequest: Request {}

extension WeatherRequest {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data")!
    }
}

extension WeatherRequest {
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        switch urlResponse.statusCode {
        case 200..<300:
            return object
        default:
            throw NSError(domain: "Bad Status Response", code: urlResponse.statusCode, userInfo: nil)
        }
    }
}

struct DecodableDataParser: DataParser {
    let contentType: String? = "application/json"

    func parse(data: Data) throws -> Any {
        return data
    }
}

extension WeatherRequest where Response: Decodable {
    var dataParser: DataParser {
        return DecodableDataParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
