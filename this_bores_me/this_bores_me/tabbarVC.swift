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
var icons = UIImageView()
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
        icons.frame = CGRectMake(self.view.frame.size.width / 5 * 3 + 10, self.view.frame.size.height - self.tabBar.frame.size.height + 8, 20, 20)
        self.view.addSubview(icons)
        
//        // create corner
//        corner.frame = CGRectMake(icons.frame.origin.x, icons.frame.origin.y + icons.frame.size.height, 20, 14)
//        corner.center.x = icons.center.x
//        corner.image = UIImage(named: "corner")
//        corner.hidden = true
//        self.view.addSubview(corner)
//        

        
  
    
        self.view.addSubview(dot)
        
        
        // call function of all type of notifications
        query(["like"], image: UIImage(named: "music")!)
        query(["follow"], image: UIImage(named: "followIcon")!)
        query(["mention", "comment"], image: UIImage(named: "commentIcon")!)
        
        
//        // hide icons objects
//        UIView.animateWithDuration(1, delay: 8, options: [], animations: { () -> Void in
//            icons.alpha = 0
//            corner.alpha = 0
//            dot.alpha = 0
//            }, completion: nil)
        
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
                    
                    print(count)
                    self.placeIcon(image, text: "\(count)")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    
    // multiple icons
    func placeIcon (image:UIImage, text:String) {
        
//        print(image)
//        print(text)
        
        // create separate icon
        let view = UIImageView(frame: CGRectMake(0, 0, 35, 35))
        view.image = image
        icons.addSubview(view)
        
        // create label
        let label = UILabel(frame: CGRectMake(view.frame.size.width / 2, 0, 12, 12))
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        label.backgroundColor = UIColor(red: 251/255, green: 103/255, blue: 29/255, alpha: 1)
        label.text = text
        
        label.layer.cornerRadius = dot.frame.size.width / 2
        print(label)
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        view.addSubview(label)
        
//        // create dot
//        dot.frame = CGRectMake(self.view.frame.size.width / 5 * 3, self.view.frame.size.height - 5, 16, 16)
//        dot.center.x = self.view.frame.size.width / 5 * 3 + (self.view.frame.size.width / 5) / 2
//        dot.center.y = self.view.frame.size.height - 50
//        
//        dot.backgroundColor = UIColor(red: 251/255, green: 103/255, blue: 29/255, alpha: 1)
//        dot.layer.cornerRadius = dot.frame.size.width / 2
//        dot.hidden = true
        
        
//        
//        // update icons view frame
//        icons.frame.size.width = icons.frame.size.width + view.frame.size.width - 4
//        print(icons.contentSize)
//        icons.contentSize.width = icons.contentSize.width + view.frame.size.width - 4
////        icons.frame.origin.x = corner.frame.origin.x - view.frame.size.width / 3
//        icons.center.x = self.view.frame.size.width / 5 * 4 - (self.view.frame.size.width / 5) / 4
//        
//        // unhide elements
        corner.hidden = false
        dot.hidden = false
    }
    

    
}