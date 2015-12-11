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
    
    @IBOutlet var recentPostCell1Title: UITextField!
    @IBOutlet var recentPostCell2Title: UITextField!
    @IBOutlet var recentPostCell3Title: UITextField!
    
    @IBOutlet var recentPostCell1Detail: UITextField!
    @IBOutlet var recentPostCell2Detail: UITextField!
    @IBOutlet var recentPostCell3Detail: UITextField!
    
    @IBOutlet var totalPostTextfield: UITextField!
    @IBOutlet var followerTextField: UITextField!
    @IBOutlet var userDataCell: UITableViewCell!
    var TRImage:UIImage!
    var TRUsername:String!
    var targetUser:PFUser!
    var objectID1: String!
    var objectID2: String!
    var objectID3: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.enabled  = false
        totalPostTextfield.enabled = false
        followerTextField.enabled = false
        recentPostCell3Detail.enabled = false
        recentPostCell2Detail.enabled = false
        recentPostCell1Detail.enabled = false
        recentPostCell3Title.enabled = false
        recentPostCell2Title.enabled = false
        recentPostCell1Title.enabled = false
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
        
        loadCount()
        
        
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
        
        let feedQuery = PFQuery(className: "feed")
        feedQuery.whereKey("feeder", equalTo: targetUser)
        feedQuery.orderByDescending("createdAt")
        feedQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil{
                if results.count > 0{
                    let recentPost = results as! [PFObject]
                    var index = 1
                    var titleString = ""
                    var detailString = ""
                    for rp in recentPost{
                        if index == 1{
                            titleString = rp["text"] as! String
                            detailString = rp["recipe"] as! String
                            self.recentPostCell1Title.text = titleString
                            self.recentPostCell1Detail.text = detailString
                            self.objectID1 = rp.objectId
                            
                        }else if index == 2{
                            titleString = rp["text"] as! String
                            detailString = rp["recipe"] as! String
                            self.recentPostCell2Title.text = titleString
                            self.recentPostCell2Detail.text = detailString
                            self.objectID2 = rp.objectId
                            
                        }else if index == 3{
                            titleString = rp["text"] as! String
                            detailString = rp["recipe"] as! String
                            self.recentPostCell3Title.text = titleString
                            self.recentPostCell3Detail.text = detailString
                            self.objectID3 = rp.objectId

                        }else{
                            break;
                        }
                        index = index + 1
                    }
                }
            }
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let imageQuery = PFQuery(className: "feed")
        if(segue.identifier == "toDetail1"){
            let VC = segue.destinationViewController as! ViewRecipeTableViewController
            VC.TRTitle = recentPostCell1Title.text
            VC.TRRecipe = recentPostCell1Detail.text
            imageQuery.whereKey("objectId", equalTo: objectID1)
            imageQuery.findObjectsInBackgroundWithBlock { (results:[AnyObject]!, error: NSError!) -> Void in
                let imagefile = results as! [PFObject]
                for im in imagefile{
                    let imfile = im.valueForKey("image") as! PFFile
                    imfile.getDataInBackgroundWithBlock{ (data:NSData!, self_error:NSError!) -> Void in
                        VC.TRImage = UIImage(data: data)
                        if VC.TRImage == nil{
                            print("")
                        }
                    }
                }
            }
        }
        if(segue.identifier == "toDetail2"){
            let VC = segue.destinationViewController as! ViewRecipeTableViewController
            VC.TRTitle = recentPostCell2Title.text
            VC.TRRecipe = recentPostCell2Detail.text
        }
        if(segue.identifier == "toDetail3"){
            let VC = segue.destinationViewController as! ViewRecipeTableViewController
            VC.TRTitle = recentPostCell3Title.text
            VC.TRRecipe = recentPostCell3Detail.text
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
                        msg.deleteEventually()
                    }
                    self.viewDidLoad()
                }
            }else{
                print("unfollow Error")
            }
        })
    }
    
    func loadCount(){
        let followCountQuery = PFQuery(className: "FollowRelation")
        followCountQuery.whereKey("Target", equalTo: targetUser)
        followCountQuery.findObjectsInBackgroundWithBlock({ (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if results.count > 0{
                    print(results.count)
                    let tempString = String(results.count)
                    self.followerTextField.text = "Follower: " + tempString
                }
            }else{
                print("unfollow Error")
            }
        })
        let postCountQuery = PFQuery(className: "feed")
        postCountQuery.whereKey("feeder", equalTo: targetUser)
        postCountQuery.findObjectsInBackgroundWithBlock({ (results:[AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if results.count > 0{
                    print(results.count)
                    let tempString = String(results.count)
                    self.totalPostTextfield.text = "TotalPost: " + tempString
                }
            }else{
                print("unfollow Error")
            }
        })

    }
}
