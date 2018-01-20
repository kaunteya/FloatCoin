//
//  ViewController.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

@objc class MainViewController: NSViewController {

    @IBOutlet weak var boxView: NSBox!
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
        // addFontChangeListener
        UserDefaults.standard.addObserver(self, forKeyPath: UserDefaults.keyFontSize, options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == UserDefaults.keyFontSize {
            let size = CGFloat(change![.newKey] as! Int)
            exchangeViews.forEach { $0.fontSize = size }
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

    @IBAction func actionOptions(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: sender.frame.height)
        updateDonateButton()
        optionsMenu.popUp(positioning: nil, at: p, in: sender)
    }

    private func updateDonateButton() {
        let days5 = 60 * 60 * 24 * 5.0
        let installDate = UserDefaults.installDate
        let after5Days = installDate.addingTimeInterval(Double(days5))
        let today = Date()
        if today >= after5Days {
            optionsMenu.item(withTitle: "Donate")?.isHidden = false
        }
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
        boxView.borderColor = Color.Main.borderColor
        boxView.fillColor = Color.Main.background
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
