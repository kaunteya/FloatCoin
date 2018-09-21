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
    struct Main {
        static var borderColor: NSColor {
            return UserDefaults.isDarkMode ? #colorLiteral(red: 0.8100375533, green: 0.8100375533, blue: 0.8100375533, alpha: 1) : #colorLiteral(red: 0.6840139627, green: 0.6840139627, blue: 0.6840139627, alpha: 1)
        }
    }
    struct Exchange {
        static var title: NSColor {
            return UserDefaults.isDarkMode ? #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }

        static var backgroundHighlight: NSColor {
            return UserDefaults.isDarkMode ? #colorLiteral(red: 0.1366302849, green: 0.1691613051, blue: 0.1951861213, alpha: 1) : #colorLiteral(red: 0.9008859396, green: 0.9008859396, blue: 0.9008859396, alpha: 1)
        }
    }
}
