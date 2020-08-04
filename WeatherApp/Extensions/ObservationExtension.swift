//
//  RxHelpers.swift
//  WeatherApp
//
//  Created by Step on 02.08.2020.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public extension ObservableType where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return Observable<Element.Wrapped>.empty()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}
