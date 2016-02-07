//
//  FoursquareDataManger.swift
//  Demo
//
//  Created by Henrik Rostgaard on 07/02/16.
//  Copyright © 2016 35b.dk. All rights reserved.
//

import Foundation
import CoreLocation


class FoursquareDataManager : FoursquareDataMangerProtocol {

    private let CLIENT_ID = "X0EB2PODK042RBHCFVULKL0QEAY1IPBYLIYZJGNUYWREIRJU"
    private let CLIENT_SECRET = "<Insert Secret here>"

    func loadFoursquareData(searchString: String, location: (Double, Double), completion: ([FoursquareDataModel], resultOk: Bool) -> Void) -> Void {
        let session = NSURLSession.sharedSession()
        let urlString = "https://api.foursquare.com/v2/venues/search?ll=\(location.0),\(location.1)&client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20160207&query=\(searchString)&limit=50"

        guard let url = NSURL(string: urlString) else {
            completion([], resultOk: false)
            return
        }

        session.dataTaskWithURL(url, completionHandler: {
            (data, response, error) in

            guard error == nil, let urlContent = data else {
                completion([], resultOk: false)
                return
            }

            self.parseJson(urlContent, completionHandler: completion)

        }).resume()
    }

    private func parseJson(data: NSData, completionHandler: ([FoursquareDataModel], resultOk: Bool) -> Void) {
        var json: [String: AnyObject]!
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
        } catch {
            completionHandler([], resultOk: false)
        }

        guard let response = json["response"] as? [String: AnyObject],
              let venues = response["venues"] as? [AnyObject] else {
            completionHandler([], resultOk: false)
            return
        }

        //Loop all venues at create FoursquareDataModel's (Using flatmap to remove any nil's (Venues not conform with expected json)
        let result = venues.map {
            (venue: AnyObject) -> FoursquareDataModel? in

            guard let name = venue["name"] as? String,
                let location = venue["location"] as? [String: AnyObject],
                let distance = location["distance"] as? Int,
                let address = location["formattedAddress"] as? [String] else {
                return nil //This venue is not in expected format return nil (Will be removed later)
            }
            return FoursquareDataModel(name: name, address: address, distance: distance)
        }.flatMap {$0}.sort({ $0.distance < $1.distance })

        completionHandler(result, resultOk: true)
    }
}

//Example of data from Foursquare..
/*
{
    "meta": {
        "code": 200,
        "requestId": "56b723ea498ee943fb0994de"
    },
    "response": {
        "venues": [{
            "id": "4d64f6f94e1ea1cd848f4ab9",
            "name": "SMC Biler Køge",
            "contact": {
                "phone": "+4556652001",
                "formattedPhone": "+45 56 65 20 01"
            },
            "location": {
                "address": "Tangmosevej 110",
                "lat": 55.47548058238196,
                "lng": 12.185584176356347,
                "distance": 12173,
                "postalCode": "4600",
                "cc": "DK",
                "city": "Køge",
                "state": "Zealand",
                "country": "Denmark",
                "formattedAddress": ["Tangmosevej 110", "4600 Køge", "Denmark"]
            },
            "categories": [{
                "id": "4bf58dd8d48988d124951735",
                "name": "Automotive Shop",
                "pluralName": "Automotive Shops",
                "shortName": "Automotive",
                "icon": {
                    "prefix": "https:\/\/ss3.4sqi.net\/img\/categories_v2\/shops\/automotive_",
                    "suffix": ".png"
                },
                "primary": true
            }],
            "verified": false,
            "stats": {
                "checkinsCount": 47,
                "usersCount": 21,
                "tipCount": 0
            },
            "allowMenuUrlEdit": true,
            "specials": {
                "count": 0,
                "items": []
            },
            "hereNow": {
                "count": 0,
                "summary": "Nobody here",
                "groups": []
            },
            "referralId": "v-1454842858",
            "venueChains": []
        }
*/