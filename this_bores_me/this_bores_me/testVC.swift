//
//  testVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/16/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import Mapbox

class testVC: UIViewController, MGLMapViewDelegate {
    
    
    @IBOutlet var mapView: MGLMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the map view‘s delegate property
        mapView.delegate = self
        
        // Initialize and add the marker annotation
        let marker = picAnnotation()
        marker.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        marker.image = UIImage(named: "bored1")
        marker.title = "Hello world!"
        
        // This custom callout example does not implement subtitles
        //marker.subtitle = "Welcome to my marker"
        
        // Add marker to the map
        mapView.addAnnotation(marker)
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped
        return true
    }
    
    func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        // Only show callouts for `Hello world!` annotation
        if annotation.respondsToSelector(Selector("title")) && annotation.title! == "Hello world!" {
            // Instantiate and return our custom callout view
            
            return testCalloutView(representedObject: annotation as! picAnnotation)
        }
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // Optionally handle taps on the callout
        print("Tapped the callout for: \(annotation)")
        
        // Hide the callout
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
//        func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
//            return UIButton(type: .DetailDisclosure)
//        }
//    
//    
//    
//        func mapView(mapView: MGLMapView, leftCalloutAccessoryViewForAnnotation annotation: picAnnotation) -> UIView? {
//    
//            let leftView = UIImageView(image: annotation.image as UIImage!)
//            leftView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//            leftView.layer.cornerRadius = leftView.frame.size.width / 2
//            leftView.layer.masksToBounds = true
//            leftView.clipsToBounds = true
//    
//            //round avatar - always
//    //        leftView.layer.cornerRadius = avatarImage.frame.size.width / 2
//    //        avatarImage.clipsToBounds = true
//            
//            return leftView
//            
//            
//        }
    
    
}
