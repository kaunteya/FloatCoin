//
//  AppDelegate.swift
//  CryptoBar
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItemController: StatusController!
    var windowController: WindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.registerDefaults()
        self.windowController = (NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "windowController") as! WindowController)
        
        statusItemController = StatusController(statusImage: #imageLiteral(resourceName: "statusIcon"), isTemplate: true, clickHandler: { statusItem in
            self.windowController.toggleAppWindow()
        })

        //Show window afer some delay. Window cannot be made visible immediately.
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.windowController.show()
        }

        MSAppCenter.start("ae38a85c-88b1-4c27-ac49-cf28a7897ef6", withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ]
        )
    }
}
