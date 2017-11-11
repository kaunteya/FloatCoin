//
//  AppDelegate.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItemController: StatusController!
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItemController = StatusController(statusImage: #imageLiteral(resourceName: "statusIcon"), isTemplate: true, clickHandler: { statusItem in
            Swift.print("click")
            self.window.orderFront(self)
        })
    }
}
