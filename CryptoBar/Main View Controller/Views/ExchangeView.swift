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
    var pairStackView: NSStackView!

    init(exchange: Exchange, pairList: [Pair]) {
        self.exchange = exchange
        titleLabel = NSTextField(
            labelWithAttributedString: exchange.description
                .withTextColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
                .withFont(.systemFont(ofSize: 12))
        )

        super.init(frame: NSZeroRect)
        let pairViewList = pairList.map{ PairView($0) }

        pairStackView = NSStackView(views:pairViewList)
        pairStackView.spacing = 4
        stackView = NSStackView(views: [titleLabel, pairStackView])
        stackView.orientation = .vertical
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.setHuggingPriority(1000, for: .horizontal)
        stackView.setHuggingPriority(1000, for: .vertical)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: -5).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }

    func add(newPair: Pair) {
        let pairView = PairView(newPair)
        pairStackView.sortedInsertSubView(newView: pairView)
    }

    func set(price: Double, of pair: Pair) {
        if let pairViewList = pairStackView.arrangedSubviews as? [PairView],
         let pairView = pairViewList.first(where: { $0.pair == pair}) {
            pairView.price = price
        }
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
