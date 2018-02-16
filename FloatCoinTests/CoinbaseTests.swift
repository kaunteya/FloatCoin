//
//  CoinbaseTests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 17/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class CoinbaseTests: XCTestCase, ExchangeTests {

    var testPairs: [Pair] {
        return [Pair("btc", "USD")]
    }

    func testURLGenerationForOnePair() {
        let urlRequest = Coinbase.urlRequest(for: Set([testPairs.first!]))
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://api.coinbase.com/v2/prices/BTC-USD/spot")
    }

    func testURLGenerationForMultiplePairs() {
        //Coinbase does not support multiple pairs
    }

    func testPriceRequest() {
        let expectation = XCTestExpectation(description: "fetchpairs")

        Coinbase.fetchRate(Set(testPairs)) { (pairDict) in
            XCTAssertEqual(Set<Pair>(pairDict.keys), Set(self.testPairs))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}

