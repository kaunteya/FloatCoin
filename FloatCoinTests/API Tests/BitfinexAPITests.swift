//
//  BitfinexAPITests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 17/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class BitfinexAPITests : XCTestCase {

    func testBifinexSymbolRequest() {
        let expectation = XCTestExpectation(description: "symbols")
        let url = URL(string: "https://api.bitfinex.com/v1/symbols")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            XCTAssertNotNil(data, "No data was downloaded.")
            XCTAssertNil(error)
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String]
            XCTAssertEqual(json.count, 105, "Symbol count has changed")
            expectation.fulfill()
            }.resume()
        wait(for: [expectation], timeout: 10.0)
    }

}
