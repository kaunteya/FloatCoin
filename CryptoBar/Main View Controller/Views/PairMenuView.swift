//
//  PairMenuView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 01/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

protocol PairMenuDelegate {
    func pairActionDelete()
}

class PairMenu: NSMenu {
    var pairMenuDelegate: PairMenuDelegate?
    init() {
        super.init(title: "")
        let item = NSMenuItem(title: "Delete", action: #selector(delete), keyEquivalent: "")
        item.target = self
        self.addItem(item)
    }

    @objc func delete() {
        pairMenuDelegate?.pairActionDelete()
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
