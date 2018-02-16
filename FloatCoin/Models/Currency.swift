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
        if num >= 1000 {
            return 0
        } else if num >= 100 { // 100-999
            return 1
        } else if num >= 10 { // 10-99
            return 2
        } else if num >= 1 { // 1-9
            return 3
        }
        return 5
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

    var hashValue: Int {
       return stringValue.hashValue
    }

    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}

