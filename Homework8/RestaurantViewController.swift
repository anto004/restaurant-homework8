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

    var restaurants = [String]();
    var restaurantDictionary = [String: String]();
    
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
                        self.restaurantDictionary = Utils.parseJson(urlContent);

                        for (key, value) in self.restaurantDictionary {
                            self.restaurants.append(key);
                            
                            print("\(key) \(value)")
                        }
                    }
                }

                task.resume();
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Restaurant", for: indexPath);
        
        let name = restaurants[indexPath.row];
        let address = restaurantDictionary[name];
        
        if let cellLabel = cell.textLabel, let cellDetailLabel = cell.detailTextLabel {
            cellLabel.text = name;
            cellDetailLabel.text = address;
        }
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restaurnts With Yelp API"
    }

}
