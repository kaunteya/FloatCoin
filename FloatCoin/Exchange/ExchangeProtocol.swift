//
//  Cryptoable.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

protocol ExchangeProtocol {
    static var name: Exchange {get}
    static var baseCurrencies: [Currency] { get}
    static func urlRequest(for: Set<Pair>) -> URLRequest
    static func FIATCurriences(crypto: Currency) -> [Currency]
    static func fetchRate(_ pairs: Set<Pair>, completion: @escaping ([Pair:Double])-> Void)
}
