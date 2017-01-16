//
//  mapSearchVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/12/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox
import Parse
import CoreLocation


class mapSearchVC: UIViewController, MGLMapViewDelegate {
    
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [NSDate?]()
    var picArray = [PFFile]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    var followArray = [String]()
    
    var annotations: [picAnnotation] = []
    
    
    @IBOutlet var mapView: MGLMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLocation = locationManager.location
        
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.tintColor = UIColor.darkGrayColor()
        
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: (currentLocation!.coordinate.latitude), longitude: (currentLocation!.coordinate.longitude)), zoomLevel: 12, animated: false)
        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        
       
        //title at the top
        self.navigationItem.title = "Bored Map"
        
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: .Plain, target: self, action: #selector(mapSearchVC.back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        loadPosts()

        // Do any additional setup after loading the view.
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
                    print(self.followArray.count)
                }
                
                // append current user to see own posts in feed
                self.followArray.append(PFUser.currentUser()!.username!)
                
                // STEP 2. Find posts made by people appended to followArray
                let query = PFQuery(className: "posts")
                query.whereKey("username", containedIn: self.followArray)
                query.limit = 10
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.dateArray.removeAll(keepCapacity: false)
                        self.picArray.removeAll(keepCapacity: false)
                        self.titleArray.removeAll(keepCapacity: false)
                        self.uuidArray.removeAll(keepCapacity: false)
                        
                        // find related objects
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.dateArray.append(object.createdAt)
                            self.picArray.append(object.objectForKey("pic") as! PFFile)
                            self.titleArray.append(object.objectForKey("title") as! String)
                            self.uuidArray.append(object.objectForKey("uuid") as! String)
                            
//                            print(object.objectForKey("coordinate"))
                            
                            
                            let location = object.objectForKey("coordinate")
                            
                            let latitude = location?.latitude!
                            let longitude = location?.longitude!

                            
                            let picLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            
                            let pfPic = object.objectForKey("pic") as! PFFile
                            
                            let marker = picAnnotation()
                            marker.coordinate = picLocation
                            
                            print(object.objectForKey("pic")!)

                            
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
                            
                            marker.title = ""

                            
                            self.annotations.append(marker)
                            
                            self.mapView.addAnnotations(self.annotations)
                            
                            print(picLocation)
                        }
                        
                        
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }


    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("bored")
        
        if annotationImage == nil {
            
            var image = UIImage(named: "healthy")!
            
            
            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pisa")
        }
        
        return annotationImage
    }
    


    
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped
        return true
    }
    

    
    func mapView(mapView: MGLMapView, calloutViewFor annotation: picAnnotation) -> UIView? {

        return customCalloutVC(representedObject: annotation)
        
        
        }
    
    
    
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .DetailDisclosure)
    }
    
    
    
    func mapView(mapView: MGLMapView, leftCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        
        let index = (self.annotations as NSArray).indexOfObject(annotation)
//        print(self.annotations.count)
//        print(self.annotations[0].image)
        
        let leftView = UIImageView(image: annotations[index].image as UIImage!)
        leftView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        leftView.layer.cornerRadius = leftView.frame.size.width / 2
        leftView.layer.masksToBounds = true
        leftView.clipsToBounds = true
        
        //round avatar - always
//        leftView.layer.cornerRadius = avatarImage.frame.size.width / 2
//        avatarImage.clipsToBounds = true
        
        return leftView
        
        
    }
    
    
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        mapView.deselectAnnotation(annotation, animated: false)
        
        let index = (self.annotations as NSArray).indexOfObject(annotation)
        
        print("BONER!")
        
//        print(annotations[index].toolId)
//        
//
//        
//        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        // Optionally handle taps on the callout
        print("Tapped the callout for: \(annotation)")
        
        annotation
        
        // Hide the callout
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    
    
    // go back function
    func back(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}



