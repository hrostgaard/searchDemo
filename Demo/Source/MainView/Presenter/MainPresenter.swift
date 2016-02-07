//
//  MainPresenter.swift
//  Demo
//
//  Created by Henrik Rostgaard on 07/02/16.
//  Copyright © 2016 35b.dk. All rights reserved.
//

import Foundation

class MainPresenter {
    var view: MainViewProtocol!

    private let dataManager: FoursquareDataMangerProtocol
    private var currentLocation : (Double,Double)?

    init(dataManager: FoursquareDataMangerProtocol){
        self.dataManager = dataManager
    }
}

extension MainPresenter: MainPresenterProtocol {

    func searchInputUpdated(searchString: String) {
        guard let location = currentLocation else {
            //No location yet, inform user and return
            self.updateView(info: "Unknown location, try again later")
            return
        }

        //This escaping is needed to ensure no illegal chars in url. eg spaces etc. (Could be moved to DataManger)
        if let escapedSearchString = searchString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            if (searchString.isEmpty) {
                //No seaarch string, clear + inform user and return
                self.updateView(info: "Please type a new search string")
                return
            }

            dataManager.loadFoursquareData(escapedSearchString, location: location) {
                (data, resultOk) in
                dispatch_async(dispatch_get_main_queue(), {
                    if (resultOk) {
                        if data.isEmpty {
                            //No search result, clear + inform user
                            self.updateView(info: "No data found, change search string")
                        } else {
                            //Yes a search result, display data
                            self.updateView(data, counter: "\(data.count)")
                        }
                    } else {
                        self.updateView(info: "Sorry, something went wrong")
                    }
                })
            }
        }
    }

    func viewIsReady() {
        //The view is ready, send info to user.
        self.updateView(info: "Start to type a search string")
    }

    func setCurrentLocation(location: (Double, Double)?) {
        //We save the specified location (to be used on following searches)
        currentLocation = location
    }

    //Helper func to update all 3 values (using default to make use simpler)
    private func updateView(data: [FoursquareDataModel] = [], counter: String = "", info:String = "") {
        self.view.displayData(data)
        self.view.displayCounter(counter)
        self.view.displayInfoText(info)
    }
}