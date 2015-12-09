//
//  ChatOverViewConttroller.swift
//  Fire Up
//
//  Created by HuangHanxun on 11/4/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class ChatOverViewConttroller: UITableViewController {
    @IBOutlet var AddContactButton: UIBarButtonItem!
    @IBOutlet var newMessageIndicator: UIView!
    
    var rooms = [PFObject]()
    var users = [PFUser]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayPushMessages", name: "displayMessages", object: nil)
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "displayMessages", object: nil)

    }
    
    func displayPushMessage (notification: NSNotification){
        let notificationDict = notification.object as! NSDictionary
        if let aps = notificationDict.objectForKey("aps") as? NSDictionary{
            let messagesText = aps.objectForKey("Alert") as! String
            let alert = UIAlertController(title: "New message", message: messagesText, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Thanks...", style: UIAlertActionStyle.Default, handler:nil ))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        self.navigationItem.setRightBarButtonItem(AddContactButton, animated: false)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func loadDate(){
        rooms = [PFObject]()
        users = [PFUser]()
        self.tableView.reloadData()
        
        let pred = NSPredicate(format: "user1 = %@ OR user2 = %@", PFUser.currentUser(), PFUser.currentUser())
        let roomQuery = PFQuery(className: "ChatRoom", predicate: pred)
        roomQuery.includeKey("user1")
        roomQuery.includeKey("user2")
        roomQuery.findObjectsInBackgroundWithBlock({ (results:[AnyObject]!, error: NSError!) -> Void in
        roomQuery.orderByDescending("updatedAt")
            if(error == nil){
                self.rooms = results as! [PFObject]
                for room in self.rooms{
                    let user1 = room.objectForKey("user1") as! PFUser
                    let user2 = room["user2"] as! PFUser
                    
                    
                    if user1.objectId != PFUser.currentUser().objectId{
                        self.users.append(user1)
                    }
                    if user2.objectId != PFUser.currentUser().objectId{
                        self.users.append(user2)
                    }
                    
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(PFUser.currentUser() != nil){
            loadDate()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! OverviewTableViewCell
        
        cell.messageIndicator.hidden = true
        
        
        let targetUser = users[indexPath.row]
        cell.usernameLabel.text = targetUser.username
        
        let user1 = PFUser.currentUser()
        let user2 = users[indexPath.row]
        
        
       
        if user2["User_Profile_Picture"] != nil {
            let profileImageFile = user2["User_Profile_Picture"] as! PFFile
            profileImageFile.getDataInBackgroundWithBlock{ (data:NSData!, error:NSError!) -> Void in
                if error == nil {
                    cell.userProfileImage.image = UIImage(data: data)
                
                }
            }
        }
        
        
        
        
        let pred = NSPredicate(format: "user1 = %@ AND user2= %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
        let roomQuery = PFQuery(className: "ChatRoom", predicate: pred)
        roomQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                if results.count>0 {
                    let messageQuery = PFQuery(className: "Message")
                    let room = results.last as! PFObject
                    
                    let unreadQuery = PFQuery(className: "UnreadMessage")
                    unreadQuery.whereKey("User", equalTo: PFUser.currentUser())
                    unreadQuery.whereKey("Room", equalTo: room)
                    
                    unreadQuery.findObjectsInBackgroundWithBlock({ (results:[AnyObject]!, error: NSError!) -> Void in
                        
                        if error == nil {
                            if results.count > 0{
                                cell.messageIndicator.hidden = false
                            }
                        }
                        
                    })
                    
                    messageQuery.whereKey("room", equalTo: room)
                    messageQuery.limit = 1
                    messageQuery.orderByDescending("createdAt")
                    messageQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
                        if error == nil{
                            if results.count>0 {
                                let message = results.last as! PFObject
                                cell.messageLabel.text = message["content"] as! String
                                print(cell.messageLabel.text)
                                let date = message.createdAt
                                let interval = NSDate().daysAfterDate(date)
                                var dateString = ""
                                if interval == 0 {
                                    dateString = "Today"
                                }else if interval == 1{
                                    dateString = "Yesterday"
                                }else if interval > 1 {
                                    let dateFormat = NSDateFormatter()
                                    dateFormat.dateFormat = "mm/dd/yyyy"
                                    dateString = dateFormat.stringFromDate(message.createdAt)
                                }
                                cell.dateLabel.text = dateString
                            }
                            else{
                                cell.messageLabel.text = "No Messages"
                                cell.dateLabel.text = ""
                            }
                        }
                    }
                }
            }
            
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messagesVC = storyboard.instantiateViewControllerWithIdentifier("MessageViewController") as! MessageViewController
        let user1 = PFUser.currentUser()
        let user2 = users[indexPath.row]
        let pred = NSPredicate(format: "user1 = %@ AND user2= %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
        
        let roomQuery = PFQuery(className: "ChatRoom", predicate: pred)
        roomQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                let room = results.last as! PFObject
                messagesVC.room = room
                messagesVC.incomingUser = user2
                self.navigationController?.pushViewController(messagesVC, animated: true)
            }
        }
    }
    
    
    
    
    
    
}