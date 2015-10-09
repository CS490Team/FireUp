//
//  EditProfilePage.swift
//  Fire Up
//
//  Created by HuangHanxun on 10/5/15.
//  Copyright © 2015 sunkai. All rights reserved.
//
import UIKit
import Foundation

class EditProfilePage: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var currentUserString: String!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var user_profile_image: UIImageView!
    var currentUser: PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserString = PFUser.currentUser()!.username
        currentUser = PFUser.currentUser()
        
        if(PFUser.currentUser()?.objectForKey("FirstName") != nil){
            let temp = PFUser.currentUser().objectForKey("FirstName") as! String
            firstNameTextField.text = temp
        }
        if(PFUser.currentUser()?.objectForKey("LastName") != nil){
            lastNameTextField.text = PFUser.currentUser().objectForKey("LastName") as! String
        }
        if(PFUser.currentUser()?.objectForKey("User_Profile_Picture") != nil){
            let userImageProfile = PFUser.currentUser()?.objectForKey("User_Profile_Picture") as! PFFile
            userImageProfile.getDataInBackgroundWithBlock{ (imageData: NSData?, error:NSError?) -> Void in
                self.user_profile_image.image = UIImage(data: imageData!)
            }
        }

        print(currentUserString)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SelectProfile(sender: AnyObject) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        user_profile_image.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func UpdateProfile(sender: AnyObject) {
        currentUser = PFUser.currentUser()
        if(user_profile_image.image != nil){
            let profileImageData = UIImageJPEGRepresentation(user_profile_image.image!, 1)
            let profileFileObject = PFFile(data: profileImageData!)
            currentUser.setObject(profileFileObject!, forKey: "User_Profile_Picture")
        }
        
        if(firstNameTextField.text != nil){
            currentUser.setObject(firstNameTextField.text!, forKey: "FirstName")
        }
        if(lastNameTextField.text != nil){
            currentUser.setObject(lastNameTextField.text!, forKey: "LastName")
        }
        if(passwordTextField.text != nil){
            currentUser.password = passwordTextField.text
        }
        currentUser.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
            if(success){
                print("update Profile")
                let userMessage = "ProfileUpdated!"
                let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                self.performSegueWithIdentifier("ProfilePage", sender: self)

            }
        }
        
        
    }
}
