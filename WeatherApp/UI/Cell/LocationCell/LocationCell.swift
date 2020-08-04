//
//  LocationCell.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import UIKit
import Kingfisher

class LocationCell: UICollectionViewCell {

    @IBOutlet private weak var locationImageView: UIImageView?
    @IBOutlet private weak var cityNameLabel: UILabel?
    @IBOutlet private weak var temperatureLabel: UILabel?

    func configure(with cityName: String, temperature: String, imageName: String) {
        cityNameLabel?.text = cityName
        temperatureLabel?.text = temperature + (temperature.isEmpty ? "" : "°C")

        if let url = URL(string: "\(Constants.Basic.photoUrl)\(imageName)@2x.png") {
            locationImageView?.kf.indicatorType = .activity
            locationImageView?.kf.setImage(
                with: url,
                placeholder: nil)
        }
    }
}
