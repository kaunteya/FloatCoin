//
//  Currency.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

struct Currency {
    let stringValue: String
}

extension Currency: LosslessStringConvertible {
    init?(_ description: String) {
        self.stringValue = description
    }
}

extension Currency: Hashable {
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }

    var hashValue: Int {
        return stringValue.hashValue
    }
}

extension Currency: CustomStringConvertible {
    var description: String {
        return stringValue
    }
}
