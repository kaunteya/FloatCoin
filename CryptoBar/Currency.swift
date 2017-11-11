//
//  Currency.swift
//  CryptShow
//
//  Created by Kaunteya Suryawanshi on 18/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

struct Currency {
    let ask: Double
    let bid: Double
    let high: String
    let last: Double
    let low: String
    let pair: String
    let timestamp: Date
    let volume: String
    let volume30d: String

    init?(json : JSONDictionary) {
        guard let ask = json["ask"] as? Double,
            let bid = json["bid"] as? Double,
            let high = json["high"] as? String,
            let ll = json["last"] as? String, let last = Double(ll),
            let low = json["low"] as? String,
            let pair = json["pair"] as? String,
            let tt = json["timestamp"] as? String, let timestamp = Double(tt),
            let volume = json["volume"] as? String,
            let volume30d = json["volume30d"] as? String else {
                return nil
        }

        self.ask = ask
        self.bid = bid
        self.high = high
        self.last = last
        self.low = low
        self.pair = pair
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.volume = volume
        self.volume30d = volume30d
    }
}

// Sample JSON
//{
//    ask = "4346.7769";
//    bid = "4328.0005";
//    high = 4450;
//    last = "4335.6872";
//    low = 4300;
//    pair = "BTC:USD";
//    timestamp = 1503079334;
//    volume = "1156.11223322";
//    volume30d = "34798.16620952";
//}
