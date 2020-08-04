//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Step on 03.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {

    @IBOutlet private weak var weatherImageView: UIImageView?
    @IBOutlet private weak var dateLabel: UILabel?

    var dateFormatter = DateFormatter()
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .blue : .purple
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .purple
        dateFormatter.dateFormat = "MMM dd \n EEEE"
    }

    func configure(with date: Date, imageName: String) {
        dateLabel?.text = dateFormatter.string(from: date)

        if let url = URL(string: "\(Constants.Basic.photoUrl)\(imageName)@2x.png") {
            weatherImageView?.kf.indicatorType = .activity
            weatherImageView?.kf.setImage(
                with: url,
                placeholder: nil)
        }
    }

}
