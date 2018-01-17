//
//  Coinbase.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
struct Coinbase: ExchangeDelegate {
    static var name: Exchange = .coinbase

    static func urlRequest(for pairs: Set<Pair>) -> URLRequest {
        assert(pairs.count == 1, "Send Pairs one by one")
        let newPair = "\(pairs.first!.a.stringValue)-\(pairs.first!.b.stringValue)"
        var request = URLRequest(url: URL(string: "https://api.coinbase.com/v2/prices/\(newPair)/spot")!)
        request.setValue("2017-12-23", forHTTPHeaderField: "CB-VERSION")//Verify this
        return request
    }

    static func baseCryptoCurriencies() -> [Currency] {
        return ["BTC", "ETH", "BCH", "LTC"].map{ Currency($0)! }
    }
    
    static func FIATCurriences(crypto: Currency) -> [Currency] {
        return ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTC", "BTN", "BWP", "BYN", "BYR", "BZD", "CAD", "CDF", "CHF", "CLF", "CLP", "CNY", "COP", "CRC", "CUC", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EEK", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GGP", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "IMP", "INR", "IQD", "ISK", "JEP", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MTL", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "SSP", "STD", "SVC", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XAG", "XAU", "XCD", "XDR", "XOF", "XPD", "XPF", "XPT", "YER", "ZAR", "ZMK", "ZMW", "ZWL"].map { Currency($0)! }
    }
    
    static func fetchRate(_ pairs: Set<Pair>, completion: @escaping ([Pair : Double]) -> Void) {
        for pair in pairs {
            sendRequest(pair: pair, completion: completion)
        }
    }

    static func sendRequest(pair: Pair, completion: @escaping ([Pair : Double]) -> Void) {
        let urlRequest = self.urlRequest(for: [pair])
//        Log.info("Coinbase URL \(urlRequest)")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                Log.error("Error \(error!)")
                return;
            }
            guard data != nil else {
                Log.error("Data is nil"); return;
            }
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any] else {
                Log.error("JSON parsing error ")
                return;
            }
            let amount = Double((json["data"] as! [String: String])["amount"]!)!
            completion([pair:amount])
            }.resume()
    }

}
