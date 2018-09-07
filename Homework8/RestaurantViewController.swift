//
//  RestaurantViewController.swift
//  Homework8
//
//  Created by Antonio Bang on 9/5/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import UIKit

//TODO: Master Detail view
//Master: self Detail is Map view with user location to restaurant


class RestaurantViewController: UITableViewController, UISplitViewControllerDelegate {
    let latitude = 34.119193;
    let longitude = -118.112650;

    var restaurants = [Restaurant]();

    let myIndicator = MyIndicator();
    
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
    
    
    override func viewDidLoad() {
        myIndicator.callIndicator(controller: self);
        myIndicator.indicator.startAnimating();

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
        }
    }
    

}
