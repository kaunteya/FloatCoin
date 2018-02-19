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
        return ["AID", "AVT", "BAT", "BCH", "BTC", "BTG", "DAT", "DSH", "EDO", "ELF", "EOS", "ETC", "ETH", "ETP", "FUN", "GNT", "IOT", "LTC", "MNA", "NEO", "OMG", "QSH", "QTM", "RCN", "REP", "RLC", "RRT", "SAN", "SNG", "SNT", "SPK", "TNB", "TRX", "XMR", "XRP", "YYW", "ZEC", "ZRX"].map{ Currency($0) }
    }

    private static let fiat: [String : [String]] = [
        "AID" : ["USD", "BTC", "ETH"] ,
        "AVT" : ["USD", "BTC", "ETH"] ,
        "BAT" : ["USD", "BTC", "ETH"] ,
        "BCH" : ["USD", "BTC", "ETH"] ,
        "BTC" : ["USD", "EUR"] ,
        "BTG" : ["USD", "BTC"] ,
        "DAT" : ["USD", "BTC", "ETH"] ,
        "DSH" : ["USD", "BTC"] ,
        "EDO" : ["USD", "BTC", "ETH"] ,
        "ELF" : ["USD", "BTC", "ETH"] ,
        "EOS" : ["USD", "BTC", "ETH"] ,
        "ETC" : ["BTC", "USD"] ,
        "ETH" : ["USD", "BTC"] ,
        "ETP" : ["USD", "BTC", "ETH"] ,
        "FUN" : ["USD", "BTC", "ETH"] ,
        "GNT" : ["USD", "BTC", "ETH"] ,
        "IOT" : ["USD", "BTC", "ETH", "EUR"] ,
        "LTC" : ["USD", "BTC"] ,
        "MNA" : ["USD", "BTC", "ETH"] ,
        "NEO" : ["USD", "BTC", "ETH"] ,
        "OMG" : ["USD", "BTC", "ETH"] ,
        "QSH" : ["USD", "BTC", "ETH"] ,
        "QTM" : ["USD", "BTC", "ETH"] ,
        "RCN" : ["USD", "BTC", "ETH"] ,
        "REP" : ["USD", "BTC", "ETH"] ,
        "RLC" : ["USD", "BTC", "ETH"] ,
        "RRT" : ["USD", "BTC"] ,
        "SAN" : ["USD", "BTC", "ETH"] ,
        "SNG" : ["USD", "BTC", "ETH"] ,
        "SNT" : ["USD", "BTC", "ETH"] ,
        "SPK" : ["USD", "BTC", "ETH"] ,
        "TNB" : ["USD", "BTC", "ETH"] ,
        "TRX" : ["USD", "BTC", "ETH"] ,
        "XMR" : ["USD", "BTC"] ,
        "XRP" : ["USD", "BTC"] ,
        "YYW" : ["USD", "BTC", "ETH"] ,
        "ZEC" : ["USD", "BTC"] ,
        "ZRX" : ["USD", "BTC", "ETH"] 
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

