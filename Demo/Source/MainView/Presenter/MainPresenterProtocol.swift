//
// Created by Henrik Rostgaard on 07/02/16.
// Copyright (c) 2016 35b.dk. All rights reserved.
//

import Foundation

//Methods the view should/could call on the presenter
protocol MainPresenterProtocol: class {
    func viewIsReady()
    func searchInputUpdated(searchString: String)
    func setCurrentLocation(location: (Double, Double)?)
}
