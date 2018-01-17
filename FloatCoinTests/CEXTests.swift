//
//  CEXTests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 17/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class CEXTests: XCTestCase, ExchangeTests {
    var testPairs: [Pair] {
        return [Pair("xrp:btc"), Pair("eth:btc"), Pair("zec:gbp")]
    }

    func testURLGenerationForOnePair() {
        let urlRequest = CEX.urlRequest(for: Set([testPairs.first!]))
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://cex.io/api/tickers/XRP/BTC/")
    }

    func testURLGenerationForMultiplePairs() {
        let urlRequest = CEX.urlRequest(for: Set(testPairs))
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://cex.io/api/tickers/ZEC/GBP/XRP/BTC/ETH/")
    }

    func testPriceRequest() {
        let expectation = XCTestExpectation(description: "fetchpairs")

        CEX.fetchRate(Set(testPairs)) { (pairDict) in
            XCTAssertEqual(Set(pairDict.keys), Set(self.testPairs))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
