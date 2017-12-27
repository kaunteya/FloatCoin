//
//  RatesController.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation


protocol RatesDelegate {
    func ratesUpdated(for exchangePair: UserExchangePair, price: Double)
}

class RatesController {
    var timer: Timer!
    var delegate: RatesDelegate?

    static var userExchangePairList: [UserExchangePair] {
        return UserDefaults.userExchangePairList
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.fetchCurrentRates(for: RatesController.userExchangePairList)
        }
        timer.fire()
    }

    func stopTimer() {
        timer.invalidate()
    }

    func fetchCurrentRates(for exchangePairList: [UserExchangePair]) {
        Exchange.all.forEach { exchange in
            let pairs = exchangePairList.allPairs(of: exchange)
            guard pairs.count != 0 else { return }
            exchange.type.fetchRate(pairs, completion: { pricesDict in
                pricesDict.forEach { (pair, price) in
                    self.delegate?.ratesUpdated(
                        for: UserExchangePair(exchange: exchange, pair: pair),
                        price: price
                    )
                }
            })
        }
    }
}


