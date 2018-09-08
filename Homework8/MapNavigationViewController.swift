//
//  MapNavigationViewController.swift
//  Homework8
//
//  Created by Antonio Bang on 9/7/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import UIKit;
import MapKit;
import CoreLocation;

class MapNavigationViewController: UIViewController{
    let locationManager = CLLocationManager();
    
    var currentLatitude: Double?;
    
    var currentLongitude: Double?;
    
    let regionRadius: CLLocationDistance = 1000;
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
//        locationManager.delegate = self;
//        locationManager.requestWhenInUseAuthorization();
        
        //locationManager.requestLocation();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let latitude = currentLatitude, let longitude = currentLongitude {
            let currentLocation = CLLocation(latitude: latitude, longitude: longitude);
            centerMapOnLocation(location: currentLocation)
        }
    }
    
    private func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

extension MapNavigationViewController: CLLocationManagerDelegate {
    //Start the updating location
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            print("User has not authorized access to location information")
            return
        }
        //Services not available.
        if !CLLocationManager.locationServicesEnabled() {
            print("Location services is not available.");
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping(CLPlacemark?) -> Void) {
        //Use the last reported location
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder();
            
            //Look up the location
            geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0];
                    completionHandler(firstLocation);
                }
                else {
                    completionHandler(nil)
                }
            }
        }
        else {
            completionHandler(nil)
        }
    }
    
    //When a location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            self.currentLatitude = lat;
            self.currentLongitude = long;
            print("latitude: \(self.currentLatitude ?? 0.0), longitude: \(self.currentLongitude ?? 0.0)")
            
            //convert latitude and longitude to placemark
            lookUpCurrentLocation { placemark in
                print("\(placemark?.name ?? "unknown name"), \(placemark?.locality ?? "unknown locality")")
            }
        }
        else {
            print("No coordinates")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fail with error");
    }

}
