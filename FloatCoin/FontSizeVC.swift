//
//  FontSizeVC.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 12/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class FontSizeVC : NSViewController {
    override func viewDidAppear() {
        super.viewDidAppear()
        showWindow()
    }

    private func showWindow() {
        // Font window will hide the main window if "Flot on top is false"
        // Hence we explicitly call the show function to make sure it is still visible
        let mainVC = self.presenting as! ViewController
        let windowController = mainVC.view.window!.windowController as! WindowController
        windowController.show()

    }
}
