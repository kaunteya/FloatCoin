//
//  Bitfinex.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 16/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

struct Bitfinex: ExchangeProtocol {
    static var name: Exchange { return .bitfinex }

    static func urlRequest(for pairs: Set<Pair>) -> URLRequest {
        var tickerURLComponent = URLComponents(string: "https://api.bitfinex.com/v2/tickers")!
        let pairList = pairs.map { "t" + $0.joined().uppercased() }.joined(separator: ",")
        tickerURLComponent.queryItems = [URLQueryItem(name: "symbols", value: pairList)]
        return URLRequest(url: tickerURLComponent.url!)
    }

    static var baseCurrencies: [Currency] {
        return ["AGI", "AID", "AIO", "ANT", "AVT", "BAT", "BCH", "BFT", "BTC", "BTG", "CFI", "DAI", "DAT", "DSH", "DTH", "EDO", "ELF", "EOS", "ETC", "ETH", "ETP", "FUN", "GNT", "IOS", "IOT", "LRC", "LTC", "MIT", "MNA", "MTN", "NEO", "ODE", "OMG", "QSH", "QTM", "RCN", "RDN", "REP", "REQ", "RLC", "RRT", "SAN", "SNG", "SNT", "SPK", "STJ", "TNB", "TRX", "WAX", "XLM", "XMR", "XRP", "XVG", "YYW", "ZEC", "ZRX"].map{ Currency($0) }
    }

    private static let fiat: [String : [String]] = [
        "AGI" : ["USD", "ETH", "BTC"],
        "AID" : ["USD", "ETH", "BTC"],
        "AIO" : ["USD", "ETH", "BTC"],
        "ANT" : ["USD", "ETH", "BTC"],
        "AVT" : ["USD", "BTC", "ETH"],
        "BAT" : ["USD", "ETH", "BTC"],
        "BCH" : ["USD", "ETH", "BTC"],
        "BFT" : ["USD", "BTC", "ETH"],
        "BTC" : ["EUR", "GBP", "JPY", "USD"],
        "BTG" : ["USD", "BTC"],
        "CFI" : ["USD", "ETH", "BTC"],
        "DAI" : ["USD", "ETH", "BTC"],
        "DAT" : ["USD", "ETH", "BTC"],
        "DSH" : ["USD", "BTC"],
        "DTH" : ["USD", "BTC", "ETH"],
        "EDO" : ["USD", "BTC", "ETH"],
        "ELF" : ["USD", "ETH", "BTC"],
        "EOS" : ["ETH", "GBP", "EUR", "JPY", "BTC", "USD"],
        "ETC" : ["USD", "BTC"],
        "ETH" : ["EUR", "GBP", "JPY", "USD", "BTC"],
        "ETP" : ["USD", "BTC", "ETH"],
        "FUN" : ["USD", "ETH", "BTC"],
        "GNT" : ["USD", "ETH", "BTC"],
        "IOS" : ["USD", "ETH", "BTC"],
        "IOT" : ["EUR", "JPY", "ETH", "USD", "BTC", "GBP"],
        "LRC" : ["USD", "BTC", "ETH"],
        "LTC" : ["USD", "BTC"],
        "MIT" : ["USD", "ETH", "BTC"],
        "MNA" : ["USD", "ETH", "BTC"],
        "MTN" : ["USD", "ETH", "BTC"],
        "NEO" : ["EUR", "ETH", "JPY", "USD", "GBP", "BTC"],
        "ODE" : ["USD", "BTC", "ETH"],
        "OMG" : ["USD", "ETH", "BTC"],
        "QSH" : ["USD", "ETH", "BTC"],
        "QTM" : ["USD", "ETH", "BTC"],
        "RCN" : ["USD", "BTC", "ETH"],
        "RDN" : ["USD", "ETH", "BTC"],
        "REP" : ["USD", "BTC", "ETH"],
        "REQ" : ["USD", "ETH", "BTC"],
        "RLC" : ["USD", "BTC", "ETH"],
        "RRT" : ["USD", "BTC"],
        "SAN" : ["USD", "ETH", "BTC"],
        "SNG" : ["USD", "BTC", "ETH"],
        "SNT" : ["USD", "ETH", "BTC"],
        "SPK" : ["USD", "BTC", "ETH"],
        "STJ" : ["USD", "ETH", "BTC"],
        "TNB" : ["USD", "ETH", "BTC"],
        "TRX" : ["USD", "BTC", "ETH"],
        "WAX" : ["USD", "ETH", "BTC"],
        "XLM" : ["ETH", "JPY", "GBP", "EUR", "BTC", "USD"],
        "XMR" : ["USD", "BTC"],
        "XRP" : ["USD", "BTC"],
        "XVG" : ["ETH", "EUR", "GBP", "USD", "BTC", "JPY"],
        "YYW" : ["USD", "ETH", "BTC"],
        "ZEC" : ["USD", "BTC"],
        "ZRX" : ["USD", "ETH", "BTC"]
    ]

    static func FIATCurriences(crypto: Currency) -> [Currency] {
        let selected = fiat[crypto.stringValue]!
        return selected.map { Currency($0) }
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
        return Pair(colonString: pair)
    }
}

