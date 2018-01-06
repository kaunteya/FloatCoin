//
//  PrView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 03/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit
class PairView: KSView {
    var pair: Pair
    var exchange: Exchange

    @IBOutlet var contentView: NSView!
    @IBOutlet weak var fiatPriceLabel: NSTextField!
    @IBOutlet weak var basePriceLabel: NSTextField!
    @IBOutlet weak var optionsButton: NSButton!
    private var trackingArea: NSTrackingArea?
    private let menuItem = PairMenu()


    var price: Double? {
        didSet {
            guard price != nil else { fatalError() }
            let priceString = "\(pair.b.symbol)\(price!.fixedWidth) "
            let color: NSColor
            if oldValue != nil {
                color = price! < oldValue! ? #colorLiteral(red: 1, green: 0.34383979, blue: 0.136546772, alpha: 1) : #colorLiteral(red: 0.1420414355, green: 0.9820115771, blue: 0.1467524558, alpha: 1)
            } else {
                color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            fiatPriceLabel.attributedStringValue = priceString.withTextColor(color).withFont(.systemFont(ofSize: 10))
        }
    }

    init(pair: Pair, exchange: Exchange) {
        self.pair = pair
        self.exchange = exchange
        super.init(frame: NSZeroRect)
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PairView"), owner: self, topLevelObjects: nil)
        self.addSubViewWithConstraints(contentView, top: 0, right: 0, bottom: 0, left: 0)
        basePriceLabel.stringValue = " " + pair.a.description
    }

    override func updateTrackingAreas() {
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }

        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        optionsButton.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        optionsButton.isHidden = true
    }

    @IBAction func showOptions(_ sender: Any) {
        menuItem.pairMenuDelegate = self

        let point = NSPoint(x: 0, y: self.frame.height)
        menuItem.popUp(positioning: nil, at: point, in: self)
    }

    required init?(coder decoder: NSCoder) {
        fatalError()
    }

}

extension PairView: PairMenuDelegate {
    func pairActionDelete() {
        log.info("Delete \(pair)")
        UserDefaults.remove(exchange: exchange, pair: pair)
    }
}

extension Array where Element: PairView {
    subscript(pair: Pair) -> PairView? {
        assert(self.filter { $0.pair == pair }.count <= 1)
        return self.filter { $0.pair == pair }.first
    }
}

extension PairView: Comparable {
    static func <(lhs: PairView, rhs: PairView) -> Bool {
        return lhs.pair < rhs.pair
    }
}
