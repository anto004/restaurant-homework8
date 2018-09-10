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
    
    let regionRadius: CLLocationDistance = 2000;
    
    var artwork: Artwork?;

    var restaurant: Restaurant?;
    
    var currentLocPlacemark: CLPlacemark?;
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        mapView.delegate = self;
        mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        lookUpCurrentLocation { (placemark) in
            self.currentLocPlacemark = placemark;
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear")
        if let segueRestaurant = restaurant, let segueArtwork = artwork{
            let restaurantLocation = CLLocation(latitude: segueRestaurant.latitude, longitude: segueRestaurant.longitude);
            
            centerMapOnLocation(location: restaurantLocation);
            mapView.addAnnotation(segueArtwork);
            
            if let currentArtwork = getCurrentArtwork(){
                mapView.addAnnotation(currentArtwork);
            }
        }
    }
    
    private func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func getCurrentArtwork() -> Artwork? {
        var artwork: Artwork?;
        if let cPlacemark = currentLocPlacemark, let cLatitude = self.currentLatitude, let cLongitude =
            self.currentLongitude {
            let location = CLLocationCoordinate2D(latitude: cLatitude, longitude: cLongitude);
            var address = cPlacemark.name! + " ";
            address += cPlacemark.locality! + " ";
            address += cPlacemark.administrativeArea! + " ";
            address += cPlacemark.postalCode!;
            artwork = Artwork(name: "I'm here", address: address, coordinate: location, image: UIImage(named: "my-app")!)
        }
        return artwork ?? nil;
        
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
                self.currentLocPlacemark = placemark;
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

extension MapNavigationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let artwork = annotation as? Artwork else {return nil};
        let identifier = "marker";
        var view: MKMarkerAnnotationView;
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = artwork;
            view = dequeuedView;
        }
        else {
            view = MKMarkerAnnotationView(annotation: artwork, reuseIdentifier: identifier);
            view.canShowCallout = true;
            view.calloutOffset = CGPoint(x: -5, y: 5);
            
            //To make only the accessory clickable
//            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
//                                                    size: CGSize(width: 30, height: 30)))
//            mapsButton.setBackgroundImage(artwork.image, for: UIControlState())
            
            let imageButton = UIButton(type: .detailDisclosure);
            imageButton.setBackgroundImage(artwork.image, for: UIControlState());
            
            view.rightCalloutAccessoryView = imageButton;
            
        }
        return view;
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let artwork = view.annotation as! Artwork;
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving];
        artwork.mapItem().openInMaps(launchOptions: launchOptions);
    }
}
