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
        return ["ABS", "AGI", "AID", "AIO", "ANT", "ATM", "AUC", "AVT", "BAT", "BBN", "BCH", "BCI", "BFT", "BNT", "BOX", "BTC", "BTG", "CBT", "CFI", "CND", "CNN", "CTX", "DAD", "DAI", "DAT", "DGX", "DSH", "DTA", "DTH", "EDO", "ELF", "EOS", "ESS", "ETC", "ETH", "ETP", "FSN", "FUN", "GNT", "GOT", "HOT", "IOS", "IOT", "IQX", "KNC", "LRC", "LTC", "LYM", "MAN", "MIT", "MKR", "MNA", "MTN", "NCA", "NEO", "NIO", "ODE", "OMG", "ORS", "PAI", "POA", "POY", "QSH", "QTM", "RCN", "RDN", "REP", "REQ", "RLC", "RRT", "SAN", "SEE", "SEN", "SNG", "SNT", "SPK", "STJ", "TKN", "TNB", "TRX", "UTK", "UTN", "VEE", "VET", "WAX", "WPR", "XLM", "XMR", "XRA", "XRP", "XTZ", "XVG", "YYW", "ZCN", "ZEC", "ZIL", "ZRX"].map{ Currency($0) }
    }

    private static let fiat: [String : [String]] = [
        "ABS" : ["ETH", "USD"],
        "AGI" : ["USD", "ETH", "BTC"],
        "AID" : ["ETH", "USD", "BTC"],
        "AIO" : ["USD", "ETH", "BTC"],
        "ANT" : ["USD", "ETH", "BTC"],
        "ATM" : ["ETH", "USD", "BTC"],
        "AUC" : ["ETH", "USD", "BTC"],
        "AVT" : ["USD", "ETH", "BTC"],
        "BAT" : ["USD", "ETH", "BTC"],
        "BBN" : ["ETH", "USD"],
        "BCH" : ["USD", "ETH", "BTC"],
        "BCI" : ["USD", "BTC"],
        "BFT" : ["USD", "ETH", "BTC"],
        "BNT" : ["ETH", "USD", "BTC"],
        "BOX" : ["USD", "ETH"],
        "BTC" : ["EUR", "JPY", "GBP", "USD"],
        "BTG" : ["USD", "BTC"],
        "CBT" : ["USD", "ETH", "BTC"],
        "CFI" : ["USD", "ETH", "BTC"],
        "CND" : ["USD", "ETH", "BTC"],
        "CNN" : ["ETH", "USD"],
        "CTX" : ["ETH", "USD", "BTC"],
        "DAD" : ["ETH", "USD", "BTC"],
        "DAI" : ["USD", "ETH", "BTC"],
        "DAT" : ["ETH", "USD", "BTC"],
        "DGX" : ["ETH", "USD"],
        "DSH" : ["USD", "BTC"],
        "DTA" : ["USD", "ETH", "BTC"],
        "DTH" : ["USD", "ETH", "BTC"],
        "EDO" : ["USD", "ETH", "BTC"],
        "ELF" : ["USD", "ETH", "BTC"],
        "EOS" : ["ETH", "JPY", "EUR", "GBP", "BTC", "USD"],
        "ESS" : ["ETH", "USD", "BTC"],
        "ETC" : ["USD", "BTC"],
        "ETH" : ["JPY", "USD", "GBP", "BTC", "EUR"],
        "ETP" : ["USD", "ETH", "BTC"],
        "FSN" : ["ETH", "USD", "BTC"],
        "FUN" : ["USD", "ETH", "BTC"],
        "GNT" : ["USD", "ETH", "BTC"],
        "GOT" : ["USD", "EUR", "ETH"],
        "HOT" : ["ETH", "USD", "BTC"],
        "IOS" : ["ETH", "USD", "BTC"],
        "IOT" : ["ETH", "USD", "JPY", "GBP", "BTC", "EUR"],
        "IQX" : ["USD", "EOS", "BTC"],
        "KNC" : ["ETH", "USD", "BTC"],
        "LRC" : ["USD", "ETH", "BTC"],
        "LTC" : ["USD", "BTC"],
        "LYM" : ["USD", "ETH", "BTC"],
        "MAN" : ["ETH", "USD"],
        "MIT" : ["USD", "ETH", "BTC"],
        "MKR" : ["USD", "ETH", "BTC"],
        "MNA" : ["ETH", "USD", "BTC"],
        "MTN" : ["ETH", "USD", "BTC"],
        "NCA" : ["USD", "ETH", "BTC"],
        "NEO" : ["ETH", "EUR", "JPY", "GBP", "BTC", "USD"],
        "NIO" : ["ETH", "USD"],
        "ODE" : ["USD", "ETH", "BTC"],
        "OMG" : ["ETH", "USD", "BTC"],
        "ORS" : ["USD", "ETH", "BTC"],
        "PAI" : ["USD", "BTC"],
        "POA" : ["ETH", "USD", "BTC"],
        "POY" : ["USD", "ETH", "BTC"],
        "QSH" : ["ETH", "USD", "BTC"],
        "QTM" : ["ETH", "USD", "BTC"],
        "RCN" : ["USD", "ETH", "BTC"],
        "RDN" : ["ETH", "USD", "BTC"],
        "REP" : ["USD", "ETH", "BTC"],
        "REQ" : ["USD", "ETH", "BTC"],
        "RLC" : ["USD", "ETH", "BTC"],
        "RRT" : ["USD", "BTC"],
        "SAN" : ["ETH", "USD", "BTC"],
        "SEE" : ["USD", "ETH", "BTC"],
        "SEN" : ["ETH", "USD", "BTC"],
        "SNG" : ["ETH", "USD", "BTC"],
        "SNT" : ["ETH", "USD", "BTC"],
        "SPK" : ["USD", "ETH", "BTC"],
        "STJ" : ["ETH", "USD", "BTC"],
        "TKN" : ["ETH", "USD"],
        "TNB" : ["ETH", "USD", "BTC"],
        "TRX" : ["USD", "ETH", "BTC"],
        "UTK" : ["ETH", "USD", "BTC"],
        "UTN" : ["ETH", "USD"],
        "VEE" : ["ETH", "USD", "BTC"],
        "VET" : ["USD", "ETH", "BTC"],
        "WAX" : ["ETH", "USD", "BTC"],
        "WPR" : ["USD", "ETH", "BTC"],
        "XLM" : ["ETH", "JPY", "EUR", "GBP", "BTC", "USD"],
        "XMR" : ["USD", "BTC"],
        "XRA" : ["ETH", "USD"],
        "XRP" : ["USD", "BTC"],
        "XTZ" : ["USD", "BTC"],
        "XVG" : ["JPY", "ETH", "USD", "GBP", "BTC", "EUR"],
        "YYW" : ["USD", "ETH", "BTC"],
        "ZCN" : ["USD", "ETH", "BTC"],
        "ZEC" : ["USD", "BTC"],
        "ZIL" : ["ETH", "USD", "BTC"],
        "ZRX" : ["ETH", "USD", "BTC"],
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
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [[Any]] else {
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

