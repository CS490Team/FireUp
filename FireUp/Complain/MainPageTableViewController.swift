//
//  MainPageTableViewController.swift
//
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

var cache = NSCache()

class MainPageTableViewController: PFQueryTableViewController, CLLocationManagerDelegate{

    var MainPageData = NSDictionary()
    var filter = 0;
    let locationManager = CLLocationManager()
    var currentUserLocation = CLLocation()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.parseClassName = "feed"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 15
    }
    
    override func queryForTable() -> PFQuery! {
        //super.queryForTable()
        let queryForUser: PFQuery = PFQuery(className: "feed")
        queryForUser.includeKey("feeder")
        //queryForUser.includeKey("feeder.User_Profile_Picture")
        return queryForUser
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarItem()
        addLeftBarItem()
        self.navigationItem.hidesBackButton = true
        if(PFUser.currentUser() == nil){
            performSegueWithIdentifier("MainToLogin", sender: self)
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        currentUserLocation = CLLocation(latitude: lat, longitude: long)
    }
    
    func addRightBarItem(){
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarAction")
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func rightBarAction(){
        self.performSegueWithIdentifier("PostViewController", sender: self.navigationItem.rightBarButtonItem)
    }
    
    func addLeftBarItem(){
        let leftBarItem = UIBarButtonItem()
        leftBarItem.target = self
        leftBarItem.action = "leftBarAction"
        leftBarItem.title = "Filter"

        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func leftBarAction(){
        self.performSegueWithIdentifier("toFilter", sender: self.navigationItem.rightBarButtonItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainPageCell", forIndexPath: indexPath) as! MainPageTableViewCell
        cell.TheImage.frame = CGRectMake(0, 70, 320, 250)
        cell.TheImage.image = UIImage(named: "1421031790_Picture")
        //let photo: PFObject = self.objects[indexPath.row] as! PFObject

        cell.TheText.text = self.objects[indexPath.row].valueForKey("text")! as! String
        cell.TheImage.file = self.objects[indexPath.row].valueForKey("image")! as! PFFile
        
       // let UserID = self.objects[indexPath.row].valueForKey("feeder")
        let CUser = self.objects[indexPath.row].valueForKey("feeder") as! PFUser
        //let TQuery = PFUser.query()
        //TQuery.whereKey("objectId", equalTo: self.objects[indexPath.row].valueForKey("feeder"))
        let username:String = CUser.username as String
        cell.UserName.setTitle(username, forState: .Normal)
        cell.UserName.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //cell.thumbnailImage.file = self.objects[indexPath.row].valueForKey("image")! as! PFFile
        //cell.thumbnailImage.file = CUser.valueForKey("User_Profile_Picture")! as! PFFile
        cell.Username = username
        
        let ImageFile:PFFile = CUser.valueForKey("User_Profile_Picture") as! PFFile
        ImageFile.getDataInBackgroundWithBlock({
            (data:NSData!, error:NSError!) -> Void in
            if (error == nil){
                let TRImage = UIImage(data: data)
                cell.thumbnailImage.image = TRImage
                cell.thumbnailImage.layer.borderWidth = 1.0
                cell.thumbnailImage.layer.masksToBounds = false
                cell.thumbnailImage.layer.borderColor = UIColor.whiteColor().CGColor
                cell.thumbnailImage.layer.cornerRadius = cell.thumbnailImage.frame.size.width/2
                cell.thumbnailImage.clipsToBounds = true
            }
        })
        
        let share = self.objects[indexPath.row].valueForKey("locationShare")! as! Bool
        cell.share = share
        if(share){
            let descLocation: PFGeoPoint = self.objects[indexPath.row].valueForKey("location")! as! PFGeoPoint
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: descLocation.latitude, longitude: descLocation.longitude)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                let placeArray = placemarks! as [CLPlacemark]
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray[0]
                
                // Address dictionary
                
                let city = placeMark.addressDictionary!["City"] as? String
                let state = placeMark.addressDictionary!["State"] as? String
                let locationInfo:String = city! + ", " + state!
                cell.Location.hidden = false
                cell.Location.hidden = false
                cell.Location.setTitle(locationInfo, forState: .Normal)
                cell.LocationImage.setImage(UIImage(named: "map_blue"), forState: .Normal)
                cell.Location.setTitleColor(UIColor.blackColor(), forState: .Normal)
                
            })
        
        }else{
            cell.LocationImage.setImage(nil, forState: .Normal)
            cell.Location.hidden = true
            cell.Location.hidden = true
        }

        
        
        //print(cell.thumbnailImage.file)

        cell.TheImage.loadInBackground(nil)
        return cell
    }
    
    /*override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainPageCell", forIndexPath: indexPath) as! MainPageTableViewCell
        cell.reset()
    }*/
    
    /*override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainPageCell", forIndexPath: indexPath) as! MainPageTableViewCell
        if(!cell.share){
            cell.reset()
        }
    }*/
    

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let share = self.objects[indexPath.row].valueForKey("locationShare")! as! Bool
        /*
        var feedCity:String?
        var feedState:String?
        
        if(share){
        
            let feedLocation:PFGeoPoint = self.objects[indexPath.row].valueForKey("location")! as! PFGeoPoint
            let geoCoderT = CLGeocoder()

            let feedlocationCL = CLLocation(latitude: feedLocation.latitude, longitude: feedLocation.longitude)

            print("0")
            geoCoderT.reverseGeocodeLocation(feedlocationCL, completionHandler: { (placemarks, error) -> Void in
                let placeArray = placemarks! as [CLPlacemark]
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray[0]
                // Address dictionary
                feedCity = placeMark.addressDictionary!["City"] as? String
                feedState = placeMark.addressDictionary!["State"] as? String
                
            })
        }
        
        var currentUserCity:String?
        var currentUserState:String?
        
        let geoCoderCurrentUser = CLGeocoder()
        geoCoderCurrentUser.reverseGeocodeLocation(currentUserLocation, completionHandler: { (placemarks, error) -> Void in
            let placeArray = placemarks! as [CLPlacemark]
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray[0]
            
            // Address dictionary
            
            currentUserCity = placeMark.addressDictionary!["City"] as? String
            currentUserState = placeMark.addressDictionary!["State"] as? String

            
        })*/
        

        if(filter == 1){
            return 402
        }else if(filter == 2){
            if(!share){
                return 0
            }
        }else if(filter == 3){
            /*if(currentUserCity == feedCity && currentUserState == feedState && share){
                return 373
            }else{
                return 0
            }*/
            
        }else if(filter == 5){
            
        }else if(filter == 6){
            
        }else if(filter == 7){
            
        }

        return 402
    }
    
    /*
    var DestViewController : ViewProfile = segue.destinationViewController as! ViewProfile
    var DestViewController : ViewProfile = segue.destinationViewController as! ViewProfile
    DestViewController.usName = cell.UserName
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toComment"){
            let VC = segue.destinationViewController as! AddCommentsViewController
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! MainPageTableViewCell
            VC.TRImage = cell.TheImage.image
        }
        if(segue.identifier == "toProfile"){
            let VC = segue.destinationViewController as! ViewOtherUserProfileTableViewController
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! MainPageTableViewCell
            VC.TRImage = cell.TheImage.image
            VC.TRUsername = cell.Username
        }
        if(segue.identifier == "toRecipe"){
            let VC = segue.destinationViewController as! ViewRecipeTableViewController
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! MainPageTableViewCell
            VC.TRTitle = cell.TheText.text
            VC.TRImage = cell.TheImage.image
            VC.TRRecipe = self.objects[indexPath!.row].valueForKey("recipe")! as! String
        }
        if(segue.identifier == "toMapView1"){
            let VC = segue.destinationViewController as! DisplayMapViewController
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            VC.DisplayLocation = self.objects[indexPath!.row].valueForKey("location")! as! PFGeoPoint
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! MainPageTableViewCell
            VC.UserImage = cell.TheImage.image
            VC.Username = cell.Username
        }
        if(segue.identifier == "toMapView2"){
            let VC = segue.destinationViewController as! DisplayMapViewController
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            VC.DisplayLocation = self.objects[indexPath!.row].valueForKey("location")! as! PFGeoPoint
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! MainPageTableViewCell
            VC.UserImage = cell.TheImage.image
            VC.Username = cell.Username
        }
        
    }
    
    /*override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(identifier == "toMapView1" || identifier == "toMapView2"){
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            let share = self.objects[indexPath!.row].valueForKey("locationShare")! as! Bool
            if(!share){
                return false
            }
        }
        return true
    }*/
    
    func setAttributes(forPhoto: PFObject){
        let attributes = NSMutableDictionary()
        attributes.setValue(forPhoto.valueForKey("image"), forKey: "ImageFile")
        cache.setObject(attributes, forKey: getKeyStringForPhoto(forPhoto))
    }
    
    func getKeyStringForPhoto(forPhoto: PFObject) -> String{
        return "photo_" + forPhoto.objectId!
    }
    
    func getAttributesForPhoto(forPhoto: PFObject) -> NSDictionary?{
        return cache.objectForKey(getKeyStringForPhoto(forPhoto)) as? NSDictionary
    }
    
}