//
//  guestMapCell.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/16/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import Mapbox

class guestMapCell: UICollectionViewCell, MGLMapViewDelegate {
    
   

    @IBOutlet weak var mapView: MGLMapView!
    
    //default func
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.delegate = self
        
        centerMap()
        
        let width = UIScreen.mainScreen().bounds.width
        
//        mapView.frame = CGRectMake(0, 0, width / 3, width / 3)
    }
    
    
    func centerMap() {
        
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        //        self.mapView.tintColor = UIColor.darkGrayColor()
        
//        print(self.latitude!)
//        print(self.longitude!)
        
        
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
    
//    func mapView(mapView: MGLMapView, tapOnCalloutForAnnotation annotation: MGLAnnotation) {
//        // Optionally handle taps on the callout
//        print("Tapped the callout for: \(annotation.title)")
//        var uuid = (annotation.title!)! as String!
//        print(uuid)
//        
//        
//        postuuid.append(uuid!)
// 
//        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
//        self.navigationController?.pushViewController(post, animated: true)
//        
//        // Hide the callout
//        mapView.deselectAnnotation(annotation, animated: true)
//    }

    
    
    
    func mapView(mapView: MGLMapView, calloutViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        
        
        return testCalloutView(representedObject: annotation as! picAnnotation)
        
    }
    
    

    

}
