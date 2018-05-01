//
//  CurrencyTests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 16/02/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class CurrencyTests: XCTestCase {

    let inr = Currency("INR")

    func testCurrencyIsUpperCased() {
        XCTAssertEqual(Currency("btc").stringValue, "BTC", "Currency must be uppercases in initializer")
    }

    func testLocale() {
        XCTAssertEqual(Locale("INR")!.identifier, "en_IN")
        XCTAssertEqual(Locale("GBP")!.identifier, "en_GB")
        XCTAssertNil(Locale("BTC"))
    }

    func testCurrencySymbols() {
        XCTAssertEqual(Currency("INR").formatted(price: 1234), "₹ 1,234")
        XCTAssertEqual(Currency("USD").formatted(price: 1234), "$1,234")
        XCTAssertEqual(Currency("EUR").formatted(price: 1234), "€1 234")
        XCTAssertEqual(Currency("GBP").formatted(price: 1234), "£1,234")
    }

    func testInvalidCurrency() {
        XCTAssertEqual(Currency("BTC").formatted(price: 1234), "BTC 1,234")
        XCTAssertEqual(Currency("BTC").formatted(price: 0.1), "BTC 0.10000")
        XCTAssertEqual(Currency("BTC").formatted(price: 0.12), "BTC 0.12000")
    }

    func testsVerySmallNumbers() {
        XCTAssertEqual(inr.formatted(price: 0.0071234), "₹ 0.00712")
        XCTAssertEqual(inr.formatted(price: 0.00071234), "₹ 0.000712")
        XCTAssertEqual(inr.formatted(price: 0.000071234), "₹ 0.0000712")
        XCTAssertEqual(inr.formatted(price: 0.0000071234), "₹ 0.00000712")
        XCTAssertEqual(inr.formatted(price: 0.00000071234), "₹ 0.000000712")
        XCTAssertEqual(inr.formatted(price: 0.000000071234), "₹ 0.0000000712")
        XCTAssertEqual(inr.formatted(price: 0.0000000071234), "₹ 0.00000000712")
        XCTAssertEqual(inr.formatted(price: 0.000000007), "₹ 0.00000000700")
    }

    func testDigit0() {
        // 5 digits after decimal point
        XCTAssertEqual(inr.formatted(price: 0.1), "₹ 0.10000")
        XCTAssertEqual(inr.formatted(price: 0.11), "₹ 0.11000")
        XCTAssertEqual(inr.formatted(price: 0.111), "₹ 0.11100")
        XCTAssertEqual(inr.formatted(price: 0.1111), "₹ 0.11110")
        XCTAssertEqual(inr.formatted(price: 0.11111), "₹ 0.11111")
        XCTAssertEqual(inr.formatted(price: 0.111111), "₹ 0.11111")
        XCTAssertEqual(inr.formatted(price: 0.1111111), "₹ 0.11111")
    }

    func testDigit1() {
        // 3 digits after decimal point
        XCTAssertEqual(inr.formatted(price: 1), "₹ 1.000")
        XCTAssertEqual(inr.formatted(price: 1.1), "₹ 1.100")
        XCTAssertEqual(inr.formatted(price: 1.11), "₹ 1.110")
        XCTAssertEqual(inr.formatted(price: 1.111), "₹ 1.111")
        XCTAssertEqual(inr.formatted(price: 1.1111), "₹ 1.111")
    }

    func testDigit2() {
        // 2 digits after decimal point
        XCTAssertEqual(inr.formatted(price: 11), "₹ 11.00")
        XCTAssertEqual(inr.formatted(price: 11.0), "₹ 11.00")
        XCTAssertEqual(inr.formatted(price: 11.1), "₹ 11.10")
        XCTAssertEqual(inr.formatted(price: 11.11), "₹ 11.11")
        XCTAssertEqual(inr.formatted(price: 11.111), "₹ 11.11")
        XCTAssertEqual(inr.formatted(price: 11.1111), "₹ 11.11")
    }

    func testDigit3() {
        // Only one digit after decimal point
        XCTAssertEqual(inr.formatted(price: 111), "₹ 111.0")
        XCTAssertEqual(inr.formatted(price: 111.0), "₹ 111.0")
        XCTAssertEqual(inr.formatted(price: 111.1), "₹ 111.1")
        XCTAssertEqual(inr.formatted(price: 111.12), "₹ 111.1")
        XCTAssertEqual(inr.formatted(price: 111.123), "₹ 111.1")
    }

    func testDigitMorethan3() {
        XCTAssertEqual(inr.formatted(price: 1234), "₹ 1,234")
        XCTAssertEqual(inr.formatted(price: 12345), "₹ 12,345")
        XCTAssertEqual(inr.formatted(price: 123456), "₹ 1,23,456")
        XCTAssertEqual(inr.formatted(price: 1234567), "₹ 12,34,567")
        XCTAssertEqual(inr.formatted(price: 12345678), "₹ 1,23,45,678")
        XCTAssertEqual(inr.formatted(price: 12345678.1), "₹ 1,23,45,678")
        XCTAssertEqual(inr.formatted(price: 12345678.12), "₹ 1,23,45,678")
        XCTAssertEqual(inr.formatted(price: 12345678.123), "₹ 1,23,45,678")
    }
}
