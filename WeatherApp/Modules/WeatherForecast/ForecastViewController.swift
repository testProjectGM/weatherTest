//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Step on 03.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class ForecastViewController: UIViewController {

    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cloudsLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var dewPointLevel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var dayTemperatureLabel: UILabel!
    @IBOutlet private weak var nightTemperatureLabel: UILabel!
    @IBOutlet private weak var forecastCollectionView: UICollectionView! {
        didSet {
            forecastCollectionView.dataSource = self
            forecastCollectionView.delegate = self
            forecastCollectionView.register(UINib(nibName: ForecastCell.cellReuseId, bundle: nil), forCellWithReuseIdentifier: ForecastCell.cellReuseId)
        }
    }

    var presenter: ForecastPresenterInterface!
    var dateFormatter = DateFormatter()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "MMM dd, yyyy"
        presenter.outputs.viewConfigure
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] entryEntity in
                guard let self = self else { return }
                self.navigationItem.title = entryEntity.city
                self.forecastCollectionView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
                self.forecastCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                self.collectionView(self.forecastCollectionView, didSelectItemAt: indexPath)
            })
            .disposed(by: disposeBag)

        presenter.inputs.viewDidLoadTrigger.onNext(())
    }
}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.outputs.forecastData.value[safe: section]?.daily?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let weatherData = presenter.outputs.forecastData.value[safe: indexPath.section]?.daily?[safe: indexPath.row] else { return UICollectionViewCell() }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.cellReuseId, for: indexPath) as? ForecastCell {
            let date = Date(timeIntervalSince1970: weatherData.dayTime)
            let iconName = weatherData.weatherDetails[safe: 0]?.icon ?? ""
            cell.configure(with: date, imageName: iconName)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let weatherData = presenter.outputs.forecastData.value[safe: indexPath.section]?.daily?[safe: indexPath.row] else { return }
        if let icon = weatherData.weatherDetails[safe: 0]?.icon {
            setupImageView(imageName: icon)
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.cellReuseId, for: indexPath) as? ForecastCell {
            cell.isSelected = true
        }

        let date = Date(timeIntervalSince1970: weatherData.dayTime)
        dateLabel.text = dateFormatter.string(from: date)
        cloudsLabel.text = "Clouds: " + weatherData.clouds.toString()
        windSpeedLabel.text = "Wind speed: " + weatherData.windSpeed.toString()
        pressureLabel.text = "Pressure: " + weatherData.pressure.toString()
        dewPointLevel.text = "Dew point: " + weatherData.dewPoint.toString()
        humidityLabel.text = "Humidity: " + weatherData.humidity.toString()
        minTemperatureLabel.text = "Min temperature: \(weatherData.temperature.min)°C"
        maxTemperatureLabel.text = "Max temperature: \(weatherData.temperature.max)°C"
        dayTemperatureLabel.text = "Day temperature: \(weatherData.temperature.day)°C"
        nightTemperatureLabel.text = "Night temperature: \(weatherData.temperature.night)°C"

    }

    func setupImageView(imageName: String) {
        if let url = URL(string: "\(Constants.Basic.photoUrl)\(imageName)@2x.png") {
            weatherImageView?.kf.indicatorType = .activity
            weatherImageView?.kf.setImage(
                with: url,
                placeholder: nil)
        }
    }
}

extension ForecastViewController: Viewable {}
