//
//  BitfinexAPITests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 17/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

class BitfinexAPITests : XCTestCase {

    func testPairCount() {
        let expectation = XCTestExpectation(description: "symbols")
        let url = URL(string: "https://api.bitfinex.com/v1/symbols")!

        let currentPairs = Bitfinex.baseCurrencies.reduce(Set<String>()) { (result, currency) -> Set<String> in
            let fiatlist = Bitfinex.FIATCurriences(crypto: currency)
            let added = fiatlist.map { currency.stringValue.lowercased() + $0.stringValue.lowercased()}
            return result.union(added)
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            XCTAssertNotNil(data, "No data was downloaded.")
            XCTAssertNil(error)
            let jsonPairs = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String]
            jsonPairs.forEach { XCTAssert($0.count == 6, "Not every pair is of form ABC:XYZ") }

            let addedPairs = Set(jsonPairs).subtracting(currentPairs)
            if addedPairs.count > 0 {
                self.printDetails(Set(jsonPairs).splitPairsToDictionary())
                XCTFail("Pairs added, update the list")
            }

            let removedPairs = currentPairs.subtracting(Set(jsonPairs))
            if removedPairs.count > 0 {
                self.printDetails(removedPairs.splitPairsToDictionary())
                XCTFail("Pairs REMOVED")
            }

            expectation.fulfill()
            }.resume()
        wait(for: [expectation], timeout: 10.0)
    }
    func printDetails(_ dict: [String: Set<String>]) {
        let sortedKeys = Array(dict.keys).sorted(by: { $0 < $1 })
        print(sortedKeys.map { $0.uppercased()})
        for a in sortedKeys {
            let vals = dict[a]!.map { $0.uppercased()}
            print("\"\(a.uppercased())\" : \(vals),")
        }
    }

}

fileprivate extension Set where Element == String {
    func splitPairsToDictionary() -> [String: Set<String>]{
        var dict = [String: Set<String>]()
        for pair in self {
            let three = pair.index(pair.startIndex, offsetBy: 3)
            let (first,second) = (String(pair[..<three]), String(pair[three...]))
            if dict[first] == nil {
                dict[first] = Set(arrayLiteral: second)
            } else {
                dict[first] = dict[first]!.union([second])
            }
        }
        return dict
    }
}
