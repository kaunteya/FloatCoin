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
    console.minLevel = SwiftyBeaver.Level.error
    log.addDestination(console)
    return log
}()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItemController: StatusController!
    var windowController: WindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.registerDefaults()
        self.windowController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "windowController")) as! WindowController
        
        statusItemController = StatusController(statusImage: #imageLiteral(resourceName: "statusIcon"), isTemplate: true, clickHandler: { statusItem in
            self.windowController.toggleAppWindow()
        })

        //Show window afer some delay. Window cannot be made visible immediately.
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.windowController.show()
        }
    }
}
