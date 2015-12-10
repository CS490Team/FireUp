//
//  DisplayMapViewController.swift
//  Fire Up
//
//  Created by Kai Sun on 12/9/15.
//
//

import UIKit
import MapKit

class DisplayMapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var ViewMap: MKMapView!
    var DisplayLocation: PFGeoPoint = PFGeoPoint()

    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(DisplayLocation)
        self.ViewMap.delegate = self
        
        var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(DisplayLocation.latitude,DisplayLocation.longitude)
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Home"
        self.ViewMap.addAnnotation(objectAnnotation)
    }
    
    let regionRadius: CLLocationDistance = 5000
    
    func centerMapOnLocation(location: PFGeoPoint) {
        let TransferPoint: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(TransferPoint.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        ViewMap.setRegion(coordinateRegion, animated: true)
    }
}
