//
//  PrView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 03/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit
class PairView: NSView {
    var pair: Pair
    var exchange: Exchange

    let fiatPriceLabel = NSTextField(labelWithString: "")
    let basePriceLabel = NSTextField(labelWithString: "")
    var optionsButton = NSButton()

    private var trackingArea: NSTrackingArea?
    private let menuItem = PairMenu()


    var price: Double? {
        didSet {
            guard price != nil else { fatalError() }
            let priceString = pair.b.formatted(price: price!)
            let textColor: NSColor
            if oldValue != nil {
                textColor = price! < oldValue! ? Color.Pair.Price.down : Color.Pair.Price.up
            } else {
                textColor = Color.Pair.Price.default
            }
            fiatPriceLabel.stringValue = priceString
            fiatPriceLabel.textColor = textColor
        }
    }

    init(pair: Pair, exchange: Exchange, fontSize: CGFloat) {
        self.pair = pair
        self.exchange = exchange
        super.init(frame: NSZeroRect)
        self.wantsLayer = true
        createViews()
        basePriceLabel.stringValue = " " + pair.a.description
        basePriceLabel.font = NSFont.systemFont(ofSize: fontSize)
        fiatPriceLabel.font = NSFont.systemFont(ofSize: fontSize)
        updateColors()
    }

    func createViews() {
        let stackView = NSStackView()
        stackView.spacing = 5
        stackView.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.addArrangedSubview(basePriceLabel)
        stackView.addArrangedSubview(fiatPriceLabel)
        self.addSubViewWithConstraints(stackView, top: 0, right: 0, bottom: 0, left: 0)

        optionsButton = NSButton(image: #imageLiteral(resourceName: "Options"), target: self, action: #selector(showOptions(_:)))
        optionsButton.bezelStyle = .regularSquare
        optionsButton.isTransparent = true
        self.addSubViewWithConstraints(optionsButton, right: 0, bottom: 0)
    }

    func update(fontSize: CGFloat) {
        basePriceLabel.font = NSFont.systemFont(ofSize: fontSize)
        fiatPriceLabel.font = NSFont.systemFont(ofSize: fontSize)
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

    @IBAction func showOptions(_ sender: NSButton) {
        menuItem.pairMenuDelegate = self

        let point = NSPoint(x: 0, y: self.frame.height)
        menuItem.popUp(positioning: nil, at: point, in: sender)
    }

    required init?(coder decoder: NSCoder) {
        fatalError()
    }

}

extension PairView: ColorResponder {
    func updateColors() {
        basePriceLabel.textColor = Color.Pair.baseLabel
        self.layer!.backgroundColor = Color.Pair.background.cgColor
    }
}

extension PairView: PairMenuDelegate {
    func pairActionDelete() {
        Log.info("Delete \(pair)")
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
