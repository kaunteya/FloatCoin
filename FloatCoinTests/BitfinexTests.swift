//
//  BitfinexTests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 16/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class BitfinexTests : XCTestCase, ExchangeTests {
    var testPairs: [Pair] {
        return [Pair("BTC", "USD"), Pair("LTC", "USD")]
    }

    func testURLGenerationForOnePair() {
        let testPairs = [Pair("xrp", "btc")]
        let urlRequest = Bitfinex.urlRequest(for: Set([testPairs.first!]))
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://api.bitfinex.com/v2/tickers?symbols=tXRPBTC")
    }

    func testURLGenerationForMultiplePairs() {
//        let urlRequest = Bitfinex.urlRequest(for: Set(testPairs))
//        XCTAssertEqual(urlRequest.url!.absoluteString, "https://api.bitfinex.com/v2/tickers?symbols=tLTCUSD,tBTCUSD")
    }

    func testPriceRequest() {
        let expectation = XCTestExpectation(description: "fetchpairs")
        Bitfinex.fetchRate(Set(testPairs)) { (pairDict) in
            XCTAssertEqual(Set(pairDict.keys), Set(self.testPairs))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testConvertToPair() {
        let nilPair = Bitfinex.convertToPair("btcusd")
        XCTAssertNil(nilPair, "Pair must start with 't'")

        let pair = Bitfinex.convertToPair("tbtcusd")
        XCTAssertNotNil(pair)
        XCTAssertEqual(pair!, Pair(colonString: "BTC:USD"))
    }

}
