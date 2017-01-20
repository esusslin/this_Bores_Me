//
//  locationVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/2/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit
import MapKit
import Parse
import Mapbox

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

var locationName: String?
var locationCity: String?
var locationState: String?
var locationCoordinates: CLLocationCoordinate2D?

class locationVC: UIViewController {
    
    var name: String?
    var city: String?
    var state: String?
    var coordinates: CLLocationCoordinate2D?
//    var coordinate:
    
    
    @IBOutlet weak var mapView: MKMapView!

    
    
    let locationManager = CLLocationManager()
    
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("searchTableVC") as! searchTableVC
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Find Location"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
        alignment()

        // Do any additional setup after loading the view.
    }
    
    func alignment() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height

        mapView.frame = CGRectMake(0, 0, width, height)
        

    }
    
    //NAV bar buttons
    
    @IBAction func save_pressed(sender: AnyObject) {
        
        
                locationName = self.name
                print(locationName)
                locationCity = self.city
                print(locationCity)
                locationState = self.state
                print(locationState)
                locationCoordinates = self.coordinates
                print(locationCoordinates)

                self.view.endEditing(true)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                //send notification to homeVC to be reloaded.
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
    }
    
    @IBAction func cancel_pressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

 
}

extension locationVC : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if let location = locations.first {
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}

extension locationVC: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        
        

        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        self.name = placemark.name
        self.city = placemark.locality
        self.state = placemark.administrativeArea
        self.coordinates = placemark.coordinate
        
        print(placemark)
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city)" + " " + "\(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

