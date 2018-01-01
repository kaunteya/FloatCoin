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
    private var pairStackView: NSStackView!

    var selectedPairs: [Pair] {
        let pairViews = pairStackView.arrangedSubviews as! [PairView]
        return pairViews.filter { $0.state == NSControl.StateValue.on}.map { $0.pair}
    }

    var pairViews: [PairView] {
        return pairStackView.arrangedSubviews as! [PairView]
    }

    init(exchange: Exchange, pairList: [Pair]) {
        self.exchange = exchange
        titleLabel = NSTextField(
            labelWithAttributedString: ("    " + exchange.description)
                .withTextColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
                .withFont(.systemFont(ofSize: 12))
        )

        super.init(frame: NSZeroRect)

        let pairViewList = pairList.map{ PairView(pair: $0, exchange: exchange) }

        pairStackView = NSStackView(views:pairViewList)
        pairStackView.spacing = 2
        stackView = NSStackView(views: [titleLabel, pairStackView])
        stackView.orientation = .vertical
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

    func add(_ newPair: Pair) {
        let pairView = PairView(pair: newPair, exchange: exchange)
        pairStackView.sortedInsertSubView(newView: pairView)
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

