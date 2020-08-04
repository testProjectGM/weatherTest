//
//  DoubleExtension.swift
//  WeatherApp
//
//  Created by Step on 03.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
