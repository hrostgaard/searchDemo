//
//  DemoTests.swift
//  DemoTests
//
//  Created by Henrik Rostgaard on 07/02/16.
//  Copyright (c) 2016 35b.dk. All rights reserved.
//

import XCTest
@testable import Demo

class DemoTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSearch() {
        let expectation = expectationWithDescription("Search for some result")

        FoursquareDataManager().loadFoursquareData("sushi", location: (55.765,12.497)) { (data, resultOk) in
            XCTAssertTrue(resultOk)
            XCTAssert(data.count > 0, "No data found")
            expectation.fulfill()
        }

        //wait until the expectation is fulfilled or timeout
        waitForExpectationsWithTimeout(5)  { error in
            XCTAssertNil(error, "Oh, we got timeout")
        }
    }
    
    func testSearchNoResults() {
        let expectation = expectationWithDescription("Search with expectation to found 0 entries")

        FoursquareDataManager().loadFoursquareData("1234567890abcdefghijklmnopq", location: (55.765,12.497)) { (data, resultOk) in
            XCTAssertTrue(resultOk)
            XCTAssertEqual(data.count, 0, "Unexpected data found")
            expectation.fulfill()
        }

        // Loop until the expectation is fulfilled in onDone method
        waitForExpectationsWithTimeout(5)  { error in
            XCTAssertNil(error, "Oh, we got timeout")
        }
    }

    func testSearchWithIlligalSearchString() {
        let expectation = expectationWithDescription("Search with illigal searchString, expect")

        FoursquareDataManager().loadFoursquareData("min sushi", location: (55.765,12.497)) { (data, resultOk) in
            XCTAssertFalse(resultOk)
            expectation.fulfill()
        }

        // Loop until the expectation is fulfilled in onDone method
        waitForExpectationsWithTimeout(5)  { error in
            XCTAssertNil(error, "Oh, we got timeout")
        }
    }
}
