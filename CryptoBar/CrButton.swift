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

fileprivate let defaultBackgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

class CrButton: NSControl {
    let pair: String
    var currency: Currency? {
        didSet {
            guard currency != nil else { fatalError() }
            if let lastPrice = oldValue?.last {
                if lastPrice < currency!.last {
                    flickBackground(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
                } else if lastPrice > currency!.last {
                    flickBackground(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
                } else {
                    flickBackground(#colorLiteral(red: 0.9500998855, green: 0.943575263, blue: 0.9372867942, alpha: 0.5))
                }
            }
            
            let priceString = currency!.last.format(precision: 4)!
            priceLabel.attributedStringValue = priceString.withTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).withFont(.systemFont(ofSize: 10))
            self.toolTip = """
            Ask: \(currency!.ask)
            Bid: \(currency!.bid)
            High: \(currency!.high)
            Low: \(currency!.low)
            Timestamp: \(currency!.timestamp)
            Volume: \(currency!.volume)
            Volume30d: \(currency!.volume30d)
            """
        }
    }

    func flickBackground(_ color: Color) {
        self.layer?.backgroundColor = color.cgColor
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.layer?.backgroundColor = defaultBackgroundColor.cgColor
        }
    }
    private let pairLabel: NSTextField
    private let priceLabel: NSTextField
    var stackView: NSStackView!
    
    init(_ pair: String, thinView: Bool) {
        self.pair = pair
        pairLabel = NSTextField(labelWithAttributedString: pair.withTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).withFont(.boldSystemFont(ofSize: 11)))
        pairLabel.maximumNumberOfLines = 1
        pairLabel.setContentCompressionResistancePriority(999, for: .horizontal)
        pairLabel.setContentHuggingPriority(900, for: .horizontal)
        pairLabel.alignment = .center
        
        priceLabel = NSTextField(labelWithString: "")
        priceLabel.setContentCompressionResistancePriority(999, for: .horizontal)
        priceLabel.setContentHuggingPriority(900, for: .horizontal)
        priceLabel.alignment = .center
        
        super.init(frame: NSZeroRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = defaultBackgroundColor.cgColor
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = 3.0
        self.layer?.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        stackView = NSStackView(views: [pairLabel, priceLabel])
        stackView.orientation = .vertical
        set(thinView: thinView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.setHuggingPriority(1000, for: .horizontal)
        stackView.setHuggingPriority(1000, for: .vertical)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: -5).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    
    func set(thinView: Bool) {
        stackView.orientation = thinView ? .horizontal : .vertical
        stackView.spacing = thinView ? 1 : 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Double {
    func format(precision: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        return formatter.string(from: NSNumber(value: self))
    }
}
