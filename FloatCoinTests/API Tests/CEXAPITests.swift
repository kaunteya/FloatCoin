//
//  CEXAPITests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 26/03/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class CEXAPITests: XCTestCase {

    func testPairCount() {
        let expectation = XCTestExpectation(description: "symbols")
        let url = URL(string: "https://cex.io/api/currency_limits")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            XCTAssertNotNil(data, "No data was downloaded.")
            XCTAssertNil(error)
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
            let data1 = json["data"] as! [String : Any]
            let pairs = data1["pairs"] as! [[String: Any]]
            var set = [String:[String]]()
            for p in pairs {
                let s1 = p["symbol1"] as! String
                let s2 = p["symbol2"] as! String
                if set[s1] == nil {
                    set[s1] = [s2]
                } else {
                    set[s1]?.append(s2)
                }
            }
            XCTAssertEqual(pairs.count, 30, "Pair count has changed \(set)")
            expectation.fulfill()
            }.resume()
        wait(for: [expectation], timeout: 10.0)
    }
}
