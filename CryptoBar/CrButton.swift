//
//  CrButton.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 11/11/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
import AppKit
import SwiftyAttributes

class CrButton: NSControl {
    let pair: String
    private let pairLabel: NSTextField
    private let priceLabel: NSTextField
    
    init(_ pair: String) {
        self.pair = pair
        pairLabel = NSTextField(labelWithAttributedString: pair.withTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).withFont(.systemFont(ofSize: 10)))
        pairLabel.maximumNumberOfLines = 1
        pairLabel.setContentCompressionResistancePriority(1000, for: .horizontal)
        priceLabel = NSTextField(labelWithAttributedString: "1234".withTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).withFont(.systemFont(ofSize: 10)))
        priceLabel.setContentCompressionResistancePriority(1000, for: .horizontal)
        super.init(frame: NSZeroRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        let stackView = NSStackView(views: [pairLabel, priceLabel])
        stackView.orientation = .vertical
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: -5).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    
    func set(price: Double) {
        let priceStr = String(format: "%.4f", price)
        priceLabel.attributedStringValue = "\(priceStr)".withTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).withFont(.systemFont(ofSize: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
