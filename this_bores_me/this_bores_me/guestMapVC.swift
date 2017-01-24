//
//  guestMapVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/16/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox
import Parse
import CoreLocation


private let reuseIdentifier = "Cell"

class guestMapVC: UICollectionViewController {
    
//    self.collectionView?.backgroundColor = UIColor.whiteColor()
    
    var latitude = Double?()
    var longitude = Double?()
    
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    var annotations: [picAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background color
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        loadPosts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }
    
    func loadPosts() {
        
        print("load posts?")
        print(guestname.last!)
        
        //load posts
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = 25
        
        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {

                
                //find related objects
                for object in objects! {
                    
                    let location = object.objectForKey("coordinate")
                    
                    print(location)
                    
                    self.latitude = location?.latitude!
                    self.longitude = location?.longitude!
                    
                    print(self.longitude)
                    print(self.latitude)
                    
                    let uuid = object.objectForKey("uuid") as! String
                    
                    let picLocation = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                    
                    let pfPic = object.objectForKey("pic") as! PFFile
                    
                    
                    let marker = picAnnotation()
                    marker.coordinate = picLocation
                    marker.uuid = uuid
                    marker.title = uuid
                    if let pfPic = object.objectForKey("pic") as? PFFile {
                        pfPic.getDataInBackgroundWithBlock {
                            (data: NSData?, error: NSError?) -> Void in
                            
                            if error == nil {
                                marker.image = UIImage(data: data!)
                                
                            }else{
                                print("Error: \(error)")
                            }
                        }
                    }
                    
                    
                    self.annotations.append(marker)
                    
//                    self.mapView.addAnnotations(self.annotations)
//                    
//                    self.centerMap()
                  
//                    //hold pulled information in arrays
//                    
//                    self.uuidArray.append(object.valueForKey("uuid") as! String)
//                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width)
        return size
        
    }
    
    //cell config
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        self.registerClass(guestMapCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //define cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! guestMapCell
        
        cell.mapView.addAnnotations(annotations)
        
        return cell
    }
    
    //header config
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerVC
        
        //STEP 1. load data of guest
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestname.last!)
        infoQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                if objects!.isEmpty {
                    let alert = UIAlertController(title: "\(guestname.last!.uppercaseString)", message: "user does not exist", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                // find related to user
                for object in objects! {
                    header.usernameLbl.text = (object.objectForKey("username") as? String)?.uppercaseString
                    let avaFile : PFFile = (object.objectForKey("ava") as? PFFile)!
                    avaFile.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) in
                        header.avaImg.image = UIImage(data: data!)
                    })
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //        //Step 2. show if current user follows guest
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followQuery.whereKey("followed", equalTo: guestname.last!)
        followQuery.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) in
            
            if error == nil {
                
                if count == 0 {
                    header.button.setTitle("FOLLOW", forState: .Normal)
                    header.button.backgroundColor = UIColor.lightGrayColor()
                } else {
                    header.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    header.button.backgroundColor = UIColor.greenColor()
                }
            } else {
                print(error?.localizedDescription)
            }
        })
        
        //STEP 3. Count statistics
        //count posts
        
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestname.last!)
        posts.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) in
            if error == nil {
                
                header.boredScoreNum.text = "\(count)"
            } else {
                print(error?.localizedDescription)
            }
        })
        
        // count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("followed", equalTo: guestname.last!)
        followers.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            if error == nil {
                header.followersNum.text = "\(count)"
            }
        }
        
        // count total followed
        let followed = PFQuery(className: "follow")
        followed.whereKey("follower", equalTo: guestname.last!)
        followed.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) in
            if error == nil {
                header.followingNum.text = "\(count)"
            }
        }
        
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.boredScoreNum.userInteractionEnabled = true
        header.boredScoreNum.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followersNum.userInteractionEnabled = true
        header.followersNum.addGestureRecognizer(followersTap)
        
        // tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
        followingsTap.numberOfTapsRequired = 1
        header.followingNum.userInteractionEnabled = true
        header.followingNum.addGestureRecognizer(followingsTap)
        
        return header
        
    }
    
    // taped post label
    
    func postsTap() {
        if !picArray.isEmpty {
            
            let index = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }
    
    // tapped followers
    func followersTap() {
        
        user = guestname.last!
        
        show = "followers"
        
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap() {
        
        user = guestname.last!
        
        show = "following"
        
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    // go post
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        //navigate to post view controller
        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    
    
    // go back function
    func map(sender: UIBarButtonItem) {
        
        // go post
        let guestMap = self.storyboard?.instantiateViewControllerWithIdentifier("guestMapVC") as! guestMapVC
        self.navigationController?.pushViewController(guestMap, animated: true)
        
        
    }

}
