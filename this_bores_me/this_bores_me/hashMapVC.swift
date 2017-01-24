//
//  mapVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/16/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox
import Parse
import CoreLocation

class hashMapVC: UIViewController, MGLMapViewDelegate {
    
     var annotations: [picAnnotation] = []
    
    var latitude = Double?()
    var longitude = Double?()
    
    var page : Int = 100
    
    // arrays to hold data from server
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var filterArray = [String]()
    
    
    @IBOutlet var mapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "#" + hashtag.last!
        

        mapView.delegate = self

        self.navigationItem.hidesBackButton = true
        let mapBtn = UIBarButtonItem(title: "back", style: .Plain, target: self, action: #selector(hashMapVC.back(_:)))
        self.navigationItem.leftBarButtonItem = mapBtn
        
//        loadHashtags()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func hashTag_tapped(sender: AnyObject) {
        loadHashtags()
        
    }
    
    
    // load hashtags function
    func loadHashtags() {
        
        // STEP 1. Find poss related to hashtags
        let hashtagQuery = PFQuery(className: "hashtags")
        hashtagQuery.whereKey("hashtag", equalTo: hashtag.last!)
        hashtagQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.filterArray.removeAll(keepCapacity: false)
                
                // store related posts in filterArray
                for object in objects! {
                    self.filterArray.append(object.valueForKey("to") as! String)
                }
                
                //STEP 2. Find posts that have uuid appended to filterArray
                let query = PFQuery(className: "posts")
                query.whereKey("uuid", containedIn: self.filterArray)
                query.limit = self.page
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.picArray.removeAll(keepCapacity: false)
                        self.uuidArray.removeAll(keepCapacity: false)
                        
                        print(objects?.count)
                        
                        // find related objects
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
                            
                            self.centerMap()
                            
                            self.mapView.addAnnotations(self.annotations)
                            
                        }
                        
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            } else {
                print(error?.localizedDescription)
            }
        })
        
    }


    func centerMap() {
        
            print("loller")

//        37.781297, -122.289743
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 37.781297, longitude: -122.289743), zoomLevel: 8, animated: true)
        
        //        self.mapView.selectAnnotation(mapView.annotations![0], animated: true)
        
        
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
    
    
    
    func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        
        
        return testCalloutView(representedObject: annotation as! picAnnotation)
        
    }
    
    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
        // Optionally handle taps on the callout
        print("Tapped the callout for: \(annotation.title)")
        var uuid = (annotation.title!)! as String!
        print(uuid)
        
        
        postuuid.append(uuid!)
        //
        //          navigate to post view controller
        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
        
        // Hide the callout
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    // go back function
    func back(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
