//
//  RatesController.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

typealias UserExchangePair = (exchange: Exchange, pair: Pair)

protocol RatesDelegate {
    func ratesUpdated(for exchangePair: UserExchangePair, price: Double)
}

class RatesFetcher {
    var timer: Timer!
    var userExchangePairList: [UserExchangePair]
    var delegate: RatesDelegate?
    init() {
        userExchangePairList = [(Exchange.coinbase, Pair("BTC:USD")), (Exchange.cex, Pair("ETH:USD"))]
    }

    func pairs(for exchange: Exchange) -> [Pair] {
        let filterd = userExchangePairList.filter { (aExchange, aPair) -> Bool in
            return exchange == aExchange
        }
        return filterd.map { (_, pair) -> Pair in
            return pair
        }
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fetchCurrentRates()
        }
        timer.fire()
    }

    func stop() {
        timer.invalidate()
    }
    
    func fetchCurrentRates() {
        Exchange.all.forEach {
            let pars = self.pairs(for: $0)
            guard pars.count != 0 else { return }
            $0.type.fetchRate(pars, completion: { pricesDict in
                pricesDict.forEach { (pair, price) in
                    self.delegate?.ratesUpdated(for: (Exchange.cex, pair), price: price)
                }
            })
        }
    }

}
