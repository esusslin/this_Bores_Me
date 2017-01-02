//
//  usernameVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/11/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class usernameVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var welcomeTxt: UILabel!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let avaQuery = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        avaQuery.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            self.avatarImg.image = UIImage(data: data!)
        }
        
        self.nameTxt.text = (PFUser.currentUser()?.objectForKey("firstname") as? String)?.uppercaseString
        
        signupBtn.layer.cornerRadius = signupBtn.frame.size.width / 50
        // round avatar
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width / 2
        avatarImg.clipsToBounds = true
        
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avaTap.numberOfTapsRequired = 1
        avatarImg.userInteractionEnabled = true
        avatarImg.addGestureRecognizer(avaTap)
    }
    

    func loadImg(recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)

        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avatarImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // hide keyboard if tapped
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func alert (error: String, message : String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupBtn_click(sender: AnyObject) {
        
        print("1")
        
        if usernameTxt.text!.isEmpty {
            alert("USERNAME", message: "please create a username")
            return
        } else {
        
        let user = PFUser.currentUser()!
        user.username = usernameTxt.text?.lowercaseString
        let avaData = UIImageJPEGRepresentation(avatarImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        user["usernameSet"] = true
        
        // send executed information to the server
        
        user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) in
            if success {
                
                print("3")
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabVC") as! tabbarVC
                vc.selectedIndex = 1
                
                self.presentViewController(vc, animated: true, completion: nil)
                
            } else {
                print(error!.localizedDescription)
            }
        })

        }

        
    }




}
