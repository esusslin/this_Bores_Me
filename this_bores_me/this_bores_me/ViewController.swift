//
//  ViewController.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/10/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Bolts
import Parse
import FBSDKCoreKit
import FBSDKLoginKit



class ViewController: UIViewController {
    
    let permissions = ["public_profile"]
    
    var userId: String?
    var userFirstName:String?
    var userLastName:String?
    var userEmail:String?


    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            print("loller")
        }
        
    }
        
    
    }




