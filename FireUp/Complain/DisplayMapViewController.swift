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
    }
    
    let regionRadius: CLLocationDistance = 5000
    
    func centerMapOnLocation(location: PFGeoPoint) {
        let TransferPoint: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(TransferPoint.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        ViewMap.setRegion(coordinateRegion, animated: true)
    }
    

    
}
