//
//  MainView.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 21/09/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

class MainView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let alpha: CGFloat = UserDefaults.isTranslucent ? 0.6 : 1.0
        self.layer!.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(alpha).cgColor
        self.layer!.borderColor = NSColor.gridColor.cgColor
    }
}
