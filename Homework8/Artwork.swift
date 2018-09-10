//
//  Artwork.swift
//  Homework8
//
//  Created by Antonio Bang on 9/7/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import Foundation;
import MapKit;
import Contacts;

class Artwork: NSObject, MKAnnotation {
    let title: String?; //Required
    let locationName: String; //Required
    let coordinate: CLLocationCoordinate2D; //Required
    let image: UIImage?;
    
    
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.title = name;
        self.locationName = address;
        self.coordinate = coordinate;
        self.image = image;
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName;
    }
    
    func mapItem() -> MKMapItem {
        let address = [CNPostalAddressStreetKey: subtitle!];
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: address);
        
        let mapItem = MKMapItem(placemark: placemark);
        mapItem.name = title;
        
        return mapItem;
    }

}
