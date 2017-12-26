//
//  Provider.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
enum Exchange: String {
    case kraken, coinbase, cex

    // Whenever new exchange is added to the enum, add it to `all`.
    // In all make sure that it always stays sorted
    static var all: [Exchange] {
        return [Exchange.cex, Exchange.coinbase, Exchange.kraken]
    }

    var description: String {
        switch self {
        case .kraken: return "Kraken"
        case .cex: return "CEX"
        case .coinbase: return "Coinbase"
        }
    }

    var type: ExchangeDelegate.Type {
        switch self {
        case .kraken: return Kraken.self
        case .cex: return CEX.self
        case .coinbase: return Coinbase.self
        }
    }
}
