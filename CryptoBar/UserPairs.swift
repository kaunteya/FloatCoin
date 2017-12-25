//
//  UserPairs.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

typealias APIProviderPair = (provider: APIProvider, pair: Pair)//TODO: Update to Pair

//[(APIProvider.kraken, "BTC:USD"), (APIProvider.cex, "ETH:USD")]
class UserSettings {
    var orderedPairs:[APIProviderPair]
    init(settings: [APIProviderPair]) {
        orderedPairs = settings
    }

    func pairs(for provider: APIProvider) -> [Pair] {
        let filterd = orderedPairs.filter { (aProvider, aPair) -> Bool in
            return provider == aProvider
        }
        return filterd.map { (_, pair) -> Pair in
            return pair
        }
    }
}

