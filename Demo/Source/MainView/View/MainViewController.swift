//
//  MainViewController.swift
//  Demo
//
//  Created by Henrik Rostgaard on 07/02/16.
//  Copyright (c) 2016 35b.dk. All rights reserved.
//


import UIKit
import SnapKit
import CoreLocation

class MainViewController: UIViewController {

    private let locationManager = CLLocationManager()

    private let presenter: MainPresenterProtocol

    private let topHeaderView = UIView()
    private let counterLabel = UILabel()
    private let searchField = UITextField()
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let infoLabel = UILabel()

    private var data : [FoursquareDataModel] = []

    init(presenter: MainPresenterProtocol){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        requestCurrentLocation()

        addHeader(topHeaderView)
        addCounter(counterLabel, headerView: topHeaderView)
        addSearchField(searchField, headerView: topHeaderView)
        addTableView(tableView, searchField: searchField)
        addInfoLabel(infoLabel, table: tableView)

        presenter.viewIsReady()
    }

    private func requestCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func addHeader(headerBackgroundView: UIView) {
        headerBackgroundView.backgroundColor = UIColor(red: 0, green: 100/255, blue: 155/255, alpha: 1)
        view.addSubview(headerBackgroundView)
        headerBackgroundView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(22)
            make.left.right.equalTo(view)
            make.height.equalTo(60)
        }

        let title = UILabel()
        title.font = UIFont.systemFontOfSize(24)
        title.textColor = UIColor.whiteColor()
        title.text = "Search"
        title.numberOfLines = 0
        headerBackgroundView.addSubview(title)
        title.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(headerBackgroundView)
        }
    }

    private func addCounter(counterLabel: UILabel, headerView: UIView) {
        counterLabel.font = UIFont.systemFontOfSize(16)
        counterLabel.textColor = UIColor.whiteColor()
        counterLabel.textAlignment = .Right
        view.addSubview(counterLabel)
        counterLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(headerView)
            make.right.equalTo(headerView).offset(-15)
            make.height.equalTo(100)
        }
    }

    private func addSearchField(searchField: UITextField, headerView: UIView) {
        searchField.font = UIFont.systemFontOfSize(18)
        searchField.clearButtonMode = .Always
        searchField.placeholder = "Type here to search"
        searchField.autocapitalizationType = .None
        searchField.returnKeyType = .Done

        //Add rounded border
        searchField.layer.borderColor = UIColor.lightGrayColor().CGColor
        searchField.layer.borderWidth = 2.0
        searchField.layer.cornerRadius = 20.0
        searchField.layer.masksToBounds = true

        //Simple 'hack' to move text-input to the right (The right solution is to create custom UITextField and override textRectForBounds + editingRectForBounds
        let dummyView = UIView(frame: CGRectMake(0, 0, 10, 1))
        searchField.leftView = dummyView
        searchField.leftViewMode = .Always

        searchField.delegate = self

        view.addSubview(searchField)
        searchField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(headerView.snp_bottom).offset(4)
            make.left.equalTo(headerView).offset(15)
            make.right.equalTo(headerView).offset(-15)
            make.height.equalTo(40)
        }
    }

    private func addTableView(tableView: UITableView, searchField: UITextField) {
        tableView.dataSource = self  //.delegate not need for now

        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.registerClass(MainTableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(searchField.snp_bottom).offset(4)
            make.left.right.bottom.equalTo(view)
        }
    }

    private func addInfoLabel(infoLabel: UILabel, table: UITableView) {
        infoLabel.font = UIFont.systemFontOfSize(18)
        infoLabel.textColor = UIColor.grayColor()
        infoLabel.textAlignment = .Center
        infoLabel.numberOfLines = 0
        view.addSubview(infoLabel)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(table).offset(40)
            make.left.right.equalTo(table)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainTableViewCell
        cell.populateCell(data[indexPath.row])
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

extension MainViewController: UITextFieldDelegate {
    //This method is a 'simpel' way to get all changing values from the inputField. (and stop on return (= Go))
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        if let text = textField.text {
            textField.text = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            presenter.searchInputUpdated(textField.text!)
        }
        return false
    }
    

    internal func textFieldShouldClear(textField: UITextField) -> Bool {
        presenter.searchInputUpdated("")
        return true
    }

}

extension MainViewController: MainViewProtocol {
    func displayData(data: [FoursquareDataModel]) {
        self.data = data
        tableView.reloadData()
    }

    func displayCounter(countValue: String) {
        counterLabel.text = countValue
    }

    func displayInfoText(text: String) {
        infoLabel.text = text
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            presenter.setCurrentLocation((location.coordinate.latitude, location.coordinate.longitude))
            if (location.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
                //In realworld app, we might need to check location again, but for this app this must be ok.
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
}
