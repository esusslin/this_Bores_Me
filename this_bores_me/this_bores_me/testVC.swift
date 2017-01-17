//
//  testVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/16/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import Mapbox
import Parse
import CoreLocation

class testVC: UIViewController, MGLMapViewDelegate {
    
        var usernameArray = [String]()
        var avaArray = [PFFile]()
        var dateArray = [NSDate?]()
        var picArray = [PFFile]()
        var titleArray = [String]()
        var uuidArray = [String]()
    
        var annotations = [picAnnotation]()
    
        var followArray = [String]()
    
    @IBOutlet var mapView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPosts()

        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        // Initialize and add the marker annotation
//        let marker = picAnnotation()
//        marker.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//        marker.image = UIImage(named: "bored1")
//        marker.title = "Hello world!"
//        
//        annotations.append(marker)
        
        
//        self.mapView.addAnnotations(self.annotations)
        
//        addPins()
       
//        mapView.addAnnotation(marker)
    }
    
    func addPins() {
        
//        print(annotations[0].image)
//        print(annotations[1].image)
    
        mapView.addAnnotations(annotations)
        
    }
    
    // load posts
    func loadPosts() {
        
        print("hello?")
        
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
                            
                            
                            
                            
                            let location = object.objectForKey("coordinate")
                            
                            let latitude = location?.latitude!
                            let longitude = location?.longitude!
                            
                            
                            let picLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            
                            let pfPic = object.objectForKey("pic") as! PFFile
                            
                            let mark = picAnnotation()
                            mark.coordinate = picLocation
                            mark.title = "Hello world!"
                            
                            if let pfPic = object.objectForKey("pic") as? PFFile {
                                pfPic.getDataInBackgroundWithBlock {
                                    (data: NSData?, error: NSError?) -> Void in
                                    
                                    if error == nil {
                                        mark.image = UIImage(data: data!)
                                        
                                    }else{
                                        print("Error: \(error)")
                                    }
                                }
                            }
                            
                            print(mark.image?.size)
                            
                            self.annotations.append(mark)
                            
                            self.addPins()
                            
//                            self.mapView.addAnnotations(self.annotations)
                            
                            
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
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped
        return true
    }
    
    func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        

            return testCalloutView(representedObject: annotation as! picAnnotation)

    }
    
//    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        // Optionally handle taps on the callout
//        print("Tapped the callout for: \(annotation)")
//        
//        // Hide the callout
//        mapView.deselectAnnotation(annotation, animated: true)
//    }
//    
    
        func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
            // Hide the callout view.
            mapView.deselectAnnotation(annotation, animated: false)
    
//            let index = (self.annotations as NSArray).indexOfObject(annotation)
    
            
    
    //        print(annotations[index].toolId)
    //
    //
    //
    //        self.navigationController!.pushViewController(vc, animated: true)
    
        }
    
        func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
            // Optionally handle taps on the callout
            print("Tapped the callout for: \(annotation)")
    
           
    
            // Hide the callout
            mapView.deselectAnnotation(annotation, animated: true)
        }
    
    


}
