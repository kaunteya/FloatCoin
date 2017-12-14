//
//  ViewController.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

let pairs = ["BTC:USD", "ETH:USD", "BCH:USD", "DASH:USD", "ZEC:USD", "XRP:USD", "BTG:USD"]

class ViewController: NSViewController {
    @IBOutlet weak var pairsMenu: NSMenu!
    @IBOutlet var optionsMenu: NSMenu!
    @IBOutlet weak var buttonStack: NSStackView!
    @IBOutlet weak var mainLabel: NSTextField!
    var timer: Timer!
    var lastUpdateTime = Date()
    var thinView: Bool = false {
        didSet {
            let buttons = buttonStack.arrangedSubviews as! [CrButton]
            buttons.forEach{ $0.set(thinView: thinView) }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePairsMenu()

        pairs.forEach { pair in
            self.buttonStack.addArrangedSubview(CrButton(pair, thinView: thinView))
        }
        thinView = false 
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fetchCurrentValuesFromNetwork()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        (NSApp.delegate as! AppDelegate).window = self.view.window
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        timer.fire()
        self.view.window!.isMovableByWindowBackground = true
        self.view.window!.level = Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        buttonStack.heightAnchor.constraint(equalTo: buttonStack.arrangedSubviews.first!.heightAnchor).isActive = true
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        timer.invalidate()
    }

    @IBAction func actionClose(_ sender: NSButton) {
        self.view.window?.orderOut(sender)
    }
    
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
        let enable = sender.state == NSControlStateValueOn
        buttonStack.arrangedSubviews.filter { sender.title == ($0 as! CrButton).pair }.first!.isHidden = !enable
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
