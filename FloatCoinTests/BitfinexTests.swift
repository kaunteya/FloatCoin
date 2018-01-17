//
//  BitfinexTests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 16/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class BitfinexTests : XCTestCase {

    func testURLGenrationForOnePair() {
        let testPairs = [Pair("xrp:btc")]
        let urlRequest = Bitfinex.urlRequest(for: Set(testPairs))
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://api.bitfinex.com/v2/tickers?symbols=tXRPBTC")
    }

    func testURLGenerationForMultiplePairs() {
        let testPairs = [Pair("xrp:btc"), Pair("eth:btc"), Pair("iot:eth")]
        let urlRequest = Bitfinex.urlRequest(for: Set(testPairs))
        XCTAssertEqual(urlRequest.url!.absoluteString, "https://api.bitfinex.com/v2/tickers?symbols=tETHBTC,tIOTETH,tXRPBTC")

    }

    func testRequest() {
        let expectation = XCTestExpectation(description: "fetchpairs")

        let pairs = [Pair("BTC:USD"), Pair("LTC:USD")]
        Bitfinex.fetchRate(Set(pairs)) { (pairDict) in
            XCTAssertEqual(Set(pairDict.keys), Set(pairs))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testConvertToPair() {
        let nilPair = Bitfinex.convertToPair("btcusd")
        XCTAssertNil(nilPair, "Pair must start with 't'")

        let pair = Bitfinex.convertToPair("tbtcusd")
        XCTAssertNotNil(pair)
        XCTAssertEqual(pair!, Pair("BTC:USD"))
    }

}
