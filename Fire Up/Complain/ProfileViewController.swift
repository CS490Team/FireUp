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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = PFUser.currentUser().username
        print(currentUser)
        username.text = "Username: " + currentUser
        //email.text = "Email: "+PFUser.currentUser().email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Signout(sender: AnyObject){
        PFUser.logOut()
        self.performSegueWithIdentifier("ProfileToLogin", sender: self)
    }
    /*@IBAction func SelectProfileImage(sender: AnyObject) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }*/
    
}
