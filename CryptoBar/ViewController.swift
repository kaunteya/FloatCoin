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
    @IBOutlet weak var pairsMenu: NSMenu!
    
    @IBOutlet weak var buttonStack: NSStackView!
    var timer: Timer!
    @IBOutlet weak var lastUpdateLabel: NSTextField!
    @IBOutlet weak var mainLabel: NSTextField!
    var lastUpdateTime = Date()
    var thinView: Bool = false {
        didSet {
            let buttons = buttonStack.arrangedSubviews as! [CrButton]
            buttons.forEach{ $0.set(thinView: thinView) }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pairs.forEach { pair in
            self.buttonStack.addArrangedSubview(CrButton(pair, thinView: thinView))
        }
        thinView = false 
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fetchCurrentValuesFromNetwork()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            var count = Int(Date().timeIntervalSince(self.lastUpdateTime))
            var unit = "seconds"
            if count > 60 { count = count % 60; unit = "minutes" }
            self.lastUpdateLabel.stringValue = "Updated \(count) \(unit) ago"
        }
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
        updatePairsMenu()
        buttonStack.heightAnchor.constraint(equalTo: buttonStack.arrangedSubviews.first!.heightAnchor).isActive = true
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        timer.invalidate()
    }

    @IBOutlet var optionsMenu: NSMenu!
    @IBAction func actionOptions(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: sender.frame.height)
        optionsMenu.popUp(positioning: nil, at: p, in: sender)
    }
    
    func updatePairsMenu() {
        for pair in pairs {
            let item = NSMenuItem(title: pair, action: #selector(pairClicked), keyEquivalent: "")
            item.target = self
            item.state = NSControlStateValueOn
            pairsMenu.addItem(item)
        }
    }
    
    func pairClicked(_ sender: NSMenuItem) {
        sender.state = sender.state == NSControlStateValueOn ? NSControlStateValueOff : NSControlStateValueOn
        let index = pairsMenu.index(of: sender)
        let enable = sender.state == NSControlStateValueOn
        if enable {
            self.buttonStack.insertArrangedSubview(CrButton(sender.title, thinView: thinView), at: index)
        } else {
            buttonStack.arrangedSubviews[index].removeFromSuperview()
        }
    }
    
    
    @IBAction func actionThinView(_ sender: NSMenuItem) {
        sender.state = sender.state == NSControlStateValueOn ? NSControlStateValueOff : NSControlStateValueOn
        thinView = sender.state == NSControlStateValueOn
    }

    func fetchCurrentValuesFromNetwork() {
        HttpClient.getConversions(completion: { (json) in
            self.updateCurrienciesFor(json)
            self.lastUpdateTime = Date()
        }, failure: { _ in })
    }

    func updateCurrienciesFor(_ json: JSONDictionary) {
        let allCurrencies = json["data"] as! [JSONDictionary]
        var dict = [String: Currency]()
        for eachCurrency in allCurrencies {
            if let currency = Currency(json: eachCurrency) {
                dict[currency.pair] = currency
            }
        }
        DispatchQueue.main.async {
            for button in self.buttonStack.arrangedSubviews as! [CrButton] {
                button.currency = dict[button.pair]!
            }
        }
    }
}
