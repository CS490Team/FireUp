//
//  ChooseContactTableViewConttroller.swift
//  Fire Up
//
//  Created by HuangHanxun on 11/4/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class ChooseContactTableViewConttroller: PFQueryTableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    var searchString = ""
    var searchInProgress = false

    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
        self.parseClassName = "User"
        self.textKey = "username"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
    }

    override func queryForTable() -> PFQuery! {
        let query = PFUser.query()
        query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
        if searchInProgress{
            query.whereKey("username", containsString: searchString)
        }
        if self.objects.count == 0{
            query.cachePolicy = kPFCachePolicyCacheThenNetwork
        }
        query.orderByAscending("username")
        return query
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        print("SearchBarChange");
        searchInProgress = true
        self.loadObjects()
        searchInProgress = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(PFUser.currentUser() != nil){
            var user1 = PFUser.currentUser()
            var user2 = self.objects[indexPath.row] as! PFUser
            var room = PFObject(className: "ChatRoom")
            //
            
            var sb = UIStoryboard(name: "Main", bundle: nil)
            let messagesVC = sb.instantiateViewControllerWithIdentifier("MessageViewController") as! MessageViewController
            
        
            
            let pred = NSPredicate (format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1,user2,user2,user1)
            let roomQuery = PFQuery(className: "ChatRoom", predicate:  pred)
            roomQuery.findObjectsInBackgroundWithBlock({ (results:[AnyObject]!, error: NSError!) -> Void in
                if(error == nil){
                    if(results.count>0){
                        //room already exist
                        room = results.last as! PFObject
                        messagesVC.room = room
                        messagesVC.incomingUser = user2
                        self.navigationController?.pushViewController(messagesVC, animated: true)

                    }else{
                        //new room
                        room["user1"] = user1
                        room["user2"] = user2
                        room.saveInBackgroundWithBlock({ (success:Bool!, error:NSError!) -> Void in
                            if(error != nil){
                                print("ChooseContactTableViewConttroller: save room error")
                            }else{
                                messagesVC.room = room
                                messagesVC.incomingUser = user2
                                self.navigationController?.pushViewController(messagesVC, animated: true)
                            
                            }
                        })
                    }
                }
            })            
            
            
        }else{
            print("ChooseContactTableViewConttroller: NotLogin")
        }
    }
    
    
}