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
    init(_ a: Currency, _ b: Currency) {
        self.a = a
        self.b = b
    }

    init(_ a: String, _ b: String) {
        self.a = Currency(a)
        self.b = Currency(b)
    }
}

extension Pair {
    /// Supply ABC:XYZ
    init?(colonString: String) {
        let split = colonString.split(separator: ":")
        guard split.count == 2 else {
            return nil
        }
        self.a = Currency("\(split[0])")
        self.b = Currency("\(split[1])")
    }

    /// Joins by a seperator. Default: Empty String
    func joined(_ seperator: String = "") -> String {
        return "\(a)\(seperator)\(b)"
    }
}

extension Pair: Hashable {
    static func ==(lhs: Pair, rhs: Pair) -> Bool {
        return lhs.a == rhs.a && lhs.b == rhs.b
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(a.stringValue)
        hasher.combine(b.stringValue)
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
