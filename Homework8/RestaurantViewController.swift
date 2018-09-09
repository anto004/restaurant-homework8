//
//  RestaurantViewController.swift
//  Homework8
//
//  Created by Antonio Bang on 9/5/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import UIKit;
import CoreLocation;

//TODO: Master Detail view
//Master: self Detail is Map view with user location to restaurant


class RestaurantViewController: UITableViewController, UISplitViewControllerDelegate {
    var currentLatitude: Double?;
    
    var currentLongitude: Double?;

    var restaurants = [Restaurant]();

    var currentRestaurant: Restaurant?;

    let myIndicator = MyIndicator();
    
    var locationManager = CLLocationManager()
    
    let group = DispatchGroup();
    
    @IBOutlet var restaurantTableView: UITableView!

    func apiCall() {
        if let latitude = currentLatitude, let longitude = currentLongitude {
            self.myIndicator.callIndicator(controller: self);
            self.myIndicator.indicator.startAnimating();
            
            //Using Yelp API to find restaurants nearby
            let baseURL = "https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=\(latitude)&longitude=\(longitude)";
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let url = URL(string: baseURL){
                    let session = URLSession.shared;
                    
                    let request = NSMutableURLRequest(url: url);
                    request.httpMethod = "GET";
                    
                    let token = "Bearer ssrhCpzL11gRI-IHI4sMw9gT09tSMSxnJQdhcRs5jtEIY8tp6j8zV0YAZWsyuUCWeSw4MGRcN_828M-8I7Lu2J2cHlOqf1iOvRBww90RTAEZnsa7ZqPssg8_H1yQW3Yx";
                    
                    request.setValue(token, forHTTPHeaderField: "Authorization");
                    
                    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                        if error != nil {
                            print("error: \(error!)")
                            return;
                        }
                        
                        if let urlContent = data {
                            //Parse Data
                            let restaurantsArray = Utils.parseJson(urlContent);
                            
                            for restaurant in restaurantsArray{
                                //Get restaurant image
                                var restaurantImage = UIImage();
                                if let imageUrl = restaurant.imageUrl, let url = URL(string: imageUrl) {
                                    let imageContent = try? Data(contentsOf: url);
                                    
                                    if let imageData = imageContent {
                                        if let image = UIImage(data: imageData){
                                            restaurantImage = image;
                                        }
                                    }
                                }
                                //Create new Restaurant object with image
                                if let name = restaurant.name, let address = restaurant.address{

                                    self.restaurants.append(Restaurant(name: name, address: address, image: restaurantImage,
                                            latitude: restaurant.latitude, longitude: restaurant.longitude));
                                }
                            }
                            DispatchQueue.main.sync {
                                self.restaurantTableView.reloadData();
                                self.myIndicator.indicator.stopAnimating();
                            }
                            
                        }
                    }
                    
                    task.resume();
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        
        getCurrentLocation();
    }
    
    private func getCurrentLocation(){
        group.enter();
        DispatchQueue.global(qos: .userInitiated).async {
            self.locationManager.requestLocation();
            self.group.wait(); //Wait for retrieving the current location
            
            DispatchQueue.main.sync {
                //fetch restaurants nearby
                self.apiCall();
            }
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Restaurant";
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
                RestaurantTableViewCell
                else {
                    fatalError("The dequeued cell is not an instance of RestaurantTableViewCell")
                }

        currentRestaurant = restaurants[indexPath.row];

        if let restaurant = currentRestaurant {
            cell.restaurantName.text = restaurant.name;
            cell.restaurantImage.image = restaurant.image;
            cell.restaurantAddress.text = restaurant.address;
        }

        return cell;
    }
    
    
     // MARK: - Navigation
    
    override func awakeFromNib() {
        super.awakeFromNib();
        splitViewController?.delegate = self;
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapNavigationViewController {
            destination.title = "Let's get you there!"
            
            if let restaurantClicked = sender as? RestaurantTableViewCell {
                for restaurant in restaurants {
                    if restaurantClicked.restaurantName.text! == restaurant.name!{
                        let restaurantLocation = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
                        destination.currentLatitude = currentLatitude;
                        destination.currentLongitude = currentLongitude;
                        destination.restaurant = restaurant;
                        
                        if let name = restaurant.name, let address = restaurant.address{
                            destination.artwork = Artwork(name: name,
                                                          address: address, coordinate: restaurantLocation);
                        }
                        
                    }
                }
            }
        }
    }
}

extension RestaurantViewController: CLLocationManagerDelegate {
    //When a location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            self.currentLatitude = lat;
            self.currentLongitude = long;
            print("RVC current latitude: \(self.currentLatitude ?? 0.0 ), longitude: \(self.currentLongitude ?? 0.0)")
        }
        else {
            print("No coordinates")
        }
        group.leave();
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Fail with error");
    }
    
}
