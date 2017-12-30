//
//  UserDefaults.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 26/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation


extension UserDefaults {
    private static let keyUserExchange = "userKeys"

    static let notificationPairDidAdd = NSNotification.Name(rawValue: "notificationPairDidAdd")
    static let notificationPairDidRemove = NSNotification.Name(rawValue: "notificationPairDidRemove")
    
    class func add(exchange: Exchange, pair: Pair) {
        var dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as? [String: [String]] ?? [String: [String]]()

        var list = dict[exchange.rawValue] ?? [String]()
        guard !list.contains(pair.joined(":")) else {
            log.warning("Already present!!")
            return
        }
        list.append(pair.joined(":"))
        dict[exchange.rawValue] = list.sorted()
        UserDefaults.standard.set(dict, forKey: keyUserExchange)

        NotificationCenter.default.post(name: notificationPairDidAdd, object: nil, userInfo: ["exchange" : exchange, "pair":pair])
    }

    class func remove(exchange: Exchange, pair: Pair) {
        var dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as! [String: [String]]
        var list = dict[exchange.rawValue]!
        dict[exchange.rawValue] = list.filter{ $0 != pair.joined(":") }
        UserDefaults.standard.set(dict, forKey: keyUserExchange)

        NotificationCenter.default.post(name: notificationPairDidRemove, object: nil, userInfo: ["exchange" : exchange, "pair":pair])
    }

    class var userExchangePairList: [UserExchangePair] {
        return UserDefaults.standard.stringArray(forKey: keyUserExchange)?.map {
            return UserExchangePair($0)!
        } ?? [UserExchangePair]()
    }

    class func has(exchange: Exchange, pair: Pair) -> Bool {
        if let all = pairsForAllExchanges {
            return all.contains(where: { (aExchange, aPairList) -> Bool in
                return exchange == aExchange && aPairList.contains(pair)
            })
        }
        return false
    }

    class var pairsForAllExchanges: [Exchange: Set<Pair>]? {
        guard let dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as? [String: [String]]else {
            return nil
        }
        var newDict = [Exchange: Set<Pair>]()
        for (key, value) in dict {
            newDict[Exchange(rawValue: key)!] = Set(value.map { Pair($0)})
        }
        return newDict
    }
}
