//
// Created by Henrik Rostgaard on 07/02/16.
// Copyright (c) 2016 35b.dk. All rights reserved.
//

import Foundation

//Method the presenter can call on the View
protocol MainViewProtocol: class {
    func displayData(data: [FoursquareDataModel])

    func displayInfoText(text: String)

    func displayCounter(countValue: String)
}
