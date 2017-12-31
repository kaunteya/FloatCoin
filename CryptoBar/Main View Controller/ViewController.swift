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

    // Deals with adding and deleting pairs
    let pairsManager = PairsManager()
    var thinView: Bool = false { //TODO: isThinView
        didSet {
//            let buttons = buttonStack.arrangedSubviews as! [CrButton]
//            buttons.forEach{ $0.set(thinView: thinView) }
        }
    }

    required init?(coder: NSCoder) {
        ratesController = RatesController()
        super.init(coder: coder)
        ratesController.delegate = self
        pairsManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        log.error("Started")
        Swift.print("Hello")
        ratesController.startTimer()
        loadExchangePairs()
    }

    private func loadExchangePairs() {

        guard let exchangePair = UserDefaults.pairsForAllExchanges else {
            //For no pairs show a view to that will have a add button in it.
            return
        }

        exchangePair.keys.forEach { (exchange) in
            let pairList = exchangePair[exchange].map { Array($0) } ?? [Pair]()
            let exchangeView = ExchangeView(exchange: exchange, pairList: pairList.sorted())
            self.buttonStack.addArrangedSubview(exchangeView)
        }
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

    @IBAction func actionDelete(_ sender: NSButton) {
        log.info("Delete selected pairs..")
        let exchangeViews = buttonStack.arrangedSubviews as! [ExchangeView]
        exchangeViews.forEach { view in
            view.selectedPairs.forEach({ pair in
                log.info("Delete \(view.exchange.description) \(pair.joined(":"))")
                UserDefaults.remove(exchange: view.exchange, pair: pair)
            })
        }
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

extension ViewController: PairManagerDelegate {
    func pair(added pair: Pair, to exchange: Exchange) {
        let exchangeViews = buttonStack.arrangedSubviews as! [ExchangeView]
        let filteredExchange = exchangeViews.filter { $0.exchange == exchange }

        // If exchange available
        if let selectedExchange = filteredExchange.first {
            selectedExchange.add(pair)
        } else {
            // If exchange NOT available
            let exchangeView = ExchangeView(exchange: exchange, pairList: [pair])
            self.buttonStack.addArrangedSubview(exchangeView)
        }
    }

    func pair(removed pair: Pair, from exchange: Exchange) {
        let exchangeViews = buttonStack.arrangedSubviews as! [ExchangeView]
        if let exchangeView = exchangeViews[exchange] {
            exchangeView.remove(pair)
            if exchangeView.pairViews.isEmpty {
                exchangeView.removeFromSuperview()
            }
        }
    }
}

extension ViewController: RatesDelegate {
    func ratesUpdated(for exchange: Exchange, pair: Pair, price: Double) {
        DispatchQueue.main.async {
            if let list = self.buttonStack.arrangedSubviews as? [ExchangeView] {
                if let exchangeView = list.first(where: { $0.exchange == exchange }) {
                    exchangeView.set(price: price, of: pair)
                }
            }
        }
    }
}
