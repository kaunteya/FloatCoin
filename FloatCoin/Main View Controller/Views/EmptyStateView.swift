//
//  EmptyStateView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 02/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class EmptyStateView: NSView {
    @IBOutlet var contentView: NSView!

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        myInit()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        myInit()
    }

    func myInit() {
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "EmptyState"), owner: self, topLevelObjects: nil)
        self.addSubViewWithConstraints(contentView, top: 2, right: 2, bottom: 2, left: 2)
    }
}
