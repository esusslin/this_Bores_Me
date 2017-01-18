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




class ViewController: UIViewController {
    

    @IBOutlet weak var signInBtn: FBSDKLoginButton!
    
    @IBOutlet weak var thisBoresMe: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lbl3: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        alignment()
        
        if FBSDKAccessToken.currentAccessToken() != nil {
                       print(FBSDKAccessToken.currentAccessToken())
            dispatch_async(dispatch_get_main_queue()) {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabbarVC") as! tabbarVC
                vc.selectedIndex = 1
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
        
        


    }
    
    func alignment() {
    
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[thisBoresMe]-10-[lbl2]-10-[lbl3]-10-[signIn]-10-|", options: [], metrics: nil, views: ["thisBoresMe":thisBoresMe, "lbl2":lbl2, "lbl3":lbl3, "signIn":signInBtn]))
        
        
        thisBoresMe.center.x = self.view.center.x
        
        lbl2.center.x = self.view.center.x
        
        lbl3.center.x = self.view.center.x
        
        signInBtn.center.x = self.view.center.x
        
        
    }
   
    @IBAction func signInBtn_click(sender: AnyObject) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email", "public_profile"]) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if error != nil {
                
                var myAlert = UIAlertController(title: "ALERT", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                var okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                return
            }
            
            print(user)
            print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
            
            if FBSDKAccessToken.currentAccessToken() != nil {
                
                self.setProfile()
                
                
                
            }
        }

    }
    
    func setProfile() {
        
        var requestParameters = ["fields": "id, email, first_name, last_name, picture.type(large)"]
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
            
            if(error != nil)
            {
                print("\(error.localizedDescription)")
                return
            }
            
            if(result != nil)
            {
                
                let userId = result.valueForKey("id") as? String!
                let email = result.valueForKey("email") as? String!
                let first = result.valueForKey("first_name") as? String!
                let last = result.valueForKey("last_name") as? String!
                
                
                print("\(email)")
                
                let user = PFUser.currentUser()!
                
                user["email"] = email
                
                user["firstname"] = first
                user["lastname"] = last
                user["email"] = email
                    
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
                    
                        user.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        
                            if(success)
                            {
                                print("User details are now updated")
                                
                                if ((PFUser.currentUser()?.objectForKey("usernameSet")) != nil) {
                                    
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabbarVC") as! tabbarVC
                                    vc.selectedIndex = 1
                                    
                                    self.presentViewController(vc, animated: true, completion: nil)
                                } else {
                                
                                let usernamePage = self.storyboard?.instantiateViewControllerWithIdentifier("usernameVC") as! usernameVC
                            
                                let protectedPageNav = UINavigationController(rootViewController: usernamePage)
                                
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            
                                appDelegate.window?.rootViewController = usernamePage

                            }
                            }
                        
                        })
                    
                    })
                    
                }
            }
            
        }
    }
    
}