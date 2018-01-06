//
//  CryptoBarTests.swift
//  CryptoBarTests
//
//  Created by Kaunteya Suryawanshi on 19/08/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest
//@testable import FloatCoin

class CryptoBarTests: XCTestCase {
    
    
    func testExample() {
        let testArray = [10, 20, 30 , 40]
        XCTAssertEqual(testArray.sortedInsertionIndex(newObj: 25), 2)
        XCTAssertEqual(testArray.sortedInsertionIndex(newObj: 2), 0)
        XCTAssertEqual(testArray.sortedInsertionIndex(newObj: 35), 3)
        XCTAssertEqual(testArray.sortedInsertionIndex(newObj: 45), 4)
    }

    func testCurrencySymbol() {
        XCTAssertEqual(Currency("USD")!.symbol, "$")
        XCTAssertEqual(Currency("INR")!.symbol, "₹")
        XCTAssertEqual(Currency("EUR")!.symbol, "€")
    }
    func testFixedWidth() {
        XCTAssertEqual(10011.123.fixedWidth, "10011")
        XCTAssertEqual(4567.123.fixedWidth, "4567")
        XCTAssertEqual(Double(10011).fixedWidth, "10011")
        XCTAssertEqual(345.12345.fixedWidth, "345.1")
        XCTAssertEqual(345.1.fixedWidth, "345.1")
        XCTAssertEqual(Double(345).fixedWidth, "345.0")
        XCTAssertEqual(34.12345.fixedWidth, "34.12")
        XCTAssertEqual(34.12.fixedWidth, "34.12")
        XCTAssertEqual(34.10.fixedWidth, "34.10")
        XCTAssertEqual(34.1.fixedWidth, "34.10")
        XCTAssertEqual(Double(34).fixedWidth, "34.00")
    }
}
