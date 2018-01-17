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
        // https://api.bitfinex.com/v2/tickers?symbols=tBTCUSD,tLTCUSD,fUSD
        var tickerURLComponent = URLComponents(string: "https://api.bitfinex.com/v2/tickers")!
        let pairList = pairs.map { "t" + $0.joined() }.joined(separator: ",")
        tickerURLComponent.queryItems = [URLQueryItem(name: "symbols", value: pairList)]
        return URLRequest(url: tickerURLComponent.url!)
    }

    static func baseCryptoCurriencies() -> [Currency] {
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

    }
}
