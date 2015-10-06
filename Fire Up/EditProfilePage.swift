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
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var user_profile_image: UIImageView!
    var currentUser: PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserString = PFUser.currentUser().username
        currentUser = PFUser.currentUser()

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
        var profileImageData = UIImageJPEGRepresentation(user_profile_image.image!, 1)
        
        if(profileImageData != nil){
            let profileFileObject = PFFile(data: profileImageData)
            currentUser.setObject(profileImageData, forKey: "User_Profile_Picture")
        }
        if(firstNameTextField.text != nil){
            currentUser.setObject(firstNameTextField.text, forKey: "FirstName")
        }
        if(lastNameTextField.text != nil){
            currentUser.setObject(lastNameTextField.text, forKey: "LastName")
        }
        if(EmailTextField.text != nil){
            currentUser.email = EmailTextField.text
        }
        if(passwordTextField.text != nil){
            currentUser.password = passwordTextField.text
        }
        currentUser.saveInBackgroundWithBlock (success: Bool, error:NSError?) -> Void in
            
        
        }
    
        
    }
}
