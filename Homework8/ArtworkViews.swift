//
//  ArtworkViews.swift
//  Homework8
//
//  Created by Antonio Bang on 9/9/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import Foundation
import MapKit;

class ArtworkView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Artwork else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            image = artwork.image;
            
        }
    }
}
