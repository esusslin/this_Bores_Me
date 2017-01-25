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
   

    @IBOutlet weak var bored1Btn: UIButton!
    @IBOutlet weak var bored2Btn: UIButton!
    @IBOutlet weak var bored3Btn: UIButton!
    
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    
    
    
//    //labels

    @IBOutlet weak var boredscoreLbl: UILabel!
    @IBOutlet weak var titleLbl: KILabel!
  
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        
        // clear like button title color
        bored3Btn.setTitleColor(UIColor.clearColor(), forState: .Normal)
        bored2Btn.setTitleColor(UIColor.clearColor(), forState: .Normal)
        bored1Btn.setTitleColor(UIColor.clearColor(), forState: .Normal)
       
        
        updateBoredScore()
        
        print(bored3Btn.titleLabel!.text!)
               
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
        bored3Btn.translatesAutoresizingMaskIntoConstraints = false
        bored2Btn.translatesAutoresizingMaskIntoConstraints = false
        bored1Btn.translatesAutoresizingMaskIntoConstraints = false
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        boredscoreLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let pictureWidth = width - 20
        
        
        //VERTICAL CONSTRAINTS
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[ava(30)]-10-[pic(\(pictureWidth))]-5-[like(30)]"
            , options: [], metrics: nil, views: ["ava":avatarImage, "pic":picImg, "like":bored3Btn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[username]", options: [], metrics: nil, views: ["username":usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pic]-5-[comment(35)]", options: [], metrics: nil, views: ["pic":picImg, "comment":commentBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[date]", options: [], metrics: nil, views: ["date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[like3]-5-[title]-5-|", options: [], metrics: nil, views: ["like3":bored3Btn, "title":titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[like2]-5-[title]-5-|", options: [], metrics: nil, views: ["like2":bored2Btn, "title":titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[like1]-5-[title]-5-|", options: [], metrics: nil, views: ["like1":bored1Btn, "title":titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pic]-5-[more(30)]", options: [], metrics: nil, views: ["pic":picImg, "more":moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pic]-10-[likes]", options: [], metrics: nil, views: ["pic":picImg, "likes":boredscoreLbl]))
        
        
        // HORIZONTAL CONSTRAINTS
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[ava(30)]-10-[username]", options: [], metrics: nil, views: ["ava":avatarImage, "username":usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[pic]-10-|", options: [], metrics: nil, views: ["pic":picImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[likes]-40-[like3(32)]-40-[like2(24)]-40-[like1(20)]-50-[comment(35)]", options: [], metrics: nil, views: ["likes":boredscoreLbl, "like3":bored3Btn, "like2":bored2Btn, "like1":bored1Btn,  "comment":commentBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[more(30)]-15-|", options: [], metrics: nil, views: ["more":moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[title]-15-|", options: [], metrics: nil, views: ["title":titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[date]-10-|", options: [], metrics: nil, views: ["date":dateLbl]))
        
        
        //round avatar - always
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
    }
    
    // double tap to like
    func likeTap() {
        
        if self.bored1Btn.titleLabel?.text == "bored1" || self.bored2Btn.titleLabel?.text == "bored2" {
            let query = PFQuery(className: "boreds")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            print("no longer bored!")
                            
                            self.updateBoredScore()
                        
                            self.bored1Btn.setTitle("blank1", forState: .Normal)
                            self.bored1Btn.setBackgroundImage(UIImage(named: "grey1"), forState: .Normal)
                            
                            self.bored2Btn.setTitle("blank2", forState: .Normal)
                            self.bored2Btn.setBackgroundImage(UIImage(named: "grey2"), forState: .Normal)
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("blank2", object: nil)
                            
                            
                            // delete like notification
                            let news1Query = PFQuery(className: "news")
                            news1Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news1Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news1Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news1Query.whereKey("type", equalTo: "bored1")
                            news1Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                                if error == nil {
                                    for object in objects! {
                                        object.deleteEventually()
                                    }
                                }
                            })
                            
                            let news2Query = PFQuery(className: "news")
                            news2Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news2Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news2Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news2Query.whereKey("type", equalTo: "bored2")
                            news2Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
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
        
        let title = bored3Btn.titleForState(.Normal)
        
        if title == "blank3" {
            
            let object = PFObject(className: "boreds")
            object["by"] = PFUser.currentUser()?.username
            object["to"] = uuidLbl.text
            object["score"] = 3
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    print("bored3!")
                    self.bored3Btn.setTitle("bored3", forState: .Normal)
                    self.bored3Btn.setBackgroundImage(UIImage(named: "red3"), forState: .Normal)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("bored3", object: nil)
                    
                    // count bored score
                    let countBoreds = PFQuery(className: "boreds")
                    countBoreds.whereKey("to", equalTo: self.uuidLbl.text!)
                    countBoreds.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
                        
                        if error == nil {
                            
                            var sum = 0
                            
                            for me in objects! {
                                sum += me.objectForKey("score") as! Int
                                
                            }
                            self.boredscoreLbl.text = "\(sum)"
                            
                        }
                        
                    })

                    
                    // send boredom notification
                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.currentUser()?.username
                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "bored3"
                        newsObj["checked"] = "no"
                        print(newsObj["checked"])
                        newsObj.saveEventually()
                    }
                }
            })
            
        }
    }
    
    
    // click bored 3x button
    @IBAction func bored3Btn_click(sender: AnyObject) {
        
        print("bored3 pressed")
        
        
        if self.bored1Btn.titleLabel?.text == "bored1" || self.bored2Btn.titleLabel?.text == "bored2" {
            let query = PFQuery(className: "boreds")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            
                            self.updateBoredScore()
                            print("no longer bored!")
                            self.bored1Btn.setTitle("blank1", forState: .Normal)
                            self.bored1Btn.setBackgroundImage(UIImage(named: "grey1"), forState: .Normal)
                            
                            self.bored2Btn.setTitle("blank2", forState: .Normal)
                            self.bored2Btn.setBackgroundImage(UIImage(named: "grey2"), forState: .Normal)
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("blank2", object: nil)
                            
                            
                            // delete like notification
                            let news1Query = PFQuery(className: "news")
                            news1Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news1Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news1Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news1Query.whereKey("type", equalTo: "bored1")
                            news1Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                                if error == nil {
                                    for object in objects! {
                                        object.deleteEventually()
                                    }
                                }
                            })
                            
                            let news2Query = PFQuery(className: "news")
                            news2Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news2Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news2Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news2Query.whereKey("type", equalTo: "bored3")
                            news2Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
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

        
        
        //declare title of button
        let title = sender.titleForState(.Normal)
        print(title!)
        // to like
        if title == "blank3" {
            
            let object = PFObject(className: "boreds")
            object["by"] = PFUser.currentUser()?.username
            object["score"] = 3
            object["to"] = uuidLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    print("bored3")
                    self.updateBoredScore()
                    
                    let likePic = UIImageView(image: UIImage(named: "zzz.png"))
                    likePic.frame.size.width = self.picImg.frame.size.width / 1.5
                    likePic.frame.size.height = self.picImg.frame.size.width / 1.5
                    likePic.center = self.picImg.center
                    likePic.alpha = 0.8
                    self.addSubview(likePic)
                    
                    // hide likePic with animation and transform to be smaller
                    
                    UIView.animateWithDuration(2) {
                        likePic.alpha = 0
                        likePic.transform = CGAffineTransformMakeScale(0.1, 0.1)
                    }
                    
                    self.updateBoredScore()
                    self.bored3Btn.setTitle("bored3", forState: .Normal)
                    self.bored3Btn.setBackgroundImage(UIImage(named: "red3"), forState: .Normal)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("bored3", object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.currentUser()?.username
                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "bored3"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            })
            
            // to dislike
        } else {
            
            print("bored3 else?")
            
            // request existing likes of current user to show post
            let query = PFQuery(className: "boreds")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {

                            self.updateBoredScore()
                            print("no longer bored!")
                            self.bored3Btn.setTitle("blank3", forState: .Normal)
                            self.bored3Btn.setBackgroundImage(UIImage(named: "grey3"), forState: .Normal)
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("blank3", object: nil)
                            
                            
                            // delete like notification
                            let newsQuery = PFQuery(className: "news")
                            newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            newsQuery.whereKey("type", equalTo: "bored3")
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
    
    
    
    // click bored 2x button
    @IBAction func bored2Btn_click(sender: AnyObject) {
        
         print("bored2 pressed")
        
        
        if self.bored1Btn.titleLabel?.text == "bored1" || self.bored3Btn.titleLabel?.text == "bored3" {
            let query = PFQuery(className: "boreds")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            
                           self.updateBoredScore()
                            print("no longer bored!")
                            self.bored1Btn.setTitle("blank1", forState: .Normal)
                            self.bored1Btn.setBackgroundImage(UIImage(named: "grey1"), forState: .Normal)
                            
                            self.bored3Btn.setTitle("blank3", forState: .Normal)
                            self.bored3Btn.setBackgroundImage(UIImage(named: "grey3"), forState: .Normal)
                            
                            
                            // delete like notification
                            let news1Query = PFQuery(className: "news")
                            news1Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news1Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news1Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news1Query.whereKey("type", equalTo: "bored1")
                            news1Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                                if error == nil {
                                    for object in objects! {
                                        object.deleteEventually()
                                    }
                                }
                            })
                            
                            let news3Query = PFQuery(className: "news")
                            news3Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news3Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news3Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news3Query.whereKey("type", equalTo: "bored3")
                            news3Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
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

        
        
        //declare title of button
        let title = sender.titleForState(.Normal)
        print(title!)
        // to like
        if title == "blank2" {
            
            print("bored2?")
            
            let object = PFObject(className: "boreds")
            object["by"] = PFUser.currentUser()?.username
            object["score"] = 2
            object["to"] = uuidLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    
                   self.updateBoredScore()
                    
                    let likePic = UIImageView(image: UIImage(named: "zzz.png"))
                    likePic.frame.size.width = self.picImg.frame.size.width / 1.5
                    likePic.frame.size.height = self.picImg.frame.size.width / 1.5
                    likePic.center = self.picImg.center
                    likePic.alpha = 0.8
                    self.addSubview(likePic)
                    
                    // hide likePic with animation and transform to be smaller
                    
                    UIView.animateWithDuration(2) {
                        likePic.alpha = 0
                        likePic.transform = CGAffineTransformMakeScale(0.1, 0.1)
                    }

                    
                    
                   self.updateBoredScore()
                    
                    print("bored2 saved")
                    self.bored2Btn.setTitle("bored2", forState: .Normal)
                    self.bored2Btn.setBackgroundImage(UIImage(named: "red2"), forState: .Normal)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("bored2", object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.currentUser()?.username
                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "bored2"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            })
            
            // to dislike
        } else {
            
            // request existing likes of current user to show post
            let query = PFQuery(className: "boreds")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            print("no longer bored!")
                            self.bored2Btn.setTitle("blank2", forState: .Normal)
                            self.bored2Btn.setBackgroundImage(UIImage(named: "grey2"), forState: .Normal)
                            
                           self.updateBoredScore()
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("blank2", object: nil)
                            
                            
                            // delete like notification
                            let newsQuery = PFQuery(className: "news")
                            newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            newsQuery.whereKey("type", equalTo: "bored2")
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

    
    
    
    
    // click bored 3x button
    @IBAction func bored1Btn_click(sender: AnyObject) {
        
         print("bored1 pressed")
        //declare title of button
        
        
        if self.bored2Btn.titleLabel?.text == "bored2" || self.bored3Btn.titleLabel?.text == "bored3" {
            let query = PFQuery(className: "boreds")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            print("no longer bored!")
                            
                           self.updateBoredScore()
                            self.bored2Btn.setTitle("blank2", forState: .Normal)
                            self.bored2Btn.setBackgroundImage(UIImage(named: "grey2"), forState: .Normal)
                            
                            self.bored3Btn.setTitle("blank3", forState: .Normal)
                            self.bored3Btn.setBackgroundImage(UIImage(named: "grey3"), forState: .Normal)
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("blank2", object: nil)
                            
                            
                            // delete like notification
                            let news2Query = PFQuery(className: "news")
                            news2Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news2Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news2Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news2Query.whereKey("type", equalTo: "bored2")
                            news2Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                                if error == nil {
                                    for object in objects! {
                                        object.deleteEventually()
                                    }
                                }
                            })
                            
                            let news3Query = PFQuery(className: "news")
                            news3Query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            news3Query.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            news3Query.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            news3Query.whereKey("type", equalTo: "bored3")
                            news3Query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
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
        
        let title = sender.titleForState(.Normal)
        // to like
        
         print(title!)
        
        if title == "blank1" {
            
            let object = PFObject(className: "boreds")
            object["by"] = PFUser.currentUser()?.username
            object["score"] = 1
            object["to"] = uuidLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                
                if success {
                    
                    let likePic = UIImageView(image: UIImage(named: "zzz.png"))
                    likePic.frame.size.width = self.picImg.frame.size.width / 1.5
                    likePic.frame.size.height = self.picImg.frame.size.width / 1.5
                    likePic.center = self.picImg.center
                    likePic.alpha = 0.8
                    self.addSubview(likePic)
                    
                    // hide likePic with animation and transform to be smaller
                    
                    UIView.animateWithDuration(2) {
                        likePic.alpha = 0
                        likePic.transform = CGAffineTransformMakeScale(0.1, 0.1)
                    }

                    
                    print("bored1")
                    self.bored1Btn.setTitle("bored1", forState: .Normal)
                    self.bored1Btn.setBackgroundImage(UIImage(named: "red1"), forState: .Normal)

                    self.updateBoredScore()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("bored1", object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.currentUser()?.username
                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "bored1"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            })
            
            // to dislike
        } else {
            print("bored 1 else??")
            // request existing likes of current user to show post
            let query = PFQuery(className: "boreds")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            print("no longer bored!")
                            self.bored1Btn.setTitle("blank1", forState: .Normal)
                            self.bored1Btn.setBackgroundImage(UIImage(named: "grey1"), forState: .Normal)
                            
                           self.updateBoredScore()
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("blank1", object: nil)
                            
                            
                            // delete like notification
                            let newsQuery = PFQuery(className: "news")
                            newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                            newsQuery.whereKey("type", equalTo: "bored3")
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
    
    func updateBoredScore() {
        
        print("bored score updated")
    // count bored score
    let countBoreds = PFQuery(className: "boreds")
    countBoreds.whereKey("to", equalTo: self.uuidLbl.text!)
    countBoreds.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
    
    if error == nil {
        
        print(objects?.count)
    
    var sum = 0
    
    for me in objects! {
    sum += me.objectForKey("score") as! Int
    
    }
    self.boredscoreLbl.text = "\(sum)"
    self.updatePostBoredScore(sum)

    }
    
    })
    }
    
    
    func updatePostBoredScore(num: Int) {
        
        print(num)
        
        print("update post's bored score")
        
//        self.reAnnoint()
        
        let countBoreds = PFQuery(className: "posts")
        countBoreds.whereKey("uuid", equalTo: self.uuidLbl.text!)
        countBoreds.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                let sum = 0
                
                for me in objects! {
                    
                    me["boredScore"] = num
                    
                    me.saveInBackground()
                    
                    
                }
                
            }
            
        })
    }
    
    
}




