//
//  ViewController.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

@objc class MainViewController: NSViewController {

    @IBOutlet weak var actionButtonStack: NSStackView!
    let ratesController = RatesController()
    let pairsManager = PairsManager()
    lazy var emptyView = EmptyStateView()
    @objc dynamic var mouseInside = false

    @IBOutlet var optionsMenu: NSMenu!
    @IBOutlet weak var exchangeStackView: NSStackView!

    var exchangeViews: [ExchangeView] {
        return exchangeStackView.arrangedSubviews as! [ExchangeView]
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ratesController.delegate = self
        pairsManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadExchangePairs()
        addTracking()
        updateColors()
        self.view.layer?.borderWidth = 1
        self.view.layer?.cornerRadius = 4

        // addFontChangeListener
        UserDefaults.standard.addObserver(self, forKeyPath: UserDefaults.keyFontSize, options: .new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: UserDefaults.keyIsDark, options: .new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: UserDefaults.keyTranslucent, options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case UserDefaults.keyFontSize:
            let size = CGFloat(change![.newKey] as! Int)
            exchangeViews.forEach { $0.fontSize = size }

        case UserDefaults.keyIsDark: updateColors()
        case UserDefaults.keyTranslucent: updateColors()

        default: break

        }
    }

    func addTracking() {
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways, .inVisibleRect]
        let trackingArea = NSTrackingArea(rect: self.view.bounds, options: options, owner: self, userInfo: nil)
        self.view.addTrackingArea(trackingArea)
    }

    // If Exchange list is empty then dont track mouse movements
    override func mouseEntered(with event: NSEvent) {
        guard !UserDefaults.isExchangleListEmpty else { return; }
        mouseInside = true
    }

    override func mouseExited(with event: NSEvent) {
        guard !UserDefaults.isExchangleListEmpty else { return; }
        mouseInside = false
    }

    /// Create ExchangeViews and PairViews from UserDefaults
    private func loadExchangePairs() {
        guard let exchangePairs = UserDefaults.pairsForAllExchanges else {
            self.view.addSubViewWithConstraints(emptyView, top: 0, right: 0, bottom: 0, left: 0)
            mouseInside = true
            return
        }

        exchangePairs.keys.forEach { exchange in
            if let pairs:Set<Pair> = exchangePairs[exchange] {
                self.addNew(exchange: exchange, with: pairs.sorted())
            }
        }
    }

    func addNew(exchange: Exchange, with pairs: [Pair]) {
        let fontSize = UserDefaults.standard.integer(forKey: UserDefaults.keyFontSize)
        let exchangeView = ExchangeView(exchange: exchange, pairList: pairs.sorted(), fontSize: CGFloat(fontSize))
        self.exchangeStackView.addSortedArrangedSubView(exchangeView)
        exchangeView.leftAnchor.constraint(equalTo: exchangeView.superview!.leftAnchor).isActive = true
        exchangeView.rightAnchor.constraint(equalTo: exchangeView.superview!.rightAnchor).isActive = true

        exchangeViews.filter { $0.exchange != exchange }.forEach { ex in
            exchangeView.titleLabel.widthAnchor.constraint(equalTo: ex.titleLabel.widthAnchor, multiplier: 1).isActive = true
        }
    }

    @IBAction func actionClose(_ sender: NSButton) {
        self.view.window?.orderOut(sender)
    }

    @IBAction func actionFeedback(_ sender: NSMenuItem) {
        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScvKtF2xv-ZuPn4656nOjGFpoNih6nQ6647QzqshHhdG0Hp6g/viewform")!
        NSWorkspace.shared.open(url)
    }

    @IBAction func actionOptions(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: sender.frame.height)
        optionsMenu.popUp(positioning: nil, at: p, in: sender)
    }
}

extension MainViewController: PairManagerDelegate {
    func pair(added pair: Pair, to exchange: Exchange) {
        if let selectedExchange = exchangeViews[exchange] {
            selectedExchange.add(pair: pair)
        } else {
            self.addNew(exchange: exchange, with: [pair])
        }
        ratesController.fetchRate(exchange: exchange, pair: pair)
        emptyView.removeFromSuperview()
    }

    func pair(removed pair: Pair, from exchange: Exchange) {
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

extension MainViewController: ColorResponder {
    func updateColors() {
        self.view.layer?.borderColor = Color.Main.borderColor.cgColor
        let alpha: CGFloat = UserDefaults.isTranslucent ? 0.6 : 1.0
        self.view.layer?.backgroundColor = Color.Main.background.withAlphaComponent(alpha).cgColor

        exchangeViews.forEach { $0.updateColors() }
        actionButtonStack.arrangedSubviews.forEach { view in
            if let button = view as? NSButton {
                button.setTint(Color.App.buttonTint)
            }
        }
    }
}

extension MainViewController: RatesDelegate {
    func ratesUpdated(for exchange: Exchange, pair: Pair, price: Double) {
        DispatchQueue.main.async {
            if let list = self.exchangeStackView.arrangedSubviews as? [ExchangeView] {
                if let exchangeView = list.first(where: { $0.exchange == exchange }) {
                    exchangeView.set(price: price, of: pair)
                }
            }
        }
    }
}
