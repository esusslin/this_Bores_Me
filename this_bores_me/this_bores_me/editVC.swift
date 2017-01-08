//
//  editVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/7/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    //picker view
    
    var genderPicker : UIPickerView!
    let genders = ["male", "female"]
    
    var keyboard = CGRect()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a picker
        
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
        genderPicker.showsSelectionIndicator = true
        gender.inputView = genderPicker
        
        //check keyboard notifications - shown?
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(editVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(editVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(editVC.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(editVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avatarImage.userInteractionEnabled = true
        avatarImage.addGestureRecognizer(avaTap)
        
        alignment()
        
        //call information function
        information()



        // Do any additional setup after loading the view.
    }

    
    func alignment() {
        
        let width = self.view.frame.size.width
        let hieght = self.view.frame.size.height
        
        scrollView.frame = CGRectMake(0, 0, width, hieght)
        
        avatarImage.frame = CGRectMake(width / 4, 15, 170, 170)
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        username.frame = CGRectMake(10, 250, width - 20, 30)
        gender.frame = CGRectMake(10, 300, width - 20, 30)
        
    }
    
    func information() {
        
        let ava = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        ava.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            self.avatarImage.image = UIImage(data: data!)
        }
        
        username.text = PFUser.currentUser()?.username
        gender.text = PFUser.currentUser()?.objectForKey("gender") as? String
    }
    
    
    
    // KEYBOARD
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        UIView.animateWithDuration(0.4) {
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.4) {
            self.scrollView.contentSize.height = 0
        }
    }
    
    //NAV bar buttons
    
    @IBAction func save_pressed(sender: AnyObject) {
        
        
        let user = PFUser.currentUser()!
        user.username = username.text?.lowercaseString
        
        if gender.text!.isEmpty {
            user["gender"] = ""
        } else {
            user["gender"] = gender.text
        }
        
        let avaData = UIImageJPEGRepresentation(avatarImage.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        // send executed information to the server
        
        user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) in
            if success {
                
                self.view.endEditing(true)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                //send notification to homeVC to be reloaded.
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    @IBAction func cancel_pressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // func to call UIImagePickerController
    func loadImg (recognizer : UITapGestureRecognizer)  {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    //method to finalize actions w UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avatarImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // picker view methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // picker text numb
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    // picker text config
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    //picker did selected some value from it
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender.text = genders[row]
        self.view.endEditing(true)
    }
    
}

