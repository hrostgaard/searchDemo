//
//  MainViewController.swift
//  Demo
//  TableVIewCell to display an FoursquareDataModel in a tableView (We dispal name, address + distance)
//
//  Created by Henrik Rostgaard on 07/02/16.
//  Copyright (c) 2016 35b.dk. All rights reserved.
//


import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {

    private let name = UILabel()
    private let address = UILabel()
    private let distance = UILabel()
    private let separator = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .None
        addNameLabel(name)
        addDistanceLabel(distance)
        addAddressLabel(address)

        separator.backgroundColor = UIColor.lightGrayColor()
        contentView.addSubview(separator)
        separator.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(0.5)
            make.bottom.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populateCell(data: FoursquareDataModel) {
        name.text = data.name
        address.text = data.address.joinWithSeparator("\n")
        distance.text = "\(data.distance) m"
    }

    private func addNameLabel(infoLabel: UILabel) {
        infoLabel.font = UIFont.boldSystemFontOfSize(24)
        infoLabel.textColor = UIColor.blackColor()
        infoLabel.lineBreakMode = .ByTruncatingTail
        infoLabel.textAlignment = .Left
        contentView.addSubview(infoLabel)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(5)
            make.left.right.equalTo(contentView).offset(UIEdgeInsetsMake(0, 15, 0, -15))
        }
    }

    private func addDistanceLabel(infoLabel: UILabel) {
        infoLabel.font = UIFont.boldSystemFontOfSize(16)
        infoLabel.textColor = UIColor.grayColor()
        infoLabel.textAlignment = .Right
        contentView.addSubview(infoLabel)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(name.snp_bottom)
            make.right.equalTo(contentView).offset(-25)
            make.bottom.greaterThanOrEqualTo(contentView).offset(-10)
        }
    }

    private func addAddressLabel(infoLabel: UILabel) {
        infoLabel.font = UIFont.boldSystemFontOfSize(16)
        infoLabel.textColor = UIColor.grayColor()
        infoLabel.textAlignment = .Left
        infoLabel.lineBreakMode = .ByWordWrapping
        infoLabel.numberOfLines = 0
        contentView.addSubview(infoLabel)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(name.snp_bottom)
            make.left.equalTo(contentView).offset(25)
            make.bottom.equalTo(contentView).offset(-10)
            make.right.equalTo(distance.snp_left).offset(-20)
        }
    }
}
