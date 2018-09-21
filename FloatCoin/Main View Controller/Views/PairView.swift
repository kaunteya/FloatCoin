//
//  PrView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 03/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit
class PairView: NSView {
    fileprivate var pair: Pair
    fileprivate var exchange: Exchange

    private var fiatPriceLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 999), for: .horizontal)
        label.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        return label
    }()

    private var basePriceLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 999), for: .horizontal)
        label.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        return label
    }()

    private lazy var optionsButton: NSButton = {
        let button = NSButton(image: #imageLiteral(resourceName: "Options"), target: self, action: #selector(showOptions(_:)))
        button.isHidden = true
        button.bezelStyle = .regularSquare
        button.isTransparent = true
        return button
    }()

    private var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.spacing = 5
        stackView.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        stackView.alignment = .centerY
        return stackView
    }()

    private var trackingArea: NSTrackingArea?
    private let menuItem = PairMenu()

    var price: Double? {
        didSet {
            guard price != nil else { fatalError() }
            let priceString = pair.b.formatted(price: price!)
            let textColor: NSColor
            if oldValue != nil {
                textColor = price! < oldValue! ? .systemRed : .systemGreen
            } else {
                textColor = .labelColor
            }
            fiatPriceLabel.stringValue = priceString + " "
            fiatPriceLabel.textColor = textColor
        }
    }

    init(pair: Pair, exchange: Exchange, fontSize: CGFloat) {
        self.pair = pair
        self.exchange = exchange

        super.init(frame: NSZeroRect)
        self.wantsLayer = true
        self.layer!.cornerRadius = 2
        self.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        self.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 999), for: .horizontal)

        stackView.addArrangedSubview(basePriceLabel)
        stackView.addArrangedSubview(fiatPriceLabel)
        self.addSubViewWithConstraints(stackView, top: 0, right: 0, bottom: 0, left: 0)

        self.addSubViewWithConstraints(optionsButton, right: 0, bottom: 0)

        basePriceLabel.stringValue = " " + pair.a.description
        basePriceLabel.font = NSFont.systemFont(ofSize: fontSize)
        fiatPriceLabel.font = NSFont.systemFont(ofSize: fontSize)
    }
    
    override func updateLayer() {
        self.layer!.backgroundColor = NSColor.textBackgroundColor.cgColor
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
