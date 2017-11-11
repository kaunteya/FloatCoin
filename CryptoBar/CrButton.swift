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
    var thinView: Bool = false {
        didSet {
            stackView.orientation = thinView ? .horizontal : .vertical
            stackView.spacing = thinView ? 1 : 0
        }
    }
    let pair: String
    var currency: Currency? {
        didSet {
            guard currency != nil else { fatalError() }
            
            if oldValue != nil && oldValue!.last < currency!.last {
                flickBackground(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
            } else if oldValue != nil && oldValue!.last < currency!.last {
                flickBackground(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
            }
            
            let priceString = currency!.last.format(precision: 4)!
            priceLabel.attributedStringValue = priceString.withTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).withFont(.systemFont(ofSize: 9))
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

    func flickBackground(color: Color) {
        self.layer?.backgroundColor = color.cgColor
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.layer?.backgroundColor = defaultBackgroundColor.cgColor
        }
    }
    private let pairLabel: NSTextField
    private let priceLabel: NSTextField
    var stackView: NSStackView!
    
    init(_ pair: String) {
        self.pair = pair
        pairLabel = NSTextField(labelWithAttributedString: pair.withTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).withFont(.boldSystemFont(ofSize: 10)))
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.setHuggingPriority(1000, for: .horizontal)
        stackView.setHuggingPriority(1000, for: .vertical)
        self.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: -5).isActive = true
        self.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
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
