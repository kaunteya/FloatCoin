//
//  RatesController.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation


protocol RatesDelegate {
    func ratesUpdated(for exchange: Exchange, pair: Pair, price: Double)
}

/// Will fetch rates for all the selected exchange:pairs from UserDefaults
/// Will also fetch rate for passed exchange:pair, for newly added pair
class RatesController: NSObject {
    var timer: Timer!
    var delegate: RatesDelegate?

    func startTimer() {
        log.debug("Timer started")
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            if let all = UserDefaults.pairsForAllExchanges {
                self.fetchRates(for: all)
            }
        }
        timer.fire()
    }

    func stopTimer() {
        timer.invalidate()
    }

    /// Fetch rate for list of userExchangePair
    /// This method aggregates all pairs of each exchange ans sends only one request
    /// per exchange
    private func fetchRates(for dict: [Exchange: Set<Pair>]) {
        dict.keys.forEach { exchange in
            let pairs = dict[exchange]!
            exchange.type.fetchRate(pairs, completion: { (pricesDict) in
                pricesDict.forEach { (pair, price) in
                    self.delegate?.ratesUpdated(for: exchange, pair: pair, price: price)
                }
            })
        }

    }

    // Fetch rate for single userExchangePair
    // This will be used when rate is to be fetched of newly added element
    func fetchRate(exchange: Exchange, pair: Pair) {
        exchange.type.fetchRate([pair]) { (pricesDict) in
            pricesDict.forEach{ (pair, price) in
                self.delegate?.ratesUpdated(for: exchange, pair: pair, price: price)
            }
        }
    }

}
