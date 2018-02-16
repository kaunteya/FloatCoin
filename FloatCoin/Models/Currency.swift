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

    init(_ cur: String) {
        stringValue = cur.uppercased()
    }

    var symbol: String {
        switch stringValue {
        case "USD" : return "$"
        case "GBP" : return "£"
        case "EUR:" : return "€"
        case "JPY" : return "¥"
        case "ZWD" : return "Z$"
        case "VND":  return "₫"
        case "INR" : return "₹"
        default: return stringValue
        }
    }

    private func adjustedPrecision(_ num: Double) -> Int {
        // Trailing zeros are taken to keep the window size uniform
        if num >= 1000 {
            return 0
        } else if num >= 100 { // 100-999
            return 1
        } else if num >= 10 { // 10-99
            return 2
        } else if num >= 1 { // 1-9
            return 3
        } else if num >= 0.0001 {
            return 5
        }
        return 6
    }

    func formatted(price: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.maximumFractionDigits = self.adjustedPrecision(price)
        currencyFormatter.minimumFractionDigits = self.adjustedPrecision(price)
        guard let locale = Locale(stringValue) else {
            currencyFormatter.numberStyle = .decimal

            let formattedPrice = currencyFormatter.string(from: NSNumber(value: price))!
            return "\(stringValue) \(formattedPrice)"
        }
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        return currencyFormatter.string(from: NSNumber(value: price))!
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

