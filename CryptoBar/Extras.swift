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
    func sortedInsertSubView<View: NSView>(newView: View) where View: Comparable {
        let index = (self.arrangedSubviews as! [View]).sortedInsertionIndex(newObj: newView)
        self.insertArrangedSubview(newView, at: index)
    }
}
