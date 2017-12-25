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
    var lastUpdateTime = Date()
    var ratesFetcher: RatesFetcher

    var thinView: Bool = false { //TODO: isThinView
        didSet {
            let buttons = buttonStack.arrangedSubviews as! [CrButton]
            buttons.forEach{ $0.set(thinView: thinView) }
        }
    }

    required init?(coder: NSCoder) {
        ratesFetcher = RatesFetcher()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ratesFetcher.userExchangePairList.forEach { exchangePair in
            let aButton = CrButton(exchangePair: exchangePair, thinView: thinView)
            self.buttonStack.addArrangedSubview(aButton)
        }
        ratesFetcher.delegate = self
        thinView = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        (NSApp.delegate as! AppDelegate).window = self.view.window
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window!.isMovableByWindowBackground = true
        self.view.window!.level = Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        ratesFetcher.start()
        buttonStack.heightAnchor.constraint(equalTo: buttonStack.arrangedSubviews.first!.heightAnchor).isActive = true
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        ratesFetcher.stop()
    }

    @IBAction func actionClose(_ sender: NSButton) {
        self.view.window?.orderOut(sender)
    }
    
    @IBAction func actionOptions(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: sender.frame.height)
        optionsMenu.popUp(positioning: nil, at: p, in: sender)
    }
    
    @IBAction func actionThinView(_ sender: NSMenuItem) {
        sender.state = sender.state == NSControlStateValueOn ? NSControlStateValueOff : NSControlStateValueOn
        thinView = sender.state == NSControlStateValueOn
    }
}

extension ViewController: RatesDelegate {
    func ratesUpdated(for exchangePair: UserExchangePair, price: Double) {
        DispatchQueue.main.async {
            for button in self.buttonStack.arrangedSubviews as! [CrButton]
                where button.exchangePair == exchangePair {
                    button.price = price
            }
        }
    }
}
