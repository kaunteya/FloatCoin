//
//  Kraken.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
struct Kraken : ExchangeDelegate {
    static var name: Exchange = .kraken

    static func urlRequest(for pairs: Set<Pair>) -> URLRequest {
        var tickerURLComponent = URLComponents(string: "https://api.kraken.com/0/public/Ticker")!
        let pairList = pairs.map {$0.rawPairForAPI}.joined(separator: ",")
        tickerURLComponent.queryItems = [URLQueryItem(name: "pair", value: pairList)]
        return URLRequest(url: tickerURLComponent.url!)
    }

    static func fetchRate(_ pairs: Set<Pair>, completion: @escaping ([Pair : Double]) -> Void) {
        let urlRequest = self.urlRequest(for: pairs)
        log.info("Kraken URL \(urlRequest)")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                log.error("Error \(error!)")
                return;
            }
            guard data != nil else {
                log.error("Data is nil"); return;
            }
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any],
            let result = json["result"] as? [String: Any] else {
                log.error("JSON parsing error")
                return;
            }

            var dict = [Pair: Double]()
            for (pair, info) in result {
                let valStr = ((info as! [String: Any])["c"] as! [String]).first!
                dict[Pair(krakenPair: pair)!] = Double(valStr)
            }
            completion(dict)
        }.resume()
    }

    static func baseCryptoCurriencies() -> [Currency] {
        return ["BTC", "BCH", "DASH", "EOS", "ETC", "ETH", "GNO", "ICN", "LTC", "MLN", "REP", "USDT", "XDG", "XLM", "XMR", "XRP", "ZEC"].map{ Currency($0)! }
    }

    private static let fiat: [String : [String]] = [
        "BTC" : ["CAD", "EUR", "GBP", "JPY", "USD"],
        "BCH" : ["EUR", "USD", "BTC"],
        "DASH": ["EUR", "USD", "BTC"],
        "EOS" : ["ETH", "BTC"],
        "ETC" : ["BTC", "ETH", "EUR", "USD"],
        "ETH" : ["BTC", "CAD", "EUR", "GBP", "JPY", "USD"],
        "GNO" : ["ETH", "BTC"],
        "ICN" : ["ETH", "BTC"],
        "LTC" : ["BTC", "EUR", "USD"],
        "MLN" : ["ETH", "BTC"],
        "REP" : ["ETH", "BTC", "EUR"],
        "USDT": ["USD"],
        "XDG" : ["BTC"],
        "XLM" : ["BTC"],
        "XMR" : ["BTC", "EUR", "USD"],
        "XRP" : ["BTC", "EUR", "USD"],
        "ZEC" : ["BTC", "EUR", "USD"]
    ]

    static func FIATCurriences(crypto: Currency) -> [Currency] {
        let selected = fiat[crypto.stringValue]!
        return selected.map { Currency($0)! }
    }
}

fileprivate extension Pair {
///Create Pair from Kraken style pair
    init?(krakenPair: String) {
        switch krakenPair {
        case "BCHEUR": self.init("BCH:EUR")
        case "BCHUSD": self.init("BCH:USD")
        case "BCHXBT": self.init("BCH:BTC")
        case "DASHEUR": self.init("DASH:EUR")
        case "DASHUSD": self.init("DASH:USD")
        case "DASHXBT": self.init("DASH:BTC")
        case "EOSETH": self.init("EOS:ETH")
        case "EOSXBT": self.init("EOS:BTC")
        case "GNOETH": self.init("GNO:ETH")
        case "GNOXBT": self.init("GNO:BTC")
        case "USDTZUSD": self.init("USDT:USD")
        case "XETCXETH": self.init("ETC:ETH")
        case "XETCXXBT": self.init("ETC:BTC")
        case "XETCZEUR": self.init("ETC:EUR")
        case "XETCZUSD": self.init("ETC:USD")
        case "XETHXXBT": self.init("ETH:BTC")
        case "XETHZCAD": self.init("ETH:CAD")
        case "XETHZEUR": self.init("ETH:EUR")
        case "XETHZGBP": self.init("ETH:GBP")
        case "XETHZJPY": self.init("ETH:JPY")
        case "XETHZUSD": self.init("ETH:USD")
        case "XICNXETH": self.init("ICN:ETH")
        case "XICNXXBT": self.init("ICN:BTC")
        case "XLTCXXBT": self.init("LTC:BTC")
        case "XLTCZEUR": self.init("LTC:EUR")
        case "XLTCZUSD": self.init("LTC:USD")
        case "XMLNXETH": self.init("MLN:ETH")
        case "XMLNXXBT": self.init("MLN:BTC")
        case "XREPXETH": self.init("REP:ETH")
        case "XREPXXBT": self.init("REP:BTC")
        case "XREPZEUR": self.init("REP:EUR")
        case "XXBTZCAD": self.init("BTC:CAD")
        case "XXBTZEUR": self.init("BTC:EUR")
        case "XXBTZGBP": self.init("BTC:GBP")
        case "XXBTZJPY": self.init("BTC:JPY")
        case "XXBTZUSD": self.init("BTC:USD")
        case "XXDGXXBT": self.init("XDG:BTC")
        case "XXLMXXBT": self.init("XLM:BTC")
        case "XXMRXXBT": self.init("XMR:BTC")
        case "XXMRZEUR": self.init("XMR:EUR")
        case "XXMRZUSD": self.init("XMR:USD")
        case "XXRPXXBT": self.init("XRP:BTC")
        case "XXRPZEUR": self.init("XRP:EUR")
        case "XXRPZUSD": self.init("XRP:USD")
        case "XZECXXBT": self.init("ZEC:BTC")
        case "XZECZEUR": self.init("ZEC:EUR")
        case "XZECZUSD": self.init("ZEC:USD")
        default: fatalError("Invalid key \(krakenPair)")
        }
    }

    /// Converts Pair<ETH,USD> to "ETHUSD"
    var rawPairForAPI: String {
        switch (a.stringValue, b.stringValue) {
        case ("BCH", "EUR") : return "BCHEUR"
        case ("BCH", "USD") : return "BCHUSD"
        case ("BCH", "BTC") : return "BCHXBT"
        case ("DASH", "EUR"): return "DASHEUR"
        case ("DASH", "USD"): return "DASHUSD"
        case ("DASH", "BTC"): return "DASHXBT"
        case ("EOS", "ETH") : return "EOSETH"
        case ("EOS", "BTC") : return "EOSXBT"
        case ("GNO", "ETH") : return "GNOETH"
        case ("GNO", "BTC") : return "GNOXBT"
        case ("USDT", "USD"): return "USDTZUSD"
        case ("ETC", "ETH") : return "XETCXETH"
        case ("ETC", "BTC") : return "XETCXXBT"
        case ("ETC", "EUR") : return "XETCZEUR"
        case ("ETC", "USD") : return "XETCZUSD"
        case ("ETH", "BTC") : return "XETHXXBT"
        case ("ETH", "CAD") : return "XETHZCAD"
        case ("ETH", "EUR") : return "XETHZEUR"
        case ("ETH", "GBP") : return "XETHZGBP"
        case ("ETH", "JPY") : return "XETHZJPY"
        case ("ETH", "USD") : return "XETHZUSD"
        case ("ICN", "ETH") : return "XICNXETH"
        case ("ICN", "BTC") : return "XICNXXBT"
        case ("LTC", "BTC") : return "XLTCXXBT"
        case ("LTC", "EUR") : return "XLTCZEUR"
        case ("LTC", "USD") : return "XLTCZUSD"
        case ("MLN", "ETH") : return "XMLNXETH"
        case ("MLN", "BTC") : return "XMLNXXBT"
        case ("REP", "ETH") : return "XREPXETH"
        case ("REP", "BTC") : return "XREPXXBT"
        case ("REP", "EUR") : return "XREPZEUR"
        case ("BTC", "CAD") : return "XXBTZCAD"
        case ("BTC", "EUR") : return "XXBTZEUR"
        case ("BTC", "GBP") : return "XXBTZGBP"
        case ("BTC", "JPY") : return "XXBTZJPY"
        case ("BTC", "USD") : return "XXBTZUSD"
        case ("XDG", "BTC") : return "XXDGXXBT"
        case ("XLM", "BTC") : return "XXLMXXBT"
        case ("XMR", "BTC") : return "XXMRXXBT"
        case ("XMR", "EUR") : return "XXMRZEUR"
        case ("XMR", "USD") : return "XXMRZUSD"
        case ("XRP", "BTC") : return "XXRPXXBT"
        case ("XRP", "EUR") : return "XXRPZEUR"
        case ("XRP", "USD") : return "XXRPZUSD"
        case ("ZEC", "BTC") : return "XZECXXBT"
        case ("ZEC", "EUR") : return "XZECZEUR"
        case ("ZEC", "USD") : return "XZECZUSD"
        default: fatalError("Invalid pair \(self)")
        }
    }
}

