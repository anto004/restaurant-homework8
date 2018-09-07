//
//  MyIndicator.swift
//  Homework8
//
//  Created by Antonio Bang on 9/6/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import Foundation;
import UIKit;

class MyIndicator: NSObject {
    var indicator = UIActivityIndicatorView();


    func callIndicator(controller: UIViewController){
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        indicator.color = UIColor.orange;
        indicator.isOpaque = true;

        indicator.center = controller.view.center;
        controller.view.addSubview(indicator)
    }
    
}
