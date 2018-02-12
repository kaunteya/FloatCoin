//
//  BitfinexAPITests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 17/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class BitfinexAPITests : XCTestCase {

    let currentSymbol = [
        "btcusd", "ltcusd", "ltcbtc", "ethusd", "ethbtc", "etcbtc", "etcusd",
        "rrtusd", "rrtbtc", "zecusd", "zecbtc", "xmrusd", "xmrbtc", "dshusd",
        "dshbtc", "btceur", "xrpusd", "xrpbtc", "iotusd", "iotbtc", "ioteth",
        "eosusd", "eosbtc", "eoseth", "sanusd", "sanbtc", "saneth", "omgusd",
        "omgbtc", "omgeth", "bchusd", "bchbtc", "bcheth", "neousd", "neobtc",
        "neoeth", "etpusd", "etpbtc", "etpeth", "qtmusd", "qtmbtc", "qtmeth",
        "avtusd", "avtbtc", "avteth", "edousd", "edobtc", "edoeth", "btgusd",
        "btgbtc", "datusd", "datbtc", "dateth", "qshusd", "qshbtc", "qsheth",
        "yywusd", "yywbtc", "yyweth", "gntusd", "gntbtc", "gnteth", "sntusd",
        "sntbtc", "snteth", "ioteur", "batusd", "batbtc", "bateth", "mnausd",
        "mnabtc", "mnaeth", "funusd", "funbtc", "funeth", "zrxusd", "zrxbtc",
        "zrxeth", "tnbusd", "tnbbtc", "tnbeth", "spkusd", "spkbtc", "spketh"]

    func testBifinexSymbolRequest() {
        let expectation = XCTestExpectation(description: "symbols")
        let url = URL(string: "https://api.bitfinex.com/v1/symbols")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            XCTAssertNotNil(data, "No data was downloaded.")
            XCTAssertNil(error)
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String]
            XCTAssertEqual(json.count, self.currentSymbol.count)
            XCTAssertEqual(Set(self.currentSymbol), Set(json))
            expectation.fulfill()
            }.resume()
        wait(for: [expectation], timeout: 10.0)
    }

}
