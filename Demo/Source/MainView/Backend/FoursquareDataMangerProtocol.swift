//
// Created by Henrik Rostgaard on 07/02/16.
// Copyright (c) 2016 35b.dk. All rights reserved.
//

import Foundation

//Method the presenter can call on the dataManager
protocol FoursquareDataMangerProtocol: class {
    func loadFoursquareData(searchString: String, location: (Double, Double), completion: ([FoursquareDataModel], resultOk: Bool) -> Void) -> Void;
}
