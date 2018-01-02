//  PairView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 30/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class PairView: NSButton {
    let pair: Pair
    let exchange: Exchange
    private let basePriceLabel: NSTextField
    private var fiatPriceLabel: NSTextField
    private var optionsButton: NSButton!
    var stackView: NSStackView!
    private let defaultBackgroundColor = #colorLiteral(red: 0.2482073307, green: 0.2482073307, blue: 0.2482073307, alpha: 1)
    private var trackingArea: NSTrackingArea?
    private let menuItem = PairMenu()

    var price: Double? {
        didSet {
            guard price != nil else { fatalError() }
            let priceString = "\(pair.b.symbol) \(price!.format(precision: 4)!) "
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
        basePriceLabel = NSTextField(
            labelWithAttributedString: (" " + pair.a.description)
                .withTextColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                .withFont(.systemFont(ofSize: 10))
        )
        basePriceLabel.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 999), for: .horizontal)
        basePriceLabel.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .vertical)
        basePriceLabel.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)

        fiatPriceLabel = NSTextField(
            labelWithAttributedString: ""
                .withTextColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
                .withFont(.systemFont(ofSize: 10))
        )
        fiatPriceLabel.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 999), for: .horizontal)
        fiatPriceLabel.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 900), for: .vertical)
        fiatPriceLabel.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 900), for: .horizontal)


        super.init(frame: NSZeroRect)
        self.setButtonType(.toggle)
        self.title = ""
        self.isBordered = false
        self.target = self
        self.wantsLayer = true
        self.layer?.cornerRadius = 2.0
        self.layer?.borderColor = #colorLiteral(red: 0.5786551237, green: 0.5786551237, blue: 0.5786551237, alpha: 1)
        self.layer?.backgroundColor = defaultBackgroundColor.cgColor

        stackView = NSStackView(views: [basePriceLabel, fiatPriceLabel])
        stackView.orientation = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .vertical)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true

        optionsButton = NSButton(image: #imageLiteral(resourceName: "Options"), target: self, action: #selector(showOptions))
        optionsButton.bezelStyle = .regularSquare
        optionsButton.isBordered = false
        optionsButton.isHidden = true
        self.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        optionsButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive  = true
    }

    @objc func showOptions() {
        menuItem.pairMenuDelegate = self

        let point = NSPoint(x: 0, y: self.frame.height)
        menuItem.popUp(positioning: nil, at: point, in: self)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
