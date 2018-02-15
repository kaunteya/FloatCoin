//
//  Extras.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 27/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

extension Array where Element: Comparable {
    func sortedInsertionIndex(newObj: Element) -> Index {
        for (index, obj) in enumerated() where newObj < obj {
            return index
        }
        return count
    }
}

extension NSStackView {
    func addSortedArrangedSubView<View: NSView>(_ newView: View) where View: Comparable {
        let index = (self.arrangedSubviews as! [View]).sortedInsertionIndex(newObj: newView)
        self.insertArrangedSubview(newView, at: index)
    }
}

extension NSView {
    func addSubViewWithConstraints(_ view: NSView, top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil, height: CGFloat? = nil, width: CGFloat? = nil) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left).isActive = true
        }
        if let height = height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width  {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}

extension UserDefaults {
    func setOnce(_ value: Any?, forKey defaultName: String) {
        guard UserDefaults.standard.object(forKey: defaultName) == nil else {
            return
        }
        UserDefaults.standard.set(value, forKey: defaultName)
    }
}

extension NSButton {
    func setTint(_ color: NSColor) {
        self.image = self.image!.tinted(color)
    }
}

extension NSImage {
    /// Returns copy of image with tint applied
    func tinted(_ color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()
        color.set()
        let rect = NSRect(origin: .zero, size: image.size)
        rect.fill(using: .sourceAtop)
        image.unlockFocus()
        return image
    }
}

extension Double {
    var fixedWidth: String {
        let formatter = NumberFormatter()
        if self >= 1000 {
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
        } else if self >= 100 { // 100-999
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
        } else if self >= 10 { // 10-99
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        } else if self >= 1 { // 1-9
            formatter.minimumFractionDigits = 3
            formatter.maximumFractionDigits = 3
        } else if self >= 0.0001 {
            formatter.minimumFractionDigits = 5
            formatter.maximumFractionDigits = 5
        }
        return formatter.string(from: NSNumber(value: self))!
    }
}
