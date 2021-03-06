//
//  tabbarVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

// global variables of icons
var icons = UIScrollView()
var corner = UIImageView()
var dot = UIView()


class tabbarVC: UITabBarController {
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of item
        self.tabBar.tintColor = .whiteColor()
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
        
        // disable translucent
        self.tabBar.translucent = false
        
        // create total icons
        icons.frame = CGRectMake(self.view.frame.size.width / 5 * 3 + 10, self.view.frame.size.height - self.tabBar.frame.size.height * 2 - 3, 50, 35)
        icons.layer.cornerRadius = icons.frame.size.width / 10
        self.view.addSubview(icons)
        
        
        // call function of all type of notifications
        query(["like"], image: UIImage(named: "boredicon")!)
        query(["follow"], image: UIImage(named: "followicon")!)
        query(["mention", "comment"], image: UIImage(named: "commenticon")!)
        
        

        
    }
    
    
    // multiple query
    func query (type:[String], image:UIImage) {
        
        let query = PFQuery(className: "news")
        query.whereKey("to", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("checked", equalTo: "no")
        query.whereKey("type", containedIn: type)
        query.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                if count > 0 {
                    self.placeIcon(image, text: "\(count)")
                    self.tabBar.tintColorDidChange()
                   self.tabBar.tintColor = UIColor(red: 0.0 / 255.0, green: 199.0 / 255.0, blue: 140.0 / 255.0, alpha: 1)
                }
            } else {
//                self.tabBar.barTintColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
                self.tabBar.tintColor = .whiteColor()
                print(error!.localizedDescription)
            }
        })
    }
    
    
    // multiple icons
    func placeIcon (image:UIImage, text:String) {
        
        // create separate icon
        let view = UIImageView(frame: CGRectMake(icons.contentSize.width, 0, 50, 35))
        view.image = image
        view.layer.cornerRadius = view.frame.size.width / 10
        icons.addSubview(view)
        
        // create label
        let label = UILabel(frame: CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height))
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.text = text
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        view.addSubview(label)
        
        // update icons view frame
        icons.frame.size.width = icons.frame.size.width + view.frame.size.width - 4
        icons.contentSize.width = icons.contentSize.width + view.frame.size.width - 4
        icons.center.x = self.view.frame.size.width / 5 * 4 - (self.view.frame.size.width / 5) / 4
//       icons.layer.cornerRadius = icons.frame.size.width / 10
        
        // unhide elements
        corner.hidden = false
        dot.hidden = false
    }
    
    
    // clicked upload button (go to upload)
    func upload(sender : UIButton) {
        self.selectedIndex = 2
    }
    
}

