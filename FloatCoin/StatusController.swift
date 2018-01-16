//
//  StatusController.swift
//  ChairTimer
//
//  Created by Kaunteya Suryawanshi on 05/10/17.
//  Copyright © 2017 kaunteya. All rights reserved.
//

import AppKit

class StatusController: NSObject {

    static let statusBarThickness = NSStatusBar.system.thickness
    let statusItem = NSStatusBar.system.statusItem(withLength: -1)
    let onClick: (NSStatusItem) -> Void

    init(statusImage: NSImage, isTemplate: Bool, clickHandler: @escaping (_ statusItem: NSStatusItem) -> Void) {
        self.onClick = clickHandler
        super.init()

        statusItem.button?.action = #selector(StatusController.statusItemClicked(_:))
        statusItem.button?.target = self
        statusItem.highlightMode = false

        //        defaultIcon.size = NSSize(width: thickness - 3, height: thickness - 3)
        statusImage.isTemplate = isTemplate
        statusItem.button?.image = statusImage

    }

    @objc func statusItemClicked(_ sender: AnyObject?) {
        onClick(statusItem)
    }
}
