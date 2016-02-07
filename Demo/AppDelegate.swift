//
//  AppDelegate.swift
//  Demo
//
//  Created by Henrik Rostgaard on 07/02/16.
//  Copyright (c) 2016 35b.dk. All rights reserved.
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let dataManger = FoursquareDataManager()
        let presenter = MainPresenter(dataManager: dataManger)
        let mainView = MainViewController(presenter: presenter)
        presenter.view = mainView
        window?.rootViewController = mainView

        window?.makeKeyAndVisible()

        return true
    }
}
