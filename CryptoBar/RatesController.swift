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
    func pairAdded(userPair: UserExchangePair)
    func pairsRemoved(at indexSet: IndexSet)
}

class RatesController: NSObject {
    var timer: Timer!
    var delegate: RatesDelegate?

    static var userExchangePairList: [UserExchangePair] {
        return UserDefaults.userExchangePairList
    }

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onPairAdd), name: UserDefaults.notificationPairAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPairDelete), name: UserDefaults.notificationPairRemoved, object: nil)
    }

    func onPairAdd(notification: Notification) {
        let newPair = RatesController.userExchangePairList.last!
        delegate?.pairAdded(userPair: newPair)
        self.fetchRate(for: newPair)
    }

    func onPairDelete(notification: Notification) {
        let indexSet = notification.userInfo!["indexSet"] as! IndexSet
        delegate?.pairsRemoved(at: indexSet)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.fetchRates(for: RatesController.userExchangePairList)
        }
        timer.fire()
    }

    func stopTimer() {
        timer.invalidate()
    }

    /// Fetch rate for list of userExchangePair
    /// This method aggregates all pairs of each exchange ans sends only one request
    /// per exchange
    private func fetchRates(for exchangePairList: [UserExchangePair]) {
        Exchange.all.forEach { exchange in
            let pairs = exchangePairList.allPairs(of: exchange)
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

    // Fetch rate for single userExchangePair
    // This will be used when rate is to be fetched of newly added element
    private func fetchRate(for exchangePair: UserExchangePair) {
        exchangePair.exchange.type.fetchRate([exchangePair.pair]) { (pricesDict) in
            pricesDict.forEach{ (pair, price) in
                self.delegate?.ratesUpdated(for: exchangePair, price: price)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(UserDefaults.notificationPairAdded)
        NotificationCenter.default.removeObserver(UserDefaults.notificationPairRemoved)
    }
}


