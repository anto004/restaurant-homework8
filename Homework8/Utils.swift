//
//  Utils.swift
//  Homework8
//
//  Created by Antonio Bang on 9/5/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import Foundation

struct Utils {
    static func parseJson(_ data: Data) -> [Restaurant] {
        var restaurants = [Restaurant]();

        let jsonData = try? JSONSerialization.jsonObject(with: data)
        if let jsonObj = jsonData as? [String: Any] {
            if let jsonBusiness = jsonObj["businesses"] as? [Any]{
                for businessObj in jsonBusiness {
                    if let restaurant = businessObj as? [String: Any]{
                        if let name = restaurant["name"] as? String,
                           let location = restaurant["location"] as? [String: Any],
                           let address = location["display_address"] as? [String],
                            let imageUrl = restaurant["image_url"] as? String{
                            var stringAddress = "";

                            for line in address {
                                stringAddress.append(line);
                            }
                            //print("\(name) \(stringAddress) \(imageUrl)")

                            restaurants.append(Restaurant(name: name, address: stringAddress, imageUrl: imageUrl))
                        }

                    }
                }
            }
        }

        return restaurants;
    }

}
