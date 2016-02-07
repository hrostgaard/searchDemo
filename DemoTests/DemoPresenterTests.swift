//
//  DemoTests.swift
//  DemoTests
//
//  Created by Henrik Rostgaard on 07/02/16.
//  Copyright (c) 2016 35b.dk. All rights reserved.
//

import XCTest
@testable import Demo


class MockDataManager : FoursquareDataMangerProtocol {
    func loadFoursquareData(searchString: String, location: (Double, Double), completion: ([FoursquareDataModel], resultOk:Bool) -> Void) {
        let mockData = [FoursquareDataModel(name: "venue1", address: ["main street 1", "neverland"], distance: 400),
                              FoursquareDataModel(name: "venue2", address: ["Another road 2"], distance: 850)]
        completion(mockData, resultOk: true)
    }
}

class MockMainView : MainViewProtocol {
    var infoCalled : ((text:String)->Void)?
    var dataCalled : ((data:[FoursquareDataModel])->Void)?

    init(infoCalled: ((text:String)->Void)? = nil, dataCalled: ([FoursquareDataModel]->Void)? = nil) {
        self.infoCalled = infoCalled
        self.dataCalled = dataCalled
    }

    func displayCounter(countValue: String) {
    }

    func displayData(data: [FoursquareDataModel]) {
        dataCalled?(data:data)
    }

    func displayInfoText(text: String) {
        infoCalled?(text:text)
    }
}

class DemoPresenterTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    //This validate that the info is updated when viewIsReady is called from 'view'
    func testViewIsReady() {
        let expectation = expectationWithDescription("Search for some result")

        let presenter = MainPresenter(dataManager: MockDataManager())
        presenter.view = MockMainView(infoCalled: { text in
            XCTAssertEqual(text, "Start to type a search string", "wrong info text")
            expectation.fulfill()
        })

        presenter.viewIsReady()

        //Now we "wait" for view is called with a specific text!
        waitForExpectationsWithTimeout(5)  { error in
            XCTAssertNil(error, "Oh, we got timeout")
        }
    }

    //This validate that the info is updated when searchInputUpdated before an location is set
    func testSearchWithoutLocation() {
        let expectation = expectationWithDescription("Search for some result")

        let presenter = MainPresenter(dataManager: MockDataManager())
        presenter.view = MockMainView(infoCalled: { text in
            XCTAssertEqual(text, "Unknown location, try again later", "wrong info text")
            expectation.fulfill()
        })

        presenter.searchInputUpdated("test")

        //Now we "wait" for view is called with a specific text!
        waitForExpectationsWithTimeout(5)  { error in
            XCTAssertNil(error, "Oh, we got timeout")
        }
    }

    //This validate that the data is as expected after a search
    func testSearch() {
        let expectation = expectationWithDescription("Search for some result")

        let presenter = MainPresenter(dataManager: MockDataManager())
        presenter.view = MockMainView(dataCalled: { (data:[FoursquareDataModel]) in
            XCTAssertEqual(data.count, 2, "Wrong number of data returned")
            expectation.fulfill ()
        })

        presenter.setCurrentLocation((55.4,35.55))
        presenter.searchInputUpdated("test")

        //Now we "wait" for view is called with a specific text!
        waitForExpectationsWithTimeout(5)  { error in
            XCTAssertNil(error, "Oh, we got timeout")
        }
    }

}
