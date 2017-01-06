//
//  postCell.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class postCell: UITableViewCell {
    
//    // user stuff

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    
//    //main picture

    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var uuidLbl: UILabel!
    
    
//    //buttons
   
    @IBOutlet weak var boredBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    
    
//    //labels

    @IBOutlet weak var boredscoreLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // clear like button title color
        boredBtn.setTitleColor(UIColor.clearColor(), forState: .Normal)
        
        //double tap to like
        
        let likeTap = UITapGestureRecognizer(target: self, action: "likeTap")
        likeTap.numberOfTapsRequired = 2
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
        
        
        //alignment
        let width = UIScreen.mainScreen().bounds.width
        
        //allow constraints
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        picImg.translatesAutoresizingMaskIntoConstraints = false
        boredBtn.translatesAutoresizingMaskIntoConstraints = false
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        boredscoreLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let pictureWidth = width - 20
        
        
        //VERTICAL CONSTRAINTS
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ava(30)]-10-[pic(\(pictureWidth))]-5-[like(30)]"
            , options: [], metrics: nil, views: ["ava":avatarImage, "pic":picImg, "like":boredBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[username]", options: [], metrics: nil, views: ["username":usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pic]-5-[comment(35)]", options: [], metrics: nil, views: ["pic":picImg, "comment":commentBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[date]", options: [], metrics: nil, views: ["date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[like]-5-[title]-5-|", options: [], metrics: nil, views: ["like":boredBtn, "title":titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pic]-5-[more(30)]", options: [], metrics: nil, views: ["pic":picImg, "more":moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pic]-10-[likes]", options: [], metrics: nil, views: ["pic":picImg, "likes":boredscoreLbl]))
        
        
        // HORIZONTAL CONSTRAINTS
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[ava(30)]-10-[username]", options: [], metrics: nil, views: ["ava":avatarImage, "username":usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[pic]-10-|", options: [], metrics: nil, views: ["pic":picImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[like(30)]-10-[likes]-20-[comment(35)]", options: [], metrics: nil, views: ["like":boredBtn, "likes":boredscoreLbl, "comment":commentBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[more(30)]-15-|", options: [], metrics: nil, views: ["more":moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[title]-15-|", options: [], metrics: nil, views: ["title":titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[date]-10-|", options: [], metrics: nil, views: ["date":dateLbl]))
        
        
        //round avatar - always
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
    }
    
    // double tap to like
    func likeTap() {
        
        //create large sleepy face
        
        
        let likePic = UIImageView(image: UIImage(named: "zzz.png"))
        likePic.frame.size.width = picImg.frame.size.width / 1.5
        likePic.frame.size.height = picImg.frame.size.width / 1.5
        likePic.center = picImg.center
        likePic.alpha = 0.8
        self.addSubview(likePic)
        
        // hide likePic with animation and transform to be smaller
        
        UIView.animateWithDuration(2) {
            likePic.alpha = 0
            likePic.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }
        
        // delcare title of button
        
        let title = boredBtn.titleForState(.Normal)
        
        if title == "unlike" {
            
            let object = PFObject(className: "likes")
            object["by"] = PFUser.currentUser()?.username
            object["to"] = uuidLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    print("liked")
                    self.boredBtn.setTitle("like", forState: .Normal)
                    self.boredBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.currentUser()?.username
                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "like"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            })
            
        }
    }
    
    
    // click like button
    @IBAction func likeBtn_click(sender: AnyObject) {
        
        //declare title of button
        let title = sender.titleForState(.Normal)
        
        // to like
        if title == "unlike" {
            
            let object = PFObject(className: "likes")
            object["by"] = PFUser.currentUser()?.username
            object["to"] = uuidLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    print("liked")
                    self.boredBtn.setTitle("like", forState: .Normal)
                    self.boredBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.currentUser()?.username
                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "like"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            })
            
            // to dislike
        } else {
            
            // request existing likes of current user to show post
            let query = PFQuery(className: "likes")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            print("disliked")
                            self.boredBtn.setTitle("unlike", forState: .Normal)
                            self.boredBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
                            
                            
                            // delete like notification
                            let newsQuery = PFQuery(className: "news")
                            newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            newsQuery.whereKey("type", equalTo: "like")
                            newsQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                                if error == nil {
                                    for object in objects! {
                                        object.deleteEventually()
                                    }
                                }
                            })
                            
                            
                        }
                    })
                }
            })
            
        }
        
    }
    
}

