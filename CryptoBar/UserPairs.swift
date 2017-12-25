//
//  UserPairs.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

typealias UserExchangePair = (exchange: Exchange, pair: Pair)

class UserSettings {
    var orderedPairs:[UserExchangePair]
    init(settings: [UserExchangePair]) {
        orderedPairs = settings
    }

    func pairs(for exchange: Exchange) -> [Pair] {
        let filterd = orderedPairs.filter { (aExchange, aPair) -> Bool in
            return exchange == aExchange
        }
        return filterd.map { (_, pair) -> Pair in
            return pair
        }
    }
}

