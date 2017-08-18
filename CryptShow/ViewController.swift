//
//  ViewController.swift
//  CryptShow
//
//  Created by Kaunteya Suryawanshi on 18/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        HttpClient.getConversions { json in
            let dict = json["data"] as! JSONArray
            Swift.print("Completion \(dict.first)")
        }
    }


}

