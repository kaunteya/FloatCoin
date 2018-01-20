//
//  Color.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 20/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//
import Foundation
import AppKit

protocol ColorResponder {
    func updateColors()
}

struct Color {
//    enum Mode { case dark, light }
    struct Main {
        static var background: NSColor = #colorLiteral(red: 0.08235294118, green: 0.1019607843, blue: 0.1176470588, alpha: 1)
    }
    struct Exchange {
        static var title: NSColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    struct Pair {
        static var baseLabel: NSColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        static var background: NSColor = #colorLiteral(red: 0.231372549, green: 0.2784313725, blue: 0.3215686275, alpha: 1)
        struct Price {
            static var down: NSColor = #colorLiteral(red: 1, green: 0, blue: 0.4784313725, alpha: 1)
            static var up: NSColor = #colorLiteral(red: 0.5568627451, green: 0.7882352941, blue: 0.09803921569, alpha: 1)
            static var `default`: NSColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}
