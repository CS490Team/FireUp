//
//  TimelineTableViewController.swift
//  Fire Up
//
//  Created by Yijie Wu on 12/11/15.
//
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    
    var timelineData: NSMutableArray=NSMutableArray()
    
    
    
    func loadData(){
        timelineData.removeAllObjects()
        let findTimelineData:PFQuery=PFQuery(className: "discuss")
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if (error == nil){
                for object:AnyObject in objects!{
                    self.timelineData.addObject(object as! PFObject)
                }
                
                let array1:NSArray=self.timelineData.reverseObjectEnumerator().allObjects
                
                let myNewName = NSMutableArray(array:array1)
                self.timelineData=myNewName as NSMutableArray
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadData()
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timelineData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! (SweetTableViewCell)
        let sweet:PFObject=self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.sweetTextView.text = sweet.objectForKey("content") as! String
        
        
        //-----------------------------------------------------------------------
        
        let dataFormatter:NSDateFormatter=NSDateFormatter()
        dataFormatter.dateFormat="yy-MM-dd HH:mm"
        cell.timestampLabel.text=dataFormatter.stringFromDate(sweet.createdAt)
        
        // print(sweet.objectForKey("user").objectId)
        let tt=sweet.objectForKey("user").objectId
        
        let query = PFQuery(className:"_User")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    if(object.objectId==tt){
                        //print(object.username)
                        cell.usernameLabel.text=object.username
                        
                    }
                }
            }
        }
        
        
        
        
        
        
        //let tmpvar=sweet.objectForKey("user").objectId
        //let tbc:PFObject=PFObject(className: "User")
        
        
        /*
        if sweet.objectForKey("user")==nil{
        print("FATAL")
        
        
        }
        else{
        print(sweet.objectForKey("user").objectId)
        }
        */
        /*
        let findSweeter:PFQuery=PFQuery()
        findSweeter.whereKey("objectId", equalTo: sweet.objectForKey("user").objectId)
        findSweeter.findObjectsInBackgroundWithBlock{
        (objects: [AnyObject]?, error: NSError?) -> Void in
        
        if (error == nil){
        let user:PFUser=(objects! as NSArray).lastObject as! PFUser
        cell.usernameLabel.text=user.username
        }
        
        }
        
        */
        
        
        // Configure the cell...
        
        return cell
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
