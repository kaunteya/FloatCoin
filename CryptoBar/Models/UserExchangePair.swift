//
//  UserExchangePair.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 26/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

struct UserExchangePair {
    let exchange: Exchange, pair: Pair

}

extension UserExchangePair: LosslessStringConvertible {
    init?(_ exchangePairString: String) {
        let arr = exchangePairString.split(separator: "|")
        assert(arr.count == 2, "Must be in format cex|BTC:USD")
        self.exchange = Exchange(rawValue: "\(arr[0])")!
        self.pair = Pair("\(arr[1])")
    }


    var description: String {
        // returns format "cex|BTC:USD". Dont change this format as it is persistant
        return "\(exchange.rawValue)|\(pair.joined(":"))"
    }
}

extension UserExchangePair: Hashable {
    var hashValue: Int {
        return description.hashValue
    }

    static func ==(lhs: UserExchangePair, rhs: UserExchangePair) -> Bool {
        return lhs.exchange == rhs.exchange && lhs.pair == rhs.pair
    }
}
