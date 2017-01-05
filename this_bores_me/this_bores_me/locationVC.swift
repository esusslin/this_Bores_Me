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

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class locationVC: UIViewController {
    
    var name: String?
    var city: String?
    var state: String?
    var coordinates: CLLocationCoordinate2D?
//    var coordinate:
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var selectBtn: UIButton!


    
    let locationManager = CLLocationManager()
    
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectBtn.hidden = true
        
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

    @IBAction func selectBtn_click(sender: AnyObject) {
        
        let upload = self.storyboard?.instantiateViewControllerWithIdentifier("uploadVC") as! uploadVC
        upload.locationName = self.name
        upload.locationCity = self.city
        upload.locationState = self.state
        upload.coordinates = self.coordinates
        
        self.navigationController?.pushViewController(upload, animated: true)
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
        
        selectBtn.hidden = false

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

