//
//  MainPageTableViewController.swift
//  Complain
//
//  Created by sunkai on 1/11/15.
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

var cache = NSCache()

class MainPageTableViewController: PFQueryTableViewController{

    var MainPageData = NSDictionary()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "timeline"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 15
        //self.imageKey
    }
    
    func loadData(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarItem()
        self.navigationItem.hidesBackButton = true
        if(PFUser.currentUser() == nil){
            performSegueWithIdentifier("MainToLogin", sender: self)
        }
    }
    
    func addRightBarItem(){
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarAction")
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func rightBarAction(){
        self.performSegueWithIdentifier("PostViewController", sender: self.navigationItem.rightBarButtonItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainPageCell", forIndexPath: indexPath) as MainPageTableViewCell
        cell.TheImage.frame = CGRectMake(0, 0, 320, 250)
        cell.TheImage.image = UIImage(named: "1421031790_Picture")
        let photo: PFObject = self.objects[indexPath.row] as PFObject
        let photoAttributes = getAttributesForPhoto(photo)
        
        
        cell.TheImage.file = self.objects[indexPath.row].valueForKey("image")! as PFFile
        cell.TheImage.loadInBackground(nil)
        
        /*if(photoAttributes == nil){
            setAttributes(photo)
            println("1")
        }else{
            println("2")
            cell.TheImage.image = photoAttributes?.valueForKey("image") as? UIImage
        }*/
        //cell.imageView.file = self.objects[indexPath.row].valueForKey("image")! as PFFile
        //println(self.objects[indexPath.row].valueForKey("image"))
        //if(cell.imageView.file.isDataAvailable){
       //     cell.imageView.loadInBackground(nil)
      //  }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toComment"){
            let VC = segue.destinationViewController as AddCommentsViewController
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as MainPageTableViewCell
            VC.TRImage = cell.TheImage.image
        }
    }
    
    func setAttributes(forPhoto: PFObject){
        let attributes = NSMutableDictionary()
        attributes.setValue(forPhoto.valueForKey("image"), forKey: "ImageFile")
        cache.setObject(attributes, forKey: getKeyStringForPhoto(forPhoto))
    }
    
    func getKeyStringForPhoto(forPhoto: PFObject) -> String{
        return "photo_" + forPhoto.objectId
    }
    
    func getAttributesForPhoto(forPhoto: PFObject) -> NSDictionary?{
        return cache.objectForKey(getKeyStringForPhoto(forPhoto)) as? NSDictionary
    }
    
}


/*var imageFile = attributes.valueForKey("ImageFile") as PFFile
imageFile.getDataInBackgroundWithBlock({
(data:NSData!, error:NSError!) -> Void in
if(error == nil){
let myImage = UIImage(data: data)
attributes.setValue(myImage, forKey: "image")
}
})

//
//  SocialApp1MainTableViewController.swift
//  around
//
//  Created by Sicheng Hao on 12/31/14.
//  Copyright (c) 2014 sunkai. All rights reserved.
//

import UIKit

var cache = NSCache()

class SocialApp1MainTableViewController: UITableViewController, UIImagePickerControllerDelegate{

@IBOutlet var NameLabel:UILabel! = UILabel()
@IBOutlet var DescLabel:UILabel! = UILabel()
@IBOutlet var DateLabel:UILabel! = UILabel()
var MainPageData: NSMutableArray = NSMutableArray()
var ImageData:[UIImage] = []
let Refresh = UIRefreshControl()

required init(coder aDecoder: NSCoder) {
super.init(coder: aDecoder)
}

func loadData(){
MainPageData.removeAllObjects()
cache.removeAllObjects()
var FindData: PFQuery = PFQuery(className: "app")
FindData.orderByDescending("createdAt")
FindData.findObjectsInBackgroundWithBlock({
(objects:[AnyObject]!, error:NSError!)->Void in
if(error == nil){
for object in objects{
self.MainPageData.addObject(object)
var ImageFile:PFFile = object.objectForKey("image") as PFFile
ImageFile.getDataInBackgroundWithBlock({
(data:NSData!, error:NSError!) -> Void in
if (error == nil){
println("1")
let myImage = UIImage(data: data)
self.ImageData.append(myImage!)
}else{
println(error)
}
})
cache.setObject(object, forKey: object.objectId as String)
}
self.tableView.reloadData()
}
})




//println(MainPageData)
}

override func viewDidLoad() {
super.viewDidLoad()
loadData()
println("!!!")
Refresh.addTarget(self, action: "RefreshCon", forControlEvents: UIControlEvents.ValueChanged)
self.tableView.addSubview(Refresh)
}

func RefreshCon(){
loadData()
self.tableView.reloadData()
Refresh.endRefreshing()
}

@IBAction func Add(sender: AnyObject) {
self.performSegueWithIdentifier("Add", sender: sender)
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
}

override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
return 1
}

override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return MainPageData.count
}

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCellWithIdentifier("App1", forIndexPath: indexPath) as App1MainTableViewCell
for myLabel in cell.labels{
myLabel.removeFromSuperview()
}
cell.labels = []
let block:PFObject = MainPageData.objectAtIndex(indexPath.row) as PFObject
cell.DescriptionLabel.text = block.objectForKey("description") as? String
cell.UsernameLabel.text = block.objectForKey("user") as? String
let dateFormmat = NSDateFormatter()
dateFormmat.dateFormat = "MM-DD HH:MM"
cell.DateLabel.text =  dateFormmat.stringFromDate(block.createdAt)
cell.DescriptionLabel.sizeToFit()
cell.UsernameLabel.sizeToFit()
cell.DateLabel.sizeToFit()
cell.AvatarButton.setImage(UIImage(named: "barber-128"), forState: .Normal)
cell.AvatarButton.enabled = false
cell.PhotoID = block.objectId
cell.ImageShowing.image = UIImage(named: "barber-128")

println(ImageData)

/*var Activity = PFQuery(className: "activity")
Activity.whereKey("at", equalTo: block.objectId)
Activity.findObjectsInBackgroundWithBlock({
(objects:[AnyObject]!, error:NSError!)->Void in
if(error == nil){
for object in objects{
let label = UILabel()
label.center.x = object.valueForKey("x")! as CGFloat
label.center.y = object.valueForKey("y")! as CGFloat
label.text = object.valueForKey("content")! as? String
label.sizeToFit()
cell.imageView?.addSubview(label)
//cell.insertSubview(label, aboveSubview: cell.ImageShowing)
cell.labels.append(label)
}
}
})*/

if(ImageData.count == 8){
cell.ImageShowing.image = ImageData[indexPath.row]

/*var Activity = PFQuery(className: "activity")
Activity.whereKey("at", equalTo: block.objectId)
Activity.findObjectsInBackgroundWithBlock({
(objects:[AnyObject]!, error:NSError!)->Void in
if(error == nil){
for object in objects{
let label = UILabel()
label.center.x = object.valueForKey("x")! as CGFloat
label.center.y = object.valueForKey("y")! as CGFloat
label.text = object.valueForKey("content")! as? String
label.sizeToFit()
cell.imageView?.addSubview(label)
//cell.insertSubview(label, aboveSubview: cell.ImageShowing)
cell.labels.append(label)
}
}
})*/
}

/*var ImageFile:PFFile = block.objectForKey("image") as PFFile
ImageFile.getDataInBackgroundWithBlock({
(data:NSData!, error:NSError!) -> Void in
if (error == nil){
let TRImage = UIImage(data: data)
cell.ImageShowing.image = TRImage
}
})*/

return cell
}

@IBAction func Comments(sender: AnyObject) {
}

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
if(segue.identifier == "ToComment"){
let vc = segue.destinationViewController as CommentsViewController
let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as App1MainTableViewCell
vc.TRImage = cell.ImageShowing.image!
vc.PhotoID = cell.PhotoID
}
}
}


*/