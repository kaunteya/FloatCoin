//
//  UserDefaults.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 26/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation


extension UserDefaults {
    static let keyUserExchange = "userKeys"
    static let notificationPairAdded = NSNotification.Name(rawValue: "notificationPairAdded")
    static let notificationPairRemoved = NSNotification.Name(rawValue: "notificationPairRemoved")
    class func addDefaultCurrencies() {
        guard UserDefaults.standard.value(forKey: keyUserExchange) == nil else {
            return
        }
        Swift.print("Initialising Defaults")
        let list = [
            UserExchangePair(exchange: .cex, pair: Pair("BTC:USD")),
            UserExchangePair(exchange: .kraken, pair: Pair("BTC:USD")),
            UserExchangePair(exchange: .coinbase, pair: Pair("BTC:USD"))
        ]
        UserDefaults.standard.set(list.map {$0.description}, forKey: keyUserExchange)
    }
    
    class func add(exchangePair: UserExchangePair) {
        let newList = userExchangePairList + [exchangePair]
        UserDefaults.standard.set(newList.map {$0.description}, forKey: keyUserExchange)
        NotificationCenter.default.post(name: notificationPairAdded, object: nil, userInfo: nil)
    }

    class func removeExchangePair(at indexSet: IndexSet) {
        var newList = userExchangePairList
        //Sort elements in decending order to avoid removal in invalid index
        indexSet.sorted {$0 > $1}.forEach { newList.remove(at: $0) }
        UserDefaults.standard.set(newList.map {$0.description}, forKey: keyUserExchange)
        NotificationCenter.default.post(name: notificationPairRemoved, object: nil, userInfo: ["indexSet": indexSet])
    }

    class var userExchangePairList: [UserExchangePair] {
        return UserDefaults.standard.stringArray(forKey: keyUserExchange)?.map {
            return UserExchangePair($0)!
        } ?? [UserExchangePair]()
    }
}
