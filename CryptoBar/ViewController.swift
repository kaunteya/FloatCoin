//
//  ViewController.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa
import DateToolsSwift

class ViewController: NSViewController {

    var timer: Timer!
    @IBOutlet weak var lastUpdateLabel: NSTextField!
    @IBOutlet weak var mainLabel: NSTextField!
    var lastUpdateTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func viewDidDisappear() {
        super.viewDidDisappear()
        timer.invalidate()
    }

    func fetchCurrentValuesFromNetwork() {
        HttpClient.getConversions(completion: { (json) in
            self.updateCurrienciesFor(json)
            self.lastUpdateTime = Date()
        }, failure: { (error) in
            DispatchQueue.main.async {
                self.mainLabel.stringValue = error.localizedDescription
            }
        })
    }

    func updateCurrienciesFor(_ json: JSONDictionary) {
        var mainString = ""
        let allCurrencies = json["data"] as! [JSONDictionary]
        for eachCurrency in allCurrencies {
            if let currency = Currency(json: eachCurrency) {
                mainString += "  [\(currency.name):\(currency.price)]"
            }
        }
        DispatchQueue.main.async {
            self.mainLabel.stringValue = mainString
        }
    }
}
