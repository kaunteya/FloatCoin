//
//  Currency.swift
//  CryptShow
//
//  Created by Kaunteya Suryawanshi on 18/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

struct Currency {
    let price: Double
    let pair: String
    init?(json : JSONDictionary) {
        guard let pair = json["pair"] as? String,
            let priceString = json["last"] as? String,
            let priceDouble = Double(priceString) else {
                return nil
        }
        self.pair = pair
        self.price = priceDouble
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
