//
//  ProfileViewController.swift
//
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var user_profile_image: UIImageView!
    
    @IBOutlet var logOutButton: UIBarButtonItem!
    @IBOutlet var LastName: UITextField!
    @IBOutlet var FirstName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var username: UITextField!

    var currentUser: String!
    
    override func viewWillAppear(test: Bool){
        super.viewWillAppear(true)
        updateUserProfile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = logOutButton
        currentUser = PFUser.currentUser()!.username
        if(currentUser == nil){
            print("nil")
            self.performSegueWithIdentifier("ProfileToLogin", sender: self)

        }else{
            username.text = currentUser
            if(PFUser.currentUser()!.email != nil){
                let temp = PFUser.currentUser()!.email
                email.text =  temp!
            }
            updateUserProfile()
        }
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
        username.text = currentUser
        if(PFUser.currentUser()?.email != nil){
            email.text = PFUser.currentUser()!.email!
        }
        if(PFUser.currentUser()?.objectForKey("FirstName") != nil){
            let temp = PFUser.currentUser().objectForKey("FirstName") as! String
            FirstName.text = "FirstName: " + temp
        }else{
            FirstName.text = "FirstName: "
        }
        if(PFUser.currentUser()?.objectForKey("LastName") != nil){
            let temp = PFUser.currentUser().objectForKey("LastName") as! String
            LastName.text = "LastName:  " + temp
        }else{
            LastName.text = "LastName:  "
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
