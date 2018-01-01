//
//  CEX.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
struct CEX: ExchangeDelegate {
    static var name: Exchange = .cex

    static func urlRequest(for pairs: Set<Pair>) -> URLRequest {
        var pp = Set<Currency>()
        pairs.forEach {
            pp.insert($0.a)
            pp.insert($0.b)
        }

        let cur = pp.map { $0.stringValue }.joined(separator: "/")
        let url = URL(string: "https://cex.io/api/tickers/\(cur)/")
        return URLRequest(url: url!)
    }

    static func baseCryptoCurriencies() -> [Currency] {
        return ["BTC", "ETH", "BCH", "BTG", "DASH", "XRP", "ZEC", "GHS"].map { Currency($0)! }
    }

    private static let fiat: [String : [String]] = [
        "BTC": ["USD", "EUR", "RUB", "GBP"],
        "ETH": ["USD", "EUR", "GBP", "BTC"],
        "BCH": ["USD", "EUR", "GBP", "BTC"],
        "BTG": ["USD", "EUR", "BTC"],
        "DASH": ["USD", "EUR", "GBP", "BTC"],
        "XRP": ["USD", "EUR", "BTC"],
        "ZEC": ["USD", "EUR", "GBP", "BTC"],
        "GHS": ["BTC"]
    ]

    static func FIATCurriences(crypto: Currency) -> [Currency] {
         return fiat[crypto.stringValue]!.map { Currency($0)! }
    }

    static func fetchRate(_ pairs: Set<Pair>, completion: @escaping ([Pair : Double]) -> Void) {
        let urlRequest = self.urlRequest(for: pairs)
        log.debug("CEX URL \(urlRequest)")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                log.error("Error \(error!)")
                return;
            }
            guard data != nil else {
                log.error("Data is nil"); return;
            }
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any] else {
                log.error("JSON parsing error")
                return;
            }
            let result = json["data"] as! [[String: Any]]
            var dict = [Pair: Double]()
            for pair in pairs {
                let gre = result.filter{ $0["pair"] as! String == pair.joined(":") }.first!
                dict[pair] = Double(gre["last"] as! String)!
            }
            completion(dict)
            }.resume()

    }
}
