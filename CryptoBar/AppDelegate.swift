//
//  AppDelegate.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit
import SwiftyBeaver

let log: SwiftyBeaver.Type = {
    let log = SwiftyBeaver.self
    let console = ConsoleDestination()
    console.minLevel = .debug
    log.addDestination(console)
    return log
}()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItemController: StatusController!
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItemController = StatusController(statusImage: #imageLiteral(resourceName: "statusIcon"), isTemplate: true, clickHandler: { statusItem in
            log.info("click")
            self.window.orderFront(self)
        })
    }
}
