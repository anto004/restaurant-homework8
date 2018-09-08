//
//  Artwork.swift
//  Homework8
//
//  Created by Antonio Bang on 9/7/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import Foundation;
import MapKit;

class Artwork: NSObject, MKAnnotation {
    let title: String?;
    let locationName: String;
    let coordinate: CLLocationCoordinate2D;
    
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = name;
        self.locationName = address;
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName;
    }

}
