//
//  Observable.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation

final class CustomObservable<Value> {

    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }

    private var observers = [Observer<Value>]()

    var value: Value {
        didSet { notifyObservers() }
    }

    init(_ value: Value) {
        self.value = value
    }

    func observe(on observer: AnyObject, skipInitial: Bool = false, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        if !skipInitial {
            observerBlock(self.value)
        }
    }

    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }

    private func notifyObservers() {
        for observer in observers {
            observer.block(self.value)
        }
    }
}

