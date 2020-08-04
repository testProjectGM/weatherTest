//
//  SessionExtension.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

extension Session: ReactiveCompatible {}

extension Reactive where Base: Session {
    func send<T: Request>(_ request: T) -> Single<T.Response> {
        return Single<T.Response>.create { [weak base] observer -> Disposable in
            guard let _base = base else { return Disposables.create() }
            let task = _base.send(request) { result in
                switch result {
                case .success(let value):
                    observer(.success(value))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
}
