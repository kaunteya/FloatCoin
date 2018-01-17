//
//  Bitfinex.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 16/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

struct Bitfinex: ExchangeDelegate {
    static var name: Exchange { return .bitfinex }

    static func urlRequest(for pairs: Set<Pair>) -> URLRequest {
        var tickerURLComponent = URLComponents(string: "https://api.bitfinex.com/v2/tickers")!
        let pairList = pairs.map { "t" + $0.joined().uppercased() }.joined(separator: ",")
        tickerURLComponent.queryItems = [URLQueryItem(name: "symbols", value: pairList)]
        return URLRequest(url: tickerURLComponent.url!)
    }

    static var baseCurrencies: [Currency] {
        return ["AVT", "BAT", "BCH", "BTC", "BTG",
                "DAT", "DSH", "EDO", "EOS", "ETC",
                "ETH", "ETP", "FUN", "GNT", "IOT",
                "LTC", "MNA", "NEO", "OMG", "QSH",
                "QTM", "RRT", "SAN", "SNT", "SPK",
                "TNB", "XMR", "XRP", "YYW", "ZEC",
                "ZRX"].map{ Currency($0)! }
    }

    private static let fiat: [String : [String]] = [
        "AVT" : ["ETH", "USD", "BTC"],
        "BAT" : ["ETH", "USD", "BTC"],
        "BCH" : ["ETH", "USD", "BTC"],
        "BTC" : ["EUR", "USD"],
        "BTG" : ["USD", "BTC"],
        "DAT" : ["ETH", "USD", "BTC"],
        "DSH" : ["USD", "BTC"],
        "EDO" : ["ETH", "USD", "BTC"],
        "EOS" : ["ETH", "USD", "BTC"],
        "ETC" : ["USD", "BTC"],
        "ETH" : ["USD", "BTC"],
        "ETP" : ["ETH", "USD", "BTC"],
        "FUN" : ["ETH", "USD", "BTC"],
        "GNT" : ["ETH", "USD", "BTC"],
        "IOT" : ["EUR", "USD", "ETH", "BTC"],
        "LTC" : ["USD", "BTC"],
        "MNA" : ["ETH", "USD", "BTC"],
        "NEO" : ["ETH", "USD", "BTC"],
        "OMG" : ["ETH", "USD", "BTC"],
        "QSH" : ["ETH", "USD", "BTC"],
        "QTM" : ["ETH", "USD", "BTC"],
        "RRT" : ["USD", "BTC"],
        "SAN" : ["ETH", "USD", "BTC"],
        "SNT" : ["ETH", "USD", "BTC"],
        "SPK" : ["ETH", "USD", "BTC"],
        "TNB" : ["ETH", "USD", "BTC"],
        "XMR" : ["USD", "BTC"],
        "XRP" : ["USD", "BTC"],
        "YYW" : ["ETH", "USD", "BTC"],
        "ZEC" : ["USD", "BTC"],
        "ZRX" : ["ETH", "USD", "BTC"]
    ]

    static func FIATCurriences(crypto: Currency) -> [Currency] {
        let selected = fiat[crypto.stringValue]!
        return selected.map { Currency($0)! }
    }

    static func fetchRate(_ pairs: Set<Pair>, completion: @escaping ([Pair : Double]) -> Void) {
        let urlRequest = self.urlRequest(for: pairs)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                Log.error("Error \(error!)")
                return;
            }
            guard data != nil else {
                Log.error("Data is nil"); return;
            }
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [[Any]] else {
                let str = String(data: data!, encoding: .utf8)!
                Log.error("JSON parsing error \(str)")
                return;
            }

            var dict = [Pair: Double]()
            for a in json {
                if let pairStr = a[0] as? String,
                    let pair = convertToPair(pairStr),
                    let price = a[1] as? Double {
                    dict[pair] = price
                }
            }
            completion(dict)
            }.resume()
    }

    static func convertToPair(_ str: String ) -> Pair? {
        var pair = str
        guard pair.starts(with: "t") else {
            return nil
        }
        pair = String(pair.dropFirst())
        pair.insert(":", at: pair.index(pair.startIndex, offsetBy: 3))
        return Pair(pair)
    }
}

