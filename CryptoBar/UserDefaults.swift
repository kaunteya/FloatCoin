//
//  UserDefaults.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 26/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation


fileprivate let keyUserExchange = "userKeys"
extension UserDefaults {

    class func add(exchangePair: UserExchangePair) {
        let newList = userExchangePairList + [exchangePair]
        UserDefaults.standard.set(newList.map {$0.description}, forKey: keyUserExchange)
    }

    class func removeExchangePair(exchangePair: UserExchangePair) {
        let newList = userExchangePairList.filter { $0 != exchangePair}
        UserDefaults.standard.set(newList, forKey: keyUserExchange)
    }

    class var userExchangePairList: [UserExchangePair] {
        return UserDefaults.standard.stringArray(forKey: keyUserExchange)?.map {
            return UserExchangePair($0)!
        } ?? [UserExchangePair]()
    }
}
