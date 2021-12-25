//
//  Observable.swift
//  BikPik
//
//  Created by jihee moon on 2021/12/25.
//

import Foundation

final class Observable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
