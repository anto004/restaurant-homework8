//
//  Restaurant.swift
//  Homework8
//
//  Created by Antonio Bang on 9/6/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import Foundation;
import UIKit;

struct Restaurant {
    var name: String?;
    var address: String?;
    var image: UIImage?;
    var imageUrl: String?;
    var latitude: Double;
    var longitude: Double;



//    init(name: String, address: String, imageUrl: String) {
//        self.name = name;
//        self.address = address;
//        self.imageUrl = imageUrl;
//    }
//
//    init(name: String, address: String, image: UIImage) {
//        self.name = name;
//        self.address = address;
//        self.image = image;
//    }

    init(name: String, address: String, imageUrl: String, latitude: Double, longitude: Double) {
        self.name = name;
        self.address = address;
        self.imageUrl = imageUrl;
        self.latitude = latitude;
        self.longitude = longitude;
    }

    init(name: String, address: String, image: UIImage, latitude: Double, longitude: Double) {
        self.name = name;
        self.address = address;
        self.image = image;
        self.latitude = latitude;
        self.longitude = longitude;
    }
}
