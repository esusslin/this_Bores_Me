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



class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    
    var userId: String?
    var userFirstName:String?
    var userLastName:String?
    var userEmail:String?


    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.readPermissions = ["email"]
        fbLoginButton.delegate = self
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            fetchProfile()
        }
        
          }

    func fetchProfile() {
        print("fetch profile")
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) in
            if error != nil {
                print(error)
                return
            }
            
            //send data to server to related columns
            
//            if let picture = result.valueForKey("picture") as? NSDictionary, data = picture.valueForKey("data") as? NSDictionary, url = data.valueForKey("url") as? String {
//                
//            }
            

            var url: String?
            let user = PFUser()
            var avaFile: UIImage?
//          
            user.email = result.valueForKey("email") as? String
            user["firstname"] = result.valueForKey("first_name") as? String
            user["lastname"] = result.valueForKey("last_name") as? String
            user.username = "dickface"
            
//            print(result.valueForKey("picture"))
            
            if let picture = result.valueForKey("picture") as? NSDictionary, data = picture.valueForKey("data") as? NSDictionary, url = data.valueForKey("url") as? String {
                
                getImageFromURL((url as? String)!, result: { (image) -> Void in
                    let avatarData = UIImageJPEGRepresentation(image!, 0.5)
                    let avaFile = PFFile(name: "ava.jpg", data: avatarData!)
                    user["ava"] = avaFile
                })
            }

            
//            user["ava"] = avaFile
            
            user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) in
                if success {
                    print("registered")
                    
                    // remember logged user
                    NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // call login func from AppDelegate class & open app
                    let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.login()
                    
                } else {
                    // show alert
                    let alert = UIAlertController(title: "Please", message: "fill in both fields", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }

        }
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("completed login")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
  

}


