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

class RatesFetcher {
    var timer: Timer!
    var userExchangePairList: [UserExchangePair]
    var delegate: RatesDelegate?
    init(exchagePairList: [UserExchangePair]) {
        userExchangePairList = exchagePairList
    }

    func pairs(for exchange: Exchange) -> [Pair] {
        let filterd = userExchangePairList.filter {
            return exchange == $0.exchange
        }
        return filterd.map { return $0.pair }
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.fetchCurrentRates()
        }
        timer.fire()
    }

    func stop() {
        timer.invalidate()
    }
    
    func fetchCurrentRates() {
        Exchange.all.forEach { exchange in
            let pairs = self.pairs(for: exchange)
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
