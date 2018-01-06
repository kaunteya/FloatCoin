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

extension Double {
    func format(precision: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        return formatter.string(from: NSNumber(value: self))
    }
}
