//
//  Provider.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
enum Exchange {
    case kraken, coinbase, cex
    var description: String {
        switch self {
        case .kraken: return "Kraken"
        case .cex: return "CEX"
        case .coinbase: return "Coinbase"
        }
    }
}
