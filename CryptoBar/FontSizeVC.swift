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
        let mainVC = self.presenting as! ViewController
        let windowController = mainVC.view.window!.windowController as! WindowController
        windowController.show()
    }
}
