//
//  CurrentWeatherViewController.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: LocationCell.cellReuseId, bundle: nil), forCellWithReuseIdentifier: LocationCell.cellReuseId)
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                activityIndicator.style = .large
            } else {
                activityIndicator.style = .whiteLarge
            }
            activityIndicator.hidesWhenStopped = true
        }
    }

    var presenter: CurrentWeatherPresenterInterface!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.outputs.viewConfigure
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] entryEntity in
                self?.navigationItem.title = "Weather"
            })
            .disposed(by: disposeBag)

        presenter.outputs.weatherInLocationList.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        presenter.outputs.isLoading
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        presenter.outputs.error
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isLoading in
                let ac = UIAlertController(title: "Network Error", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true)
            })
            .disposed(by: disposeBag)


        presenter.inputs.viewDidLoadTrigger.onNext(())

        presenter.inputs.reloadTrigger.onNext(())
    }

}

extension CurrentWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.outputs.weatherInLocationList.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let weatherData = presenter.outputs.weatherInLocationList.value[safe: indexPath.row] else { return UICollectionViewCell() }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCell.cellReuseId, for: indexPath) as? LocationCell {
            let temperature = weatherData.current?.temperature.toString() ?? ""
            cell.configure(with: presenter.city, temperature: temperature, imageName: weatherData.current?.weatherDetails[0].icon ?? "")
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.inputs.didSelectItemTrigger.onNext(indexPath)
    }
}

extension CurrentWeatherViewController: Viewable {}
