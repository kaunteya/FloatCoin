//
//  Pair.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

struct Pair {
    let a: Currency, b: Currency
}

extension Pair {
    /// Supply ABC:XYZ
    init(_ aColonB: String) {
        let split = aColonB.split(separator: ":")
        guard split.count == 2 else {
            fatalError()
        }
        self.a = Currency("\(split[0])")!
        self.b = Currency("\(split[1])")!
    }
    func joined(_ seperator: String) -> String {
        return "\(a)\(seperator)\(b)"
    }
}

extension Pair: Hashable {
    static func ==(lhs: Pair, rhs: Pair) -> Bool {
        return lhs.a == rhs.a && lhs.b == rhs.b
    }

    var hashValue: Int {
        return (a.stringValue + b.stringValue).hashValue
    }
}

extension Pair: Comparable {
    static func <(lhs: Pair, rhs: Pair) -> Bool {
        return lhs.joined(":") < rhs.joined(":")
    }
}

extension Pair: CustomStringConvertible {
    var description: String {
        return self.joined(":")
    }
}
