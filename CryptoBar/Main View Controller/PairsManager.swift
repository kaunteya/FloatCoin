//
//  PairsManager.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 30/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

protocol PairManagerDelegate {
    func pair(added pair: Pair, to exchange: Exchange)
    func pair(removed pair: Pair, from exchange: Exchange)
}

///Responsibility: Add Pairs and delete pairs
class PairsManager: NSObject {
    var delegate: PairManagerDelegate?

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onPairAdd), name: UserDefaults.notificationPairDidAdd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPairDelete), name: UserDefaults.notificationPairDidRemove, object: nil)
    }

    func onPairAdd(notification: Notification) {
        let exchange = notification.userInfo!["exchange"] as! Exchange
        let pair = notification.userInfo!["pair"] as! Pair
        delegate?.pair(added: pair, to: exchange)
    }

    func onPairDelete(notification: Notification) {
        let exchange = notification.userInfo!["exchange"] as! Exchange
        let pair = notification.userInfo!["pair"] as! Pair
        delegate?.pair(removed: pair, from: exchange)
    }

    deinit {
        NotificationCenter.default.removeObserver(UserDefaults.notificationPairDidAdd)
        NotificationCenter.default.removeObserver(UserDefaults.notificationPairDidRemove)
    }
}
