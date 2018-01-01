//
//  UserDefaults.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 26/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let keyFloatOnTop = "floatOnTop"
    private static let keyUserExchange = "userKeys"

    static var floatOnTop: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyFloatOnTop)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyFloatOnTop)
        }
    }
    
    static let notificationPairDidAdd = NSNotification.Name(rawValue: "notificationPairDidAdd")
    static let notificationPairDidRemove = NSNotification.Name(rawValue: "notificationPairDidRemove")
    
    class func add(exchange: Exchange, pair: Pair) {
        var dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as? [String: [String]] ?? [String: [String]]()

        var list = dict[exchange.rawValue] ?? [String]()
        assert(!list.contains(pair.joined(":")), "Pair already added")
        list.append(pair.joined(":"))
        dict[exchange.rawValue] = list.sorted()
        UserDefaults.standard.set(dict, forKey: keyUserExchange)

        NotificationCenter.default.post(name: notificationPairDidAdd, object: nil, userInfo: ["exchange" : exchange, "pair":pair])
    }

    class func remove(exchange: Exchange, pair: Pair) {
        var dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as! [String: [String]]
        let list = dict[exchange.rawValue]!.filter{ $0 != pair.joined(":") }
        dict[exchange.rawValue] = list.isEmpty ? nil : list
        UserDefaults.standard.set(dict, forKey: keyUserExchange)

        NotificationCenter.default.post(name: notificationPairDidRemove, object: nil, userInfo: ["exchange" : exchange, "pair":pair])
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
