//
//  ViewController.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/10/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = PFObject(className: "testObject")
        object["name"] = "bill"
        object["lastname"] = "Alexander"
        object.saveInBackgroundWithBlock { (done:Bool, error:NSError?) in
            
            if done {
                print("saved in server")
            } else {
                print(error)
            }
        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

