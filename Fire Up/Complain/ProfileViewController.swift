//
//  ProfileViewController.swift
//  Complain
//
//  Created by sunkai on 1/16/15.
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var LogoutButton: UIButton!
    @IBOutlet var user_profile_image: UIImageView!
    
    @IBOutlet var username: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var FirstName: UILabel!
    @IBOutlet var LastName: UILabel!
    var currentUser: String!
    
    override func viewWillAppear(test: Bool){
        super.viewWillAppear(true)
        updateUserProfile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()!.username
        print(currentUser)
        username.text = "Username: " + currentUser
        if(PFUser.currentUser()!.email != nil){
            let temp = PFUser.currentUser()!.email
            email.text = "Email: " + temp!
        }
        updateUserProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Signout(sender: AnyObject){
        PFUser.logOut()
        self.performSegueWithIdentifier("ProfileToLogin", sender: self)
    }
    @IBAction func updateProfile(sender: AnyObject) {
        updateUserProfile()
        
    }
    func updateUserProfile(){
        currentUser = PFUser.currentUser()!.username
        username.text = "Username: " + currentUser
        if(PFUser.currentUser()?.email != nil){
            email.text = "Email: "+PFUser.currentUser()!.email!
        }else{
            email.text = "Email: "
        }
        if(PFUser.currentUser()?.objectForKey("FirstName") != nil){
            let temp = PFUser.currentUser().objectForKey("FirstName") as! String
            FirstName.text = "First Name: " + temp
        }else{
            FirstName.text = "First Name: "
        }
        if(PFUser.currentUser()?.objectForKey("LastName") != nil){
            let temp = PFUser.currentUser().objectForKey("LastName") as! String
            LastName.text = "Last Name: " + temp
        }else{
            LastName.text = "Last Name: "
        }
        if(PFUser.currentUser()?.objectForKey("User_Profile_Picture") != nil){
            let userImageProfile = PFUser.currentUser()?.objectForKey("User_Profile_Picture") as! PFFile
            userImageProfile.getDataInBackgroundWithBlock{ (imageData: NSData?, error:NSError?) -> Void in
                self.user_profile_image.image = UIImage(data: imageData!)
            }
        }
    }
    /*@IBAction func SelectProfileImage(sender: AnyObject) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }*/
    
}
