//
//  MainPageTableViewController.swift
//  Complain
//
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

var cache = NSCache()

class MainPageTableViewController: PFQueryTableViewController{

    var MainPageData = NSDictionary()
    
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
        return queryForUser
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MainPageCell", forIndexPath: indexPath) as! MainPageTableViewCell
        cell.TheImage.frame = CGRectMake(0, 70, 320, 250)
        cell.TheImage.image = UIImage(named: "1421031790_Picture")
        let photo: PFObject = self.objects[indexPath.row] as! PFObject
        
        cell.TheText.text = self.objects[indexPath.row].valueForKey("text")! as! String
        cell.TheImage.file = self.objects[indexPath.row].valueForKey("image")! as! PFFile
        
       // let UserID = self.objects[indexPath.row].valueForKey("feeder")
        let CUser = self.objects[indexPath.row].valueForKey("feeder") as! PFUser
        //let TQuery = PFUser.query()
        //TQuery.whereKey("objectId", equalTo: self.objects[indexPath.row].valueForKey("feeder"))
        //let TUser:PFUser = TQuery.whereKey(<#T##key: String!##String!#>, equalTo: <#T##AnyObject!#>)
        print(CUser)
        let username:String = CUser.username as! String
        cell.UserName.setTitle(username, forState: .Normal)

        cell.TheImage.loadInBackground(nil)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toComment"){
            let VC = segue.destinationViewController as! AddCommentsViewController
            let SenderPosition = sender?.convertPoint(CGPointZero, toView: self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(SenderPosition!)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! MainPageTableViewCell
            VC.TRImage = cell.TheImage.image
        }
    }
    
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