//
//  RestaurantViewController.swift
//  Homework8
//
//  Created by Antonio Bang on 9/5/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import UIKit

class RestaurantViewController: UITableViewController {
    let latitude = 34.119193;
    let longitude = -118.112650;

    var restaurants = [Restaurant]();
    
    @IBOutlet var restaurantTableView: UITableView!

    func apiCall() {
        //Using Yelp API to find restaurants nearby
        let baseURL = "https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=\(self.latitude)&longitude=\(self.longitude)";
        
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
                                self.restaurants.append(Restaurant(name: name, address: address, image: restaurantImage))
                            }
                        }
                        self.restaurantTableView.reloadData();
                    }
                }

                task.resume();
            }
            self.restaurantTableView.reloadData();
        }
    }
    
    
    override func viewDidLoad() {
        print("restaurant view controller");
        
        //fetch restaurants nearby
        apiCall();
        
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

        let restaurant = restaurants[indexPath.row];

        cell.restaurantName.text = restaurant.name;
        cell.restaurantImage.image = restaurant.image;
        cell.restaurantAddress.text = restaurant.address;

        return cell;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restaurants - Yelp API"
    }

}
