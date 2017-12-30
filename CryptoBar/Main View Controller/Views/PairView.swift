//
//  PairView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 30/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class PairView: NSView {
    let pair: Pair
    private let basePriceLabel: NSTextField
    private var fiatPriceLabel: NSTextField
    var stackView: NSStackView!

    init(_ pair: Pair) {
        self.pair = pair
        basePriceLabel = NSTextField(
            labelWithAttributedString: pair.a.description
                .withTextColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
                .withFont(.systemFont(ofSize: 11))
        )
        basePriceLabel.setContentCompressionResistancePriority(999, for: .horizontal)
        basePriceLabel.setContentHuggingPriority(900, for: .horizontal)
        fiatPriceLabel = NSTextField(
            labelWithAttributedString: pair.b.stringValue
                .withTextColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
                .withFont(.systemFont(ofSize: 11))
        )
        fiatPriceLabel.setContentCompressionResistancePriority(999, for: .horizontal)
        fiatPriceLabel.setContentHuggingPriority(900, for: .horizontal)

        super.init(frame: NSZeroRect)
        self.wantsLayer = true

        //        self.layer?.backgroundColor = defaultBackgroundColor.cgColor
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = 2.0
        self.layer?.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        stackView = NSStackView(views: [basePriceLabel, fiatPriceLabel])
        stackView.orientation = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.setHuggingPriority(1000, for: .horizontal)
        stackView.setHuggingPriority(1000, for: .vertical)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: -5).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }

    func set(price: Double) {
        fiatPriceLabel = NSTextField(
            labelWithAttributedString: pair.b.stringValue
                .withTextColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
                .withFont(.systemFont(ofSize: 10))
        )
    }
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PairView: Comparable {
    static func <(lhs: PairView, rhs: PairView) -> Bool {
        return lhs.pair < rhs.pair
    }
}
