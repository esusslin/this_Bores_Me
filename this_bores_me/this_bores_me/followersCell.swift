//
//  followersCell.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/5/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {
    

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //alignment
        
        let width = UIScreen.mainScreen().bounds.width
        
        avaImg.frame = CGRectMake(10, 10, width / 5.3, width / 5.3)
        usernameLbl.frame = CGRectMake(avaImg.frame.size.width + 20, width / 11.428, width / 3.2, 30)
        followBtn.frame = CGRectMake(width - width / 3.5 - 10, 30, width / 3.5, 30)
        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
    
    //clicked follow / unfollow
    
    @IBAction func followBtn_click(sender: AnyObject) {
        
        let title = followBtn.titleForState(.Normal)
        
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["followed"] = usernameLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    self.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    self.followBtn.backgroundColor = UIColor.greenColor()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            //unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("followed", equalTo: usernameLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                            if success {
                                self.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
                                self.followBtn.backgroundColor = UIColor.lightGrayColor()
                            } else {
                                print(error?.localizedDescription)
                            }
                            
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
        }
        
    }
}

