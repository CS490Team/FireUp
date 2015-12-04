//
//  EditProfileTableView.swift
//  Fire Up
//
//  Created by Hanxun Huang on 12/3/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
class EditProfileTableView: UITableViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var currentUserString: String!
    var currentUser: PFUser!
    
    @IBOutlet var user_profile_image: UIImageView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    
    @IBOutlet var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = saveButton
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        usernameTextField.enabled = false;
        emailTextField.enabled = false;
        currentUserString = PFUser.currentUser()!.username
        currentUser = PFUser.currentUser()
        
        if(PFUser.currentUser()?.objectForKey("FirstName") != nil){
            let temp = PFUser.currentUser().objectForKey("FirstName") as! String
            firstNameTextField.text = temp
        }
        if(PFUser.currentUser()?.objectForKey("LastName") != nil){
            lastNameTextField.text = PFUser.currentUser().objectForKey("LastName") as? String
        }
        if(PFUser.currentUser()?.objectForKey("User_Profile_Picture") != nil){
            let userImageProfile = PFUser.currentUser()?.objectForKey("User_Profile_Picture") as! PFFile
            userImageProfile.getDataInBackgroundWithBlock{ (imageData: NSData?, error:NSError?) -> Void in
                self.user_profile_image.image = UIImage(data: imageData!)
            }
        }
        usernameTextField.text = currentUser.username;
        emailTextField.text = currentUser.email;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)

        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()

        
        return true
    }
    
    
    @IBAction func SelectProfile(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        user_profile_image.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func UpdateProfile(sender: AnyObject) {
        var test = true
        currentUser = PFUser.currentUser()
        if(user_profile_image.image != nil){
            let profileImageData = UIImageJPEGRepresentation(user_profile_image.image!, 1)
            let profileFileObject = PFFile(data: profileImageData!)
            currentUser.setObject(profileFileObject!, forKey: "User_Profile_Picture")
        }
        
        if(firstNameTextField.text!.isEmpty==false){
            currentUser.setObject(firstNameTextField.text!, forKey: "FirstName")
        }
        if(lastNameTextField.text!.isEmpty==false){
            currentUser.setObject(lastNameTextField.text!, forKey: "LastName")
        }
        if(passwordTextField.text!.isEmpty==false){
            if(passwordTextField.text!.characters.count<5){
                let userMessage = "Password has to be at least 5 digits"
                let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
                test = false
            }else{
                currentUser.password = passwordTextField.text
            }
            
        }
        if(test == true){
            currentUser.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
                if(success){
                    print("update Profile")
                    let userMessage = "ProfileUpdated!"
                    let alert = UIAlertController(title: "succeed", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                    }
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    let sb = UIStoryboard(name: "main", bundle: nil)
                    let profileVC = sb.instantiateViewControllerWithIdentifier("ProfilePage")
                    profileVC.navigationItem.setHidesBackButton(true, animated: false)
                    self.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
        
    }

    
    
    
    
    
    
    
    
}
