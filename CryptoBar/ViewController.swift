//
//  ViewController.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var timer: Timer!
    @IBOutlet weak var mainLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    @IBAction func actionClose(_ sender: Any) {

    }

    func timerAction() {
        fetchCurrentValuesFromNetwork()
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
