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
    
    @IBOutlet var ViewMap:MKMapView!
    @IBOutlet var theImage:UIImageView!
    @IBOutlet var theName:UIButton!
    
    
    var DisplayLocation: PFGeoPoint = PFGeoPoint()
    var UserImage:UIImage!
    var Username:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation(DisplayLocation)
        self.ViewMap.delegate = self
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(DisplayLocation.latitude,DisplayLocation.longitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = Username + "'s home"
        self.ViewMap.addAnnotation(objectAnnotation)
        
        
        theImage.image = UserImage
        theImage.layer.masksToBounds = false
        theImage.layer.borderColor = UIColor.whiteColor().CGColor
        theImage.layer.cornerRadius = theImage.frame.size.width/2
        theImage.clipsToBounds = true
        
        theName.setTitle(Username, forState: .Normal)
        theName.enabled = false
        theName.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
    }
    
    let regionRadius: CLLocationDistance = 5000
    
    func centerMapOnLocation(location: PFGeoPoint) {
        let TransferPoint: CLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(TransferPoint.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        ViewMap.setRegion(coordinateRegion, animated: true)
    }
}
