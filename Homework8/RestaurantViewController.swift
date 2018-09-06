//
//  RestaurantViewController.swift
//  Homework8
//
//  Created by Antonio Bang on 9/5/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    let latitude = 34.119193;
    let longitude = -118.112650;

    var restaurants = [String: String]();
    
    @IBAction func makeApiCall(_ sender: UIButton) {
        //Using Yelp API to find restaurants nearby
        let baseURL = "https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=\(self.latitude)&longitude=\(self.longitude)";

        //fetch restaurants nearby
        apiCall(baseURL);


        
    }

    func apiCall(_ baseURL: String) {
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
                        self.restaurants = Utils.parseJson(urlContent);

                        for (key, value) in self.restaurants {
                            print("\(key) \(value)")
                        }
                    }
                }

                task.resume();
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
