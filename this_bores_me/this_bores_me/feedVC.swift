
//
//  ViewController.swift
//  FEED
//
//  Created by Emmet Susslin on 12/19/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse

let cellId = "cellId"

class Post {
    var username: String?
    var statusText: String?
    var profileImageName: String?
    
    }

class FeedController: UICollectionViewController {
    
//    var posts = [Post]()
    
    var usernameArray = [String]()
    var avaArray = [PFFile?]()
    var dateArray = [NSDate?]()
    var picArray = [PFFile]()
    var titleArray = [String?]()
    var uuidArray = [String?]()
    
    var followArray = [String]()
    
    var refresher = UIRefreshControl()
    
    // page size
    var page : Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//
        navigationItem.title = "Boredom Bulletin"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        loadPosts()
        
    }
    
    // load posts
    func loadPosts() {
        
        // STEP 1. Find posts realted to people who we are following
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.followArray.append(object.objectForKey("followed") as! String)
                }
                
                // append current user to see own posts in feed
                self.followArray.append(PFUser.currentUser()!.username!)
                
                // STEP 2. Find posts made by people appended to followArray
                let query = PFQuery(className: "posts")
                query.whereKey("username", containedIn: self.followArray)
                print(self.followArray.count)
                query.limit = self.page
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.dateArray.removeAll(keepCapacity: false)
                        self.picArray.removeAll(keepCapacity: false)
                        
                        print(self.picArray.count)
                        self.titleArray.removeAll(keepCapacity: false)
                        self.uuidArray.removeAll(keepCapacity: false)
                        
                        // find related objects
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.dateArray.append(object.createdAt)
                            self.picArray.append(object.objectForKey("pic") as! PFFile)
                            print(self.picArray.count)
                            self.titleArray.append(object.objectForKey("title") as! String)
                            self.uuidArray.append(object.objectForKey("uuid") as! String)
                        }
                        
                        // reload tableView & end spinning of refresher
                        self.collectionView!.reloadData()
                        self.refresher.endRefreshing()
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    
    
    ////////////////////////////
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
        
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            if error == nil {
                feedCell.statusImageView.image = UIImage(data: data!)
            }
        }
        
//        var usernameArray = [String]()
//        var avaArray = [PFFile?]()
//        var dateArray = [NSDate?]()
//        var picArray = [PFFile]()
//        var titleArray = [String?]()
//        var uuidArray = [String?]()
        
        avaArray[indexPath.row]!.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) in
            if error == nil {
                feedCell.profileImageView.image = UIImage(data: data!)
            }
        }
        
        feedCell.nameLabel.text = usernameArray[indexPath.row]
        feedCell.statusTextView.text = titleArray[indexPath.row]
        
        
        return feedCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let statusText = titleArray[indexPath.row] {
            
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSizeMake(view.frame.width, rect.height + knownHeight + 24)
            
        }
        
        return CGSizeMake(view.frame.width, 500)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    ////////////////////////////
    
    
    
    
    
    
    
}

