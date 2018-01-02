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
    @IBOutlet weak var exchangeViewStack: NSStackView!

    let ratesController = RatesController()
    let pairsManager = PairsManager()
    lazy var emptyView = EmptyStateView()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ratesController.delegate = self
        pairsManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadExchangePairs()
    }

    /// Create ExchangeViews and PairViews from UserDefaults
    private func loadExchangePairs() {
        guard let exchangePairs = UserDefaults.pairsForAllExchanges else {
            self.view.addSubViewWithConstraints(emptyView, top: 0, right: 0, bottom: 0, left: 0)
            return
        }

        exchangePairs.keys.forEach { (exchange) in
            let pairList = exchangePairs[exchange].map { Array($0) } ?? [Pair]()
            let exchangeView = ExchangeView(exchange: exchange, pairList: pairList.sorted())
            self.exchangeViewStack.addArrangedSubview(exchangeView)
            exchangeView.leftAnchor.constraint(equalTo: exchangeView.superview!.leftAnchor).isActive = true
            exchangeView.rightAnchor.constraint(equalTo: exchangeView.superview!.rightAnchor).isActive = true
        }
    }
    
    @IBAction func actionClose(_ sender: NSButton) {
        self.view.window?.orderOut(sender)
    }

    @IBAction func actionOptions(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: sender.frame.height)
        optionsMenu.popUp(positioning: nil, at: p, in: sender)
    }
}

extension ViewController: PairManagerDelegate {
    func pair(added pair: Pair, to exchange: Exchange) {
        let exchangeViews = exchangeViewStack.arrangedSubviews as! [ExchangeView]

        // If exchange view available
        if let selectedExchange = exchangeViews[exchange] {
            selectedExchange.add(pair: pair)
        } else {
            // If exchange view NOT available, create one
            let exchangeView = ExchangeView(exchange: exchange, pairList: [pair])
            self.exchangeViewStack.addArrangedSubview(exchangeView)
        }
        ratesController.fetchRate(exchange: exchange, pair: pair)
        emptyView.removeFromSuperview()
    }

    func pair(removed pair: Pair, from exchange: Exchange) {
        let exchangeViews = exchangeViewStack.arrangedSubviews as! [ExchangeView]
        if let exchangeView = exchangeViews[exchange] {
            exchangeView.remove(pair)
            if exchangeView.pairViews.isEmpty {
                exchangeView.removeFromSuperview()
            }
        }
        if UserDefaults.isExchangleListEmpty {
            self.view.addSubViewWithConstraints(emptyView, top: 0, right: 0, bottom: 0, left: 0)
        }
    }
}

extension ViewController: RatesDelegate {
    func ratesUpdated(for exchange: Exchange, pair: Pair, price: Double) {
        DispatchQueue.main.async {
            if let list = self.exchangeViewStack.arrangedSubviews as? [ExchangeView] {
                if let exchangeView = list.first(where: { $0.exchange == exchange }) {
                    exchangeView.set(price: price, of: pair)
                }
            }
        }
    }
}
