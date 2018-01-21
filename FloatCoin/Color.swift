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
        static var background: NSColor {
            return UserDefaults.isDarkMode ? #colorLiteral(red: 0.08235294118, green: 0.1019607843, blue: 0.1176470588, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
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
    struct Pair {
        static var baseLabel: NSColor {
            return UserDefaults.isDarkMode ? #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }

        static var background: NSColor {
            return UserDefaults.isDarkMode ? #colorLiteral(red: 0.231372549, green: 0.2784313725, blue: 0.3215686275, alpha: 1) : #colorLiteral(red: 0.8078431373, green: 0.8078431373, blue: 0.8078431373, alpha: 1)
        }

        struct Price {
            static var down: NSColor {
                return UserDefaults.isDarkMode ? #colorLiteral(red: 1, green: 0, blue: 0.4784313725, alpha: 1) : #colorLiteral(red: 1, green: 0.137254902, blue: 0.4392156863, alpha: 1)
            }
            static var up: NSColor {
                return UserDefaults.isDarkMode ? #colorLiteral(red: 0.5568627451, green: 0.7882352941, blue: 0.09803921569, alpha: 1) : #colorLiteral(red: 0, green: 0.4392156863, blue: 0.1529411765, alpha: 1)
            }
            static var `default`: NSColor {
                return UserDefaults.isDarkMode ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
}
