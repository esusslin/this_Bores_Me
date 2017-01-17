//
//  postMapVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/16/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Parse
import Mapbox
import CoreLocation

class postMapVC: UIViewController, MGLMapViewDelegate {
    
    //arrays to hold information from server
    
    var annotations: [picAnnotation] = []
    
    @IBOutlet var mapView: MGLMapView!
    
    var latitude = Double?()
    var longitude = Double?()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // find posts
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) in
            
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
                    
                    self.mapView.addAnnotations(self.annotations)
                    
                    self.centerMap()

                    
                }
                
                
            }
        })
        
        
        mapView.delegate = self
//        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: (self.latitude!), longitude: (self.latitude!)), zoomLevel: 6, animated: true)
        
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backBtn

        // Do any additional setup after loading the view.
    }
    
    func centerMap() {
        
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        self.mapView.tintColor = UIColor.darkGrayColor()
        
        print(self.latitude!)
        print(self.longitude!)
        
       
        self.mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 37.7879224062377, longitude: -122.407503426075), zoomLevel: 10, animated: true)
        
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
    

    // go back function
    func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewControllerAnimated(true)
        
   
    }


}
