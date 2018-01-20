//
//  Binance.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 17/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
struct Binance: ExchangeDelegate {

    static var name: Exchange { return .binance }

    static var baseCurrencies: [Currency] {
        return ["ADA", "ADX", "AION", "AMB", "APPC", "ARK", "ARN", "AST",
                "BAT", "BCC", "BCD", "BCPT", "BNB", "BNT", "BQX", "BRD",
                "BTC", "BTG", "BTS", "CDT", "CMT", "CND", "CTR", "DASH",
                "DGD", "DLT", "DNT", "EDO", "ELF", "ENG", "ENJ", "EOS",
                "ETC", "ETH", "EVX", "FUEL", "FUN", "GAS", "GTO", "GVT",
                "GXS", "HSR", "ICN", "ICX", "INS", "IOTA", "KMD", "KNC",
                "LEND", "LINK", "LRC", "LSK", "LTC", "LUN", "MANA", "MCO",
                "MDA", "MOD", "MTH", "MTL", "NAV", "NEBL", "NEO", "NULS",
                "OAX", "OMG", "OST", "POE", "POWR", "PPT", "QSP", "QTUM",
                "RCN", "RDN", "REQ", "RLC", "SALT", "SNGLS", "SNM", "SNT",
                "STORJ", "STRAT", "SUB", "TNB", "TNT", "TRIG", "TRX", "VEN",
                "VIB", "VIBE", "WABI", "WAVES", "WINGS", "WTC", "XLM", "XMR",
                "XRP", "XVG", "XZC", "YOYO", "ZEC", "ZRX"].map{ Currency($0)! }
    }

    private static let fiat: [String : [String]] = [
        "ADA" : ["ETH", "BTC"],
        "ADX" : ["ETH", "BNB", "BTC"],
        "AION" : ["ETH", "BNB", "BTC"],
        "AMB" : ["ETH", "BNB", "BTC"],
        "APPC" : ["ETH", "BNB", "BTC"],
        "ARK" : ["ETH", "BTC"],
        "ARN" : ["ETH", "BTC"],
        "AST" : ["ETH", "BTC"],
        "BAT" : ["ETH", "BNB", "BTC"],
        "BCC" : ["USDT", "ETH", "BTC", "BNB"],
        "BCD" : ["ETH", "BTC"],
        "BCPT" : ["ETH", "BNB", "BTC"],
        "BNB" : ["ETH", "USDT", "BTC"],
        "BNT" : ["BTC", "ETH"],
        "BQX" : ["ETH", "BTC"],
        "BRD" : ["ETH", "BNB", "BTC"],
        "BTC" : ["USDT"],
        "BTG" : ["ETH", "BTC"],
        "BTS" : ["ETH", "BNB", "BTC"],
        "CDT" : ["ETH", "BTC"],
        "CMT" : ["ETH", "BNB", "BTC"],
        "CND" : ["ETH", "BNB", "BTC"],
        "CTR" : ["ETH", "BTC"],
        "DASH" : ["ETH", "BTC"],
        "DGD" : ["ETH", "BTC"],
        "DLT" : ["BTC", "ETH", "BNB"],
        "DNT" : ["BTC", "ETH"],
        "EDO" : ["ETH", "BTC"],
        "ELF" : ["ETH", "BTC"],
        "ENG" : ["ETH", "BTC"],
        "ENJ" : ["ETH", "BTC"],
        "EOS" : ["BTC", "ETH"],
        "ETC" : ["BTC", "ETH"],
        "ETH" : ["USDT", "BTC"],
        "EVX" : ["ETH", "BTC"],
        "FUEL" : ["ETH", "BTC"],
        "FUN" : ["ETH", "BTC"],
        "GAS" : ["BTC"],
        "GTO" : ["ETH", "BNB", "BTC"],
        "GVT" : ["ETH", "BTC"],
        "GXS" : ["ETH", "BTC"],
        "HSR" : ["ETH", "BTC"],
        "ICN" : ["BTC", "ETH"],
        "ICX" : ["ETH", "BNB", "BTC"],
        "INS" : ["ETH", "BTC"],
        "IOTA" : ["ETH", "BNB", "BTC"],
        "KMD" : ["ETH", "BTC"],
        "KNC" : ["ETH", "BTC"],
        "LEND" : ["ETH", "BTC"],
        "LINK" : ["ETH", "BTC"],
        "LRC" : ["ETH", "BTC"],
        "LSK" : ["ETH", "BNB", "BTC"],
        "LTC" : ["USDT", "ETH", "BTC", "BNB"],
        "LUN" : ["ETH", "BTC"],
        "MANA" : ["ETH", "BTC"],
        "MCO" : ["BTC", "BNB", "ETH"],
        "MDA" : ["ETH", "BTC"],
        "MOD" : ["ETH", "BTC"],
        "MTH" : ["ETH", "BTC"],
        "MTL" : ["ETH", "BTC"],
        "NAV" : ["ETH", "BNB", "BTC"],
        "NEBL" : ["ETH", "BNB", "BTC"],
        "NEO" : ["USDT", "ETH", "BTC", "BNB"],
        "NULS" : ["BTC", "ETH", "BNB"],
        "OAX" : ["BTC", "ETH"],
        "OMG" : ["ETH", "BTC"],
        "OST" : ["ETH", "BNB", "BTC"],
        "POE" : ["ETH", "BTC"],
        "POWR" : ["ETH", "BNB", "BTC"],
        "PPT" : ["ETH", "BTC"],
        "QSP" : ["ETH", "BNB", "BTC"],
        "QTUM" : ["BTC", "ETH"],
        "RCN" : ["ETH", "BNB", "BTC"],
        "RDN" : ["ETH", "BNB", "BTC"],
        "REQ" : ["ETH", "BTC"],
        "RLC" : ["ETH", "BNB", "BTC"],
        "SALT" : ["ETH", "BTC"],
        "SNGLS" : ["ETH", "BTC"],
        "SNM" : ["ETH", "BTC"],
        "SNT" : ["BTC", "ETH"],
        "STORJ" : ["ETH", "BTC"],
        "STRAT" : ["ETH", "BTC"],
        "SUB" : ["ETH", "BTC"],
        "TNB" : ["ETH", "BTC"],
        "TNT" : ["ETH", "BTC"],
        "TRIG" : ["ETH", "BNB", "BTC"],
        "TRX" : ["ETH", "BTC"],
        "VEN" : ["BTC", "ETH", "BNB"],
        "VIB" : ["ETH", "BTC"],
        "VIBE" : ["ETH", "BTC"],
        "WABI" : ["ETH", "BNB", "BTC"],
        "WAVES" : ["ETH", "BNB", "BTC"],
        "WINGS" : ["ETH", "BTC"],
        "WTC" : ["ETH", "BNB", "BTC"],
        "XLM" : ["ETH", "BNB", "BTC"],
        "XMR" : ["ETH", "BTC"],
        "XRP" : ["ETH", "BTC"],
        "XVG" : ["ETH", "BTC"],
        "XZC" : ["ETH", "BNB", "BTC"],
        "YOYO" : ["ETH", "BNB", "BTC"],
        "ZEC" : ["ETH", "BTC"],
        "ZRX" : ["ETH", "BTC"]
    ]

    static func FIATCurriences(crypto: Currency) -> [Currency] {
        let selected = fiat[crypto.stringValue]!
        return selected.map { Currency($0)! }
    }

    static func urlRequest(for: Set<Pair>) -> URLRequest {
        return URLRequest(url: URL(string: "https://api.binance.com/api/v1/ticker/allPrices")!)
    }

    static func fetchRate(_ pairs: Set<Pair>, completion: @escaping ([Pair : Double]) -> Void) {
        URLSession.shared.dataTask(with: urlRequest(for: pairs)) { (data, response, error) in
            guard error == nil else {
                Log.error("Error \(error!)")
                return;
            }
            guard data != nil else {
                Log.error("Data is nil"); return;
            }
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [[String : Any]] else {
                let str = String(data: data!, encoding: .utf8)!
                Log.error("JSON parsing error \(str)")
                return;
            }

            var aDict = [String : Double]()
            for a in json {
                let symbol = a["symbol"] as! String
                let price = a["price"] as! String
                    aDict[symbol] = Double(price)
            }
            var dict = [Pair : Double]()
            for pair in pairs {
                dict[pair] = aDict[pair.joined()]
            }
            completion(dict)
        }.resume()
    }
}
