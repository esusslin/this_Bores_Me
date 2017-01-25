//
//  leaderBoredVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/22/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

class leaderBoredVC: UITableViewController {
    
    
    //UI objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var refresher = UIRefreshControl()
    
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [NSDate?]()
    var picArray = [PFFile]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    
  
    
    // page size
    var page : Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //automatic row height = dynamic cell
        self.navigationItem.title = "LEADERBORED"
        tableView.estimatedRowHeight = 450
        
        let mapBtn = UIBarButtonItem(title: "back", style: .Plain, target: self, action: #selector(leaderBoredVC.back(_:)))
        self.navigationItem.leftBarButtonItem = mapBtn
        
        //pull to refresh feed
        refresher.addTarget(self, action: #selector(feedVC.loadPosts), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)
        
        //recieve notificatoin from uploadVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(feedVC.uploaded(_:)), name: "uploaded", object: nil)
        
        // receive notification from postsCell if picture is liked to update tableview
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(feedVC.refresh), name: "liked", object: nil)
        
        // indicator's x(horizontal) center
        indicator.center.x = tableView.center.x
        
        loadTopPosts()
    }
    
    // refreshign function after like to update degit
    func refresh() {
        tableView.reloadData()
    }
    
//    //reload function
//    func uploaded(notification:NSNotification) {
//        loadTopPosts()
//    }
    
    // load posts
    func loadTopPosts() {
        
//        let query = PFQuery(className: "boreds")
        
        
        let query = PFQuery(className: "posts")
        query.whereKey("boredScore", greaterThan: 6)
        query.addDescendingOrder("boredScore")

        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            
            print("********")
            print(objects?.count)
            print("********")
            
            // find related objects
            for object in objects! {
                
                print("********")
                print(object.objectForKey("boredScore"))
                print("********")
                
                
                self.usernameArray.append(object.objectForKey("username") as! String)
                self.avaArray.append(object.objectForKey("ava") as! PFFile)
                self.dateArray.append(object.createdAt)
                self.picArray.append(object.objectForKey("pic") as! PFFile)
                
                
                
                self.titleArray.append(object.objectForKey("title") as! String)
                self.uuidArray.append(object.objectForKey("uuid") as! String)
            }
            
            // reload tableView & stop animating indicator
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            
        })
        
    }
    
//    // scrolled down
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
//            loadMore()
//        }
//    }
//    
//    // pagination
//    func loadMore() {
//        
//        // if posts on the server are more than shown
//        if page <= uuidArray.count {
//            
//            // start animating indicator
//            indicator.startAnimating()
//            
//            // increase page size to load +10 posts
//            page = page + 10
//            
//            // STEP 1. Find posts realted to people who we are following
//            let query = PFQuery(className: "posts")
//            query.orderByDescending("boredScore")
//            query.limit = page
//            query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
//                
//                
//                                           // find related objects
//                            for object in objects! {
//                                self.usernameArray.append(object.objectForKey("username") as! String)
//                                self.avaArray.append(object.objectForKey("ava") as! PFFile)
//                                self.dateArray.append(object.createdAt)
//                                self.picArray.append(object.objectForKey("pic") as! PFFile)
//                                
//                                
//                                
//                                self.titleArray.append(object.objectForKey("title") as! String)
//                                self.uuidArray.append(object.objectForKey("uuid") as! String)
//                            }
//                            
//                            // reload tableView & stop animating indicator
//                            self.tableView.reloadData()
//                            self.indicator.stopAnimating()
//
//            })
//            
//        }
    
//    }
    
    
    // cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    // cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
        
        // connect objects with our information from arrays
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], forState: UIControlState.Normal)
        cell.usernameBtn.sizeToFit()
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.titleLbl.text = "loller"
        //            titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        
        //         place profile picture
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            cell.avatarImage.image = UIImage(data: data!)
        }
        
        
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            cell.picImg.image = UIImage(data: data!)
        }
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        // logic what to show: seconds, minuts, hours, days or weeks
        if difference.second <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second > 0 && difference.minute == 0 {
            cell.dateLbl.text = "\(difference.second)s."
        }
        if difference.minute > 0 && difference.hour == 0 {
            cell.dateLbl.text = "\(difference.minute)m."
        }
        if difference.hour > 0 && difference.day == 0 {
            cell.dateLbl.text = "\(difference.hour)h."
        }
        if difference.day > 0 && difference.weekOfMonth == 0 {
            cell.dateLbl.text = "\(difference.day)d."
        }
        if difference.weekOfMonth > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth)w."
        }
        
        //color the bored buttons
        
        let didBored = PFQuery(className: "boreds")
        didBored.whereKey("by", equalTo: PFUser.currentUser()!.username!)
        didBored.whereKey("to", equalTo: cell.uuidLbl!.text!)
        didBored.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            
            if objects?.count == 0 {
                cell.bored3Btn.setTitle("blank3", forState: .Normal)
                cell.bored3Btn.setBackgroundImage(UIImage(named: "grey3"), forState: .Normal)
                cell.bored2Btn.setTitle("blank2", forState: .Normal)
                cell.bored2Btn.setBackgroundImage(UIImage(named: "grey2"), forState: .Normal)
                cell.bored1Btn.setTitle("blank1", forState: .Normal)
                cell.bored1Btn.setBackgroundImage(UIImage(named: "grey1"), forState: .Normal)
            } else {
                for me in objects! {
                    if me.objectForKey("score") as! Int == 3 {
                        cell.bored3Btn.setTitle("bored3", forState: .Normal)
                        cell.bored3Btn.setBackgroundImage(UIImage(named: "red3"), forState: .Normal)
                    } else if me.objectForKey("score") as! Int == 2 {
                        cell.bored2Btn.setTitle("bored2", forState: .Normal)
                        cell.bored2Btn.setBackgroundImage(UIImage(named: "red2"), forState: .Normal)
                    }  else if me.objectForKey("score") as! Int == 1 {
                        cell.bored1Btn.setTitle("bored1", forState: .Normal)
                        cell.bored1Btn.setBackgroundImage(UIImage(named: "red1"), forState: .Normal)
                    }
                    
                }
                
            }
            
        })
        
        
        
        // count bored score
        let countBoreds = PFQuery(className: "boreds")
        countBoreds.whereKey("to", equalTo: cell.uuidLbl.text!)
        countBoreds.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                var sum = 0
                
                for me in objects! {
                    sum += me.objectForKey("score") as! Int
                    
                }
                cell.boredscoreLbl.text = "\(sum)"
                
                let countBoreds = PFQuery(className: "posts")
                countBoreds.whereKey("uuid", equalTo: cell.uuidLbl.text!)
                countBoreds.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
                    
                    for me in objects! {
                        me["boredScore"] = sum
                        me.saveInBackground()
                    }
                    
                })

                
            }
            
        })
        
        
        
        // asign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        cell.commentBtn.layer.setValue(indexPath, forKey: "index")
        cell.moreBtn.layer.setValue(indexPath, forKey: "index")
        
        
        // @mention is tapped
        cell.titleLbl.userHandleLinkTapHandler = { label, handle, rang in
            var mention = handle
            mention = String(mention.characters.dropFirst())
            
            // if tapped on @currentUser go home, else go guest
            if mention.lowercaseString == PFUser.currentUser()?.username {
                let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
                self.navigationController?.pushViewController(home, animated: true)
            } else {
                guestname.append(mention.lowercaseString)
                let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
                self.navigationController?.pushViewController(guest, animated: true)
            }
        }
        
        //         #hashtag is tapped
        cell.titleLbl.hashtagLinkTapHandler = { label, handle, range in
            var mention = handle
            mention = String(mention.characters.dropFirst())
            hashtag.append(mention.lowercaseString)
            let hashvc = self.storyboard?.instantiateViewControllerWithIdentifier("hashtagsVC") as! hashtagsVC
            self.navigationController?.pushViewController(hashvc, animated: true)
        }
        
        return cell
    }
    
    // clicked username button
    @IBAction func usernameBtn_click(sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
        
        // if user tapped on himself go home, else go guest
        if cell.usernameBtn.titleLabel?.text == PFUser.currentUser()?.username {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameBtn.titleLabel!.text!)
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
    }
    
    
    // clicked comment button
    @IBAction func commentBtn_click(sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
        
        // send related data to global variables
        commentuuid.append(cell.uuidLbl.text!)
        commentowner.append(cell.usernameBtn.titleLabel!.text!)
        
        // go to comments. present vc
        let comment = self.storyboard?.instantiateViewControllerWithIdentifier("commentVC") as! commentVC
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    
    // clicked more button
    @IBAction func moreBtn_click(sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // call cell to call further cell date
        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
        
        
        // DELET ACTION
        let delete = UIAlertAction(title: "Delete", style: .Default) { (UIAlertAction) -> Void in
            
            // STEP 1. Delete row from tableView
            self.usernameArray.removeAtIndex(i.row)
            self.avaArray.removeAtIndex(i.row)
            self.dateArray.removeAtIndex(i.row)
            self.picArray.removeAtIndex(i.row)
            self.titleArray.removeAtIndex(i.row)
            self.uuidArray.removeAtIndex(i.row)
            
            // STEP 2. Delete post from server
            let postQuery = PFQuery(className: "posts")
            postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
            postQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if success {
                                
                                // send notification to rootViewController to update shown posts
                                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
                                
                                // push back
                                self.navigationController?.popViewControllerAnimated(true)
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            // STEP 2. Delete likes of post from server
            let likeQuery = PFQuery(className: "boreds")
            likeQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            likeQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            
            // STEP 3. Delete comments of post from server
            let commentQuery = PFQuery(className: "comments")
            commentQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            commentQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            
            // STEP 4. Delete hashtags of post from server
            let hashtagQuery = PFQuery(className: "hashtags")
            hashtagQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            hashtagQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
        }
        
        
        // COMPLAIN ACTION
        let complain = UIAlertAction(title: "Complain", style: .Default) { (UIAlertAction) -> Void in
            
            // send complain to server
            let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.currentUser()?.username
            complainObj["to"] = cell.uuidLbl.text
            complainObj["owner"] = cell.usernameBtn.titleLabel?.text
            complainObj.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
                } else {
                    self.alert("ERROR", message: error!.localizedDescription)
                }
            })
        }
        
        // CANCEL ACTION
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        
        // create menu controller
        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .ActionSheet)
        
        
        // if post belongs to user, he can delete post, else he can't
        if cell.usernameBtn.titleLabel?.text == PFUser.currentUser()?.username {
            menu.addAction(delete)
            menu.addAction(cancel)
        } else {
            menu.addAction(complain)
            menu.addAction(cancel)
        }
        
        // show menu
        self.presentViewController(menu, animated: true, completion: nil)
    }
    
    
    // alert action
    func alert (title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // go back function
    func back(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
