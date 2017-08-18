//
//  ViewController.swift
//  CryptShow
//
//  Created by Kaunteya Suryawanshi on 18/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var timer: Timer!
    @IBOutlet weak var mainLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    @IBAction func actionClose(_ sender: Any) {
        
    }

    func timerAction() {
        networkReq()
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        Swift.print("View appeared")
        timer.fire()
        self.view.window!.isMovableByWindowBackground = true
        self.view.window!.level = Int(CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow))

    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        timer.invalidate()
    }

    func networkReq() {
        HttpClient.getConversions { json in

            var mainString = ""
            let allCurrency = json["data"] as! [JSONDictionary]
            for iCurrency in allCurrency {
                if let currency = Currency(iCurrency) {
                    mainString += "  [\(currency.name):\(currency.price)]"
                }
            }
            DispatchQueue.main.async {
                Swift.print("Timer action \(mainString)")
                self.mainLabel.stringValue = mainString
            }
        }
    }
}

