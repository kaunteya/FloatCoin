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

    private func adjustedPrecision(_ num: Double) -> Int {
        // Trailing zeros are taken to keep the window size uniform
        switch num {
        case 1000...:          return 0
        case 100...:           return 1
        case 10...:            return 2
        case 1...:             return 3
        case 0.001...:         return 5
        case 0.0001...:        return 6
        case 0.00001...:       return 7
        case 0.000001...:      return 8
        case 0.0000001...:     return 9
        case 0.00000001...:    return 10
        case 0.000000001...:   return 11
        case 0.0000000001...:  return 12
        default: return 13
        }
    }

    func formatted(price: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.maximumFractionDigits = self.adjustedPrecision(price)
        currencyFormatter.minimumFractionDigits = self.adjustedPrecision(price)

        if let locale = Locale(stringValue) {
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = locale
            return currencyFormatter.string(from: NSNumber(value: price))!
        }
        currencyFormatter.numberStyle = .decimal
        let formattedPrice = currencyFormatter.string(from: NSNumber(value: price))!
        return "\(stringValue) \(formattedPrice)"
    }
}

extension Currency: CustomStringConvertible {
    var description: String {
        return stringValue
    }
}

extension Currency: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(stringValue)
    }

    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}

