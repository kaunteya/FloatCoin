//
//  ViewController.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

let pairs = ["BTC:USD", "ETH:USD", "BCH:USD", "DASH:USD"]//, "BCH:USD"]

class ViewController: NSViewController {

    @IBOutlet weak var buttonStack: NSStackView!
    var timer: Timer!
    @IBOutlet weak var lastUpdateLabel: NSTextField!
    @IBOutlet weak var mainLabel: NSTextField!
    var lastUpdateTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairs.forEach { pair in
            self.buttonStack.addArrangedSubview(CrButton(pair))
        }
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fetchCurrentValuesFromNetwork()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            var count = Int(Date().timeIntervalSince(self.lastUpdateTime))
            var unit = "seconds"
            if count > 60 {
                count = count % 60
                unit = "minutes"
            }
            self.lastUpdateLabel.stringValue = "Updated \(count) \(unit) ago"
        }
    }

    @IBAction func actionClose(_ sender: Any) {

    }

    override func viewWillAppear() {
        super.viewWillAppear()
        Swift.print("View appeared")
        timer.fire()
        self.view.window!.isMovableByWindowBackground = true
        self.view.window!.level = Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        let height1 = buttonStack.arrangedSubviews.first!.frame.height
        buttonStack.heightAnchor.constraint(equalToConstant: height1).isActive = true
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        timer.invalidate()
    }

    func fetchCurrentValuesFromNetwork() {
        HttpClient.getConversions(completion: { (json) in
            self.updateCurrienciesFor(json)
            self.lastUpdateTime = Date()
        }, failure: { _ in  })
    }

    func updateCurrienciesFor(_ json: JSONDictionary) {
        let allCurrencies = json["data"] as! [JSONDictionary]
        var dict = [String: Double]()
        for eachCurrency in allCurrencies {
            if let currency = Currency(json: eachCurrency) {
                dict[currency.pair] = currency.price
            }
        }
        DispatchQueue.main.async {
            for button in self.buttonStack.arrangedSubviews as! [CrButton] {
                button.price = dict[button.pair]!
            }
        }
    }
}
