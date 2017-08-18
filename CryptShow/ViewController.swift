//
//  ViewController.swift
//  CryptShow
//
//  Created by Kaunteya Suryawanshi on 18/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    let showPairs = ["BTC:USD", "BCH:USD", "ETH:USD"]
    override func viewDidLoad() {
        super.viewDidLoad()

        HttpClient.getConversions { json in

            var mainString = ""
            let allCurrency = json["data"] as! [JSONDictionary]
            for iCurrency in allCurrency {
                if let currency = Currency(iCurrency) {
                    mainString += " [\(currency.name):\(currency.price)]"
                }
            }
            self.view.window?.title = mainString
        }
    }


}

