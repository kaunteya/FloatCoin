//
//  CloseButton.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 20/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class CloseButton: NSButton {
    private var trackingArea: NSTrackingArea?
    override func updateTrackingAreas() {
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }

        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea!)
    }

    override func mouseEntered(with event: NSEvent) {
        self.alphaValue = 1
    }

    override func mouseExited(with event: NSEvent) {
        self.alphaValue = 0.7
    }

}
