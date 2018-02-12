//
//  Currency.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 12/02/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
struct Currency {
    let stringValue: String
    init?(_ cur: String) {
        stringValue = cur
    }
    
    var symbol: String {
        switch stringValue {
        case "USD" : return "$"
        case "GBP" : return "£"
        case "EUR:" : return "€"
        case "JPY" : return "¥"
        case "ZWD" : return "Z$"
        case "VND":  return "₫"
        default: return stringValue
        }
    }
}

extension Currency: CustomStringConvertible {
    var description: String {
        return stringValue
    }
}

extension Currency: Hashable {

    var hashValue: Int {
       return stringValue.hashValue
    }

    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}
