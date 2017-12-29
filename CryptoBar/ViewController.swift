//
//  ViewController.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var optionsMenu: NSMenu!
    @IBOutlet weak var buttonStack: NSStackView!

    var ratesController: RatesController

    var thinView: Bool = false { //TODO: isThinView
        didSet {
            let buttons = buttonStack.arrangedSubviews as! [CrButton]
            buttons.forEach{ $0.set(thinView: thinView) }
        }
    }

    required init?(coder: NSCoder) {
        UserDefaults.addDefaultCurrencies()
        ratesController = RatesController()
        super.init(coder: coder)
        ratesController.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ratesController.startTimer()
        RatesController.userExchangePairList.forEach { exchangePair in
            let aButton = CrButton(exchangePair: exchangePair, thinView: thinView)
            self.buttonStack.addArrangedSubview(aButton)
        }
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
        buttonStack.heightAnchor.constraint(equalTo: buttonStack.arrangedSubviews.first!.heightAnchor).isActive = true
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
    func pairAdded(userPair: UserExchangePair) {
        let aButton = CrButton(exchangePair: userPair, thinView: thinView)
        self.buttonStack.addArrangedSubview(aButton)
    }

    func pairsRemoved(at indexSet: IndexSet) {
        indexSet.sorted {$0 > $1}.forEach {
            self.buttonStack.arrangedSubviews[$0].removeFromSuperview()
        }
    }

    func ratesUpdated(for exchangePair: UserExchangePair, price: Double) {
        DispatchQueue.main.async {
            for button in self.buttonStack.arrangedSubviews as! [CrButton]
                where button.exchangePair == exchangePair {
                    button.price = price
            }
        }
    }
}
