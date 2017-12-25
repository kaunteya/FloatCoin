//
//  RatesController.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

protocol RatesDelegate {
    func ratesUpdated(for pair: Pair, price: Double)
}

class RatesFetcher {
    var timer: Timer!
    let userSettings: UserSettings
    var delegate: RatesDelegate?
    init() {
        userSettings = UserSettings(settings:
            [(APIProvider.kraken, Pair("BTC:USD")), (APIProvider.cex, Pair("ETH:USD"))]
        )
        start()
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
        
    }
}
