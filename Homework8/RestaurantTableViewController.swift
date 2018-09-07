//
//  RestaurantTableViewController.swift
//  Homework8
//
//  Created by Antonio Bang on 9/6/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {


    // MARK: - Table view data source

    
    @IBOutlet var restaurantTableView: UITableView!
    
    private func loadSamples(){
        let image1 = UIImage(named: "ice-cream");
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Restaurant";
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
                RestaurantTableViewCell
                else {
                    fatalError("The dequeued cell is not an instance of RestaurantTableViewCell")
                }
        cell.restaurantName.text = "name";
        cell.restaurantImage.image = UIImage(named: "ice-cream");
        cell.restaurantAddress.text = "address goes here";

        return cell;
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        RestaurantViewController.apiCall();
    }
}
