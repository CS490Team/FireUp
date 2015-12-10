//
//  ViewOtherUserProfileTableViewController.swift
//  Fire Up
//
//  Created by HuangHanxun on 12/9/15.
//
//

import UIKit

class ViewOtherUserProfileTableViewController: UITableViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var followButton: UIButton!
    
    @IBOutlet var userDataCell: UITableViewCell!
    var TRImage:UIImage!
    var TRUsername:String!
    var targetUser:PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.text = TRUsername
        let usernameQuery = PFQuery(className: "_User")
        usernameQuery.whereKey("username", equalTo: TRUsername)
        targetUser = usernameQuery.getFirstObject() as! PFUser
        if(targetUser.objectForKey("User_Profile_Picture") != nil){
            let profileImage = targetUser.objectForKey("User_Profile_Picture") as! PFFile
            profileImage.getDataInBackgroundWithBlock{ (imageData: NSData?, error:NSError?) -> Void in
                self.profileImageView.image = UIImage(data: imageData!)
            }
        }
        
        
        
        
        userDataCell.selectionStyle = UITableViewCellSelectionStyle.None
        let followQuery = PFQuery(className: "FollowRelation")
        followQuery.whereKey("User", equalTo: PFUser.currentUser())
        followQuery.whereKey("Target", equalTo: targetUser)
        followQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                if results.count>0 {
                    self.followButton.setTitle("Unfollow", forState:  UIControlState.Normal)
                    self.followButton.backgroundColor = UIColor(red: 0.91, green: 0.43, blue: 0.26, alpha: 1.0)
                    self.followButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
                }else{
                    self.followButton.setTitle("Follow", forState:  UIControlState.Normal)
                    self.followButton.backgroundColor = UIColor(red: 0.2, green: 0.67, blue: 0.85, alpha: 1.0)
                    self.followButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
                }
            }
        }
        
    }
    @IBAction func followAction(sender: AnyObject) {
        let followQuery = PFQuery(className: "FollowRelation")
        followQuery.whereKey("User", equalTo: PFUser.currentUser())
        followQuery.whereKey("Target", equalTo: targetUser)
        followQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                if results.count>0 {
                    self.unfollowUer()
                    NSThread.sleepForTimeInterval(3)
                    self.viewDidLoad()
                }else{
                    self.followUser()
                    self.viewDidLoad()
                }
            }
        }

    }
    
    func followUser(){
        let followRelation = PFObject(className: "FollowRelation")
        followRelation["User"] = PFUser.currentUser()
        followRelation["Target"] = targetUser
        followRelation.save()
    }
    func unfollowUer(){
        let followQuery = PFQuery(className: "FollowRelation")
        followQuery.whereKey("User", equalTo: PFUser.currentUser())
        followQuery.whereKey("Target", equalTo: targetUser)
        followQuery.findObjectsInBackgroundWithBlock({ (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if results.count > 0{
                    let followrelation = results as! [PFObject]
                    for msg in followrelation{
                        msg.deleteInBackgroundWithBlock(nil)
                    }
                }
            }else{
                print("unfollow Error")
            }
        })
    }
}
