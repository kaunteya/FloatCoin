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
    

}
