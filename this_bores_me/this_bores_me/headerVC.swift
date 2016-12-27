//
//  headerVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/22/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class headerVC: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var boredScoreNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    @IBOutlet weak var followingNum: UILabel!
    
    @IBOutlet weak var boredScoreLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var realNameLbl: UILabel!
        
    @IBOutlet weak var editProfile: UIButton!
    
    
    override func awakeFromNib() {
        
        //alignment
        let width = UIScreen.mainScreen().bounds.width
        
        avaImg.frame = CGRectMake(width / 16, width / 16, width / 4, width / 4)
        
        boredScoreNum.frame = CGRectMake(width / 2.5, avaImg.frame.origin.y, 50, 30)
        followersNum.frame = CGRectMake(width / 1.7, avaImg.frame.origin.y, 50, 30)
        followingNum.frame = CGRectMake(width / 1.25, avaImg.frame.origin.y, 50, 30)
        
        boredScoreLbl.center = CGPointMake(boredScoreNum.center.x, boredScoreNum.center.y + 20)
        followersLbl.center = CGPointMake(followersNum.center.x, followersNum.center.y + 20)
        followingLbl.center = CGPointMake(followingNum.center.x, followingNum.center.y + 20)
        
//        editProfile.frame = CGRectMake(postsTitle.frame.origin.x, postsTitle.center.y + 20, width - postsTitle.frame.origin.x - 10, 30)
        editProfile.layer.cornerRadius = editProfile.frame.size.width / 50
        
        usernameLbl.frame = CGRectMake(avaImg.frame.origin.x, avaImg.frame.origin.y + avaImg.frame.size.height, width - 20, 20)
 
        // round avatar
         avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
         avaImg.clipsToBounds = true
        
    }
    
    //clicked follow button
    
//    @IBAction func followBtn_clicked(sender: AnyObject) {
//        
//        print("follow button clicked")
//        
//        let title = button.titleForState(.Normal)
//        
//        if title == "FOLLOW" {
//            let object = PFObject(className: "follow")
//            object["follower"] = PFUser.currentUser()?.username
//            object["followed"] = guestname.last!
//            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
//                
//                if success {
//                    self.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
//                    self.button.backgroundColor = UIColor.greenColor()
//                    
//                    let newsObj = PFObject(className: "news")
//                    newsObj["by"] = PFUser.currentUser()?.username
//                    newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
//                    newsObj["to"] = guestname.last
//                    newsObj["owner"] = ""
//                    newsObj["uuid"] = ""
//                    newsObj["type"] = "follow"
//                    newsObj["checked"] = "no"
//                    newsObj.saveEventually()
//                    
//                    
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
//            
//            //unfollow
//        } else {
//            let query = PFQuery(className: "follow")
//            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
//            query.whereKey("followed", equalTo: guestname.last!)
//            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
//                if error == nil {
//                    for object in objects! {
//                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) in
//                            if success {
//                                self.button.setTitle("FOLLOW", forState: UIControlState.Normal)
//                                self.button.backgroundColor = UIColor.lightGrayColor()
//                                
//                                // delete follow notification
//                                let newsQuery = PFQuery(className: "news")
//                                newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
//                                newsQuery.whereKey("to", equalTo: guestname.last!)
//   
//                             newsQuery.whereKey("type", equalTo: "follow")
//                                newsQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                                    if error == nil {
//                                        for object in objects! {
//                                            object.deleteEventually()
//                                        }
//                                    }
//                                })
//                                
//                                
//                            } else {
//                                print(error?.localizedDescription)
//                            }
//                            
//                        })
//                    }
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
//        }
//        
//        
//        
//    }

}
