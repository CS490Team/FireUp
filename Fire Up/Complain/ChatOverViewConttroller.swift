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
    
    var rooms = [PFObject]()
    var users = [PFUser]()
    
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
        
        let targetUser = users[indexPath.row]
        cell.usernameLabel.text = targetUser.username
        
        
        return cell;
    }
    
}