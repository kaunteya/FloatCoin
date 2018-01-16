//
//  DonateVC.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 06/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit
class DonateVC: NSViewController {
    override func dismiss(_ sender: Any?) {
        Swift.print("dismiss")
        self.parent?.dismiss(nil)
    }
}
