//
//  HttpClient.swift
//  CryptShow
//
//  Created by Kaunteya Suryawanshi on 18/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

typealias JSON           = Any
typealias JSONArray      = [JSON]
typealias JSONDictionary = [String : JSON]

struct HttpClient {
    static let url = URL(string: "https://cex.io/api/tickers/USD")!
    static func getConversions(completion: @escaping (JSONDictionary) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                NSLog(error!.localizedDescription)
                return
            }
            guard data != nil else { NSLog("Data is nil"); return }
            data.map { data in
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                json.map { json in
                    completion(json as! JSONDictionary)
                }
            }
        }.resume()
    }
}
