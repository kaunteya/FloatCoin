//
//  ExchangeView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 29/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit
import SwiftyAttributes

class ExchangeView: NSView {
    let exchange: Exchange

    private let titleLabel: NSTextField
    private var stackView: NSStackView!
    private let pairStackView = NSStackView()

    var selectedPairs: [Pair] {
        let pairViews = pairStackView.arrangedSubviews as! [PairView]
        return pairViews.filter { $0.state == .on}.map { $0.pair}
    }

    var pairViews: [PairView] {
        return pairStackView.arrangedSubviews as! [PairView]
    }

    init(exchange: Exchange, pairList: [Pair]) {
        self.exchange = exchange
        titleLabel = NSTextField(
            labelWithAttributedString: ("    " + exchange.description)
                .withTextColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7165492958))
                .withFont(.systemFont(ofSize: 11))
        )
        titleLabel.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 900), for: .horizontal)
        titleLabel.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 900), for: .vertical)

        super.init(frame: NSZeroRect)

        pairList.forEach { self.add(pair: $0) }

        pairStackView.spacing = 2
        stackView = NSStackView(views: [titleLabel, pairStackView])
        pairStackView.setContentHuggingPriority(NSLayoutConstraint.Priority(1000), for: .horizontal)
        pairStackView.setContentHuggingPriority(NSLayoutConstraint.Priority(1000), for: .vertical)
        stackView.orientation = .vertical
        stackView.alignment = .left
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        stackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .vertical)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: -5).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }

    func add(pair: Pair) {
        let pairView = PairView(pair: pair, exchange: exchange)
        pairStackView.sortedInsertSubView(newView: pairView)
        pairView.topAnchor.constraint(equalTo: pairStackView.topAnchor).isActive = true
        pairView.bottomAnchor.constraint(equalTo: pairStackView.bottomAnchor).isActive = true
    }

    func remove(_ pair: Pair) {
        let pairViews = pairStackView.arrangedSubviews as! [PairView]
        pairViews[pair]!.removeFromSuperview()
    }

    func set(price: Double, of pair: Pair) {
        let pairViewList = pairStackView.arrangedSubviews as! [PairView]
        pairViewList[pair]?.price = price
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Array where Element: ExchangeView {
    subscript(exchange: Exchange) -> ExchangeView? {
        assert(self.filter { $0.exchange == exchange }.count <= 1)
        return self.filter { $0.exchange == exchange }.first
    }
}

