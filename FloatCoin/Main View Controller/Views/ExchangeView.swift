//
//  ExchangeView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 29/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class ExchangeView: NSView {
    let exchange: Exchange

    private var stackView: NSStackView!
    var fontSize: CGFloat {
        didSet {
            titleLabel.font = NSFont.systemFont(ofSize: fontSize)
            pairViews.forEach { $0.update(fontSize: fontSize)}
        }
    }

    let titleLabel = NSTextField(labelWithString: "")
    let pairStackView = NSStackView()

    var pairViews: [PairView] {
        return pairStackView.arrangedSubviews as! [PairView]
    }

    init(exchange: Exchange, pairList: [Pair], fontSize: CGFloat) {
        self.exchange = exchange
        self.fontSize = fontSize
        super.init(frame: NSZeroRect)
        createViews()
        self.wantsLayer = true

        titleLabel.stringValue = exchange.description
        titleLabel.font = NSFont.systemFont(ofSize: fontSize, weight: .medium)
        pairList.forEach { self.add(pair: $0) }
        updateColors()
    }

    private func createViews() {
        let placeHolder = NSView()
        let constraint = placeHolder.widthAnchor.constraint(equalToConstant: 0)
        constraint.priority = NSLayoutConstraint.Priority(rawValue: 100)
        constraint.isActive = true

        let mainStackView = NSStackView(views: [titleLabel, pairStackView, placeHolder])
        mainStackView.spacing = 2
        mainStackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 999), for: .vertical)
        mainStackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        self.updateConstraints()
        pairStackView.spacing = 4
        pairStackView.alignment = .centerY
        pairStackView.setHuggingPriority(NSLayoutConstraint.Priority(rawValue: 999), for: .horizontal)

        titleLabel.alignment = .right
        titleLabel.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 999), for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        self.addSubViewWithConstraints(mainStackView, top: 0, right: 0, bottom: 0, left: 0)
    }

    func add(pair: Pair) {
        let pairView = PairView(pair: pair, exchange: exchange, fontSize: fontSize)
        pairStackView.addSortedArrangedSubView(pairView)
        pairView.topAnchor.constraint(equalTo: pairStackView.topAnchor).isActive = true
        pairView.bottomAnchor.constraint(equalTo: pairStackView.bottomAnchor).isActive = true
    }

    func remove(_ pair: Pair) {
        pairViews[pair]!.removeFromSuperview()
        self.needsUpdateConstraints = true
    }

    func set(price: Double, of pair: Pair) {
        pairViews[pair]?.price = price
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var trackingArea: NSTrackingArea?
    override func updateTrackingAreas() {
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }

        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }

    override func mouseEntered(with event: NSEvent) {
        self.layer?.backgroundColor = Color.Exchange.backgroundHighlight.cgColor
    }

    override func mouseExited(with event: NSEvent) {
        titleLabel.textColor = Color.Exchange.title
        self.layer?.backgroundColor = nil
        self.layer?.borderWidth = 0
    }

}

extension ExchangeView: ColorResponder {
    func updateColors() {
        titleLabel.textColor = Color.Exchange.title
        pairViews.forEach { pair in
            pair.updateColors()
        }
    }
}

extension ExchangeView: Comparable {
    static func <(lhs: ExchangeView, rhs: ExchangeView) -> Bool {
        return lhs.exchange < rhs.exchange
    }
}

extension Array where Element: ExchangeView {
    subscript(exchange: Exchange) -> ExchangeView? {
        assert(self.filter { $0.exchange == exchange }.count <= 1)
        return self.filter { $0.exchange == exchange }.first
    }
}

