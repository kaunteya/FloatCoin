//
//  PairView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 30/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class PairView: NSButton {
    let pair: Pair
    private let basePriceLabel: NSTextField
    private var fiatPriceLabel: NSTextField
    private var deleteButton: NSButton!
    var stackView: NSStackView!

    private var trackingArea: NSTrackingArea?

    var price: Double? {
        didSet {
            guard price != nil else { fatalError() }
            let priceString = "\(pair.b.symbol) \(price!.format(precision: 4)!) "
            let color: NSColor
            if oldValue != nil {
                color = price! < oldValue! ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else {
                color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            fiatPriceLabel.attributedStringValue = priceString.withTextColor(color).withFont(.systemFont(ofSize: 10))
        }
    }

    init(_ pair: Pair) {
        self.pair = pair
        basePriceLabel = NSTextField(
            labelWithAttributedString: (" " + pair.a.description)
                .withTextColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                .withFont(.systemFont(ofSize: 10))
        )
        basePriceLabel.setContentCompressionResistancePriority(999, for: .horizontal)
        basePriceLabel.setContentHuggingPriority(900, for: .horizontal)

        fiatPriceLabel = NSTextField(
            labelWithAttributedString: ""
                .withTextColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
                .withFont(.systemFont(ofSize: 10))
        )
        fiatPriceLabel.setContentCompressionResistancePriority(999, for: .horizontal)
        fiatPriceLabel.setContentHuggingPriority(900, for: .horizontal)


        super.init(frame: NSZeroRect)
        self.setButtonType(.toggle)
        self.title = ""
        self.isBordered = false
        self.target = self
        self.action = #selector(buttonPressed)
        self.wantsLayer = true
        self.layer?.cornerRadius = 2.0
        self.layer?.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        stackView = NSStackView(views: [basePriceLabel, fiatPriceLabel])
        stackView.orientation = .horizontal
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.setHuggingPriority(1000, for: .horizontal)
        stackView.setHuggingPriority(1000, for: .vertical)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true

    }

    func buttonPressed() {
        log.error("Button \(pair) pressed \(self.state)")
        self.layer?.backgroundColor = state == NSOnState ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : nil
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateTrackingAreas() {
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }

        let options: NSTrackingAreaOptions = [.mouseEnteredAndExited, .activeAlways]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }

    override func mouseEntered(with event: NSEvent) {
        self.layer?.borderWidth = 1
    }

    override func mouseExited(with event: NSEvent) {
        self.layer?.borderWidth = 0
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
