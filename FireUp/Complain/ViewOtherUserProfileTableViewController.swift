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
        print(TRUsername)
        usernameTextField.text = TRUsername
        let usernameQuery = PFQuery(className: "_User")
        print(TRUsername)
        usernameQuery.whereKey("username", equalTo: TRUsername)
        targetUser = usernameQuery.getFirstObject() as! PFUser
        if(targetUser.objectForKey("User_Profile_Picture") != nil){
            let profileImage = targetUser.objectForKey("User_Profile_Picture") as! PFFile
            profileImage.getDataInBackgroundWithBlock{ (imageData: NSData?, error:NSError?) -> Void in
                self.profileImageView.image = UIImage(data: imageData!)
            }
        }
        userDataCell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    @IBAction func followAction(sender: AnyObject) {
        print("test")
    }
}
