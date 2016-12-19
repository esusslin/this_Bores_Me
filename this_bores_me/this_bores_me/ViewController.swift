//
//  ViewController.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/10/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4



class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["email"]
            loginView.delegate = self
    
        
    }
   
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email", "public_profile"]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {

                    let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
                    FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, result, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        } else {
                           print(result)
                            let email = result.valueForKey("email") as? String!
                            let first = result.valueForKey("first_name") as? String!
                            let last = result.valueForKey("last_name") as? String!

                                if let picture = result.valueForKey("picture") as? NSDictionary, data = picture.valueForKey("data") as? NSDictionary, url = data.valueForKey("url") as? String {
                                    
                                    print(url)
                                    
                                    getImageFromURL(url, result: { (image) -> Void in
                                        
                                        let avatarData = UIImageJPEGRepresentation(image!, 0.5)
                                        
                                        let avaFile = PFFile(name: "ava.jpg", data: avatarData!)
                                        
                                        user["email"] = email
                                        
                                        user["firstname"] = first
                                        user["lastname"] = last
                                        user["email"] = email
                                        user["ava"] = avaFile
                                        // send executed information to the server
                                        
                                        user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) in
                                            if success {
                                                
                                                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                let vc = storyboard.instantiateViewControllerWithIdentifier("usernameVC") as! UIViewController
                                                
                                                
                                                self.presentViewController(vc, animated: true, completion: nil)
                                                
                                            } else {
                                                print(error!.localizedDescription)
                                            }
                                        })

                                        
                                    })
                                }
                                
                            
                        }
                        
                    })
//                
//                    if user.isNew {
//
//                    print("User signed up and logged in through Facebook!")
//                    
//                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewControllerWithIdentifier("usernameVC") as! UIViewController
//                    
//                    
//                    self.presentViewController(vc, animated: true, completion: nil)
//                    
//                } else {
//                    print("User logged in through Facebook!")
//                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewControllerWithIdentifier("usernameVC") as! UIViewController
//                    
//                    self.presentViewController(vc, animated: true, completion: nil)
//                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
            
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    
      }
    
}