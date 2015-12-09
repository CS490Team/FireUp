//
//  SignUpTableViewController.swift
//  Fire Up
//
//  Created by HuangHanxun on 12/7/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
class SignUpTableViewController: UITableViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    

    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var selectImageButton: UIButton!
    @IBOutlet var SignUpButton: UIButton!
    
    @IBOutlet var signUpButtonCell: UITableViewCell!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirm_password: UITextField!
    @IBOutlet var email: UITextField!
    
    @IBOutlet var FirstName: UITextField!
    
    @IBOutlet var LastName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.password.delegate = self
        self.confirm_password.delegate = self
        self.email.delegate = self
        self.FirstName.delegate = self
        self.LastName.delegate = self
        
        //self.tabBarController?.tabBar.hidden = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func SelectProfile(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        username.resignFirstResponder()
        password.resignFirstResponder()
        confirm_password.resignFirstResponder()
        email.resignFirstResponder()
        FirstName.delegate = self
        LastName.delegate = self
        
        return true
    }
    
    @IBAction func SignUpParse(sender: AnyObject) {
        self.save_user()
    }
    
    /*func textFieldDidBeginEditing(textField: UITextField) {
    Slevel.setTitleColor(UIColor.redColor(), forState: .Normal)
    Slevel.setTitle("1", forState: .Normal)
    }*/
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == password){
            let currentString: NSString = textField.text!
            if(currentString.length <= 8 ){
               // Slevel.setTitleColor(UIColor.redColor(), forState: .Normal)
                //Slevel.setTitle("poor", forState: .Normal)
            }
            if(currentString.length > 8){
               // Slevel.setTitleColor(UIColor.greenColor(), forState: .Normal)
                //Slevel.setTitle("good", forState: .Normal)
            }
        }
    }
    
    /*func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if(textField == password){
    let currentString: NSString = textField.text!
    print(currentString.length)
    if(currentString.length <= 8 ){
    Slevel.setTitleColor(UIColor.redColor(), forState: .Normal)
    Slevel.setTitle("poor", forState: .Normal)
    return true
    }
    if(currentString.length > 8){
    Slevel.setTitleColor(UIColor.greenColor(), forState: .Normal)
    Slevel.setTitle("good", forState: .Normal)
    return true
    }
    }
    return true
    }*/
    
    
    
    func save_user(){
        var test = true;
        let new_user = PFUser()
        new_user.username = username.text
        new_user.password = password.text
        if(new_user.password.characters.count<5){
            let userMessage = "Password has to be at least 5 digits"
            let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            test = false
        }
        if(FirstName.text!.isEmpty==false){
            new_user.setObject(FirstName.text!, forKey: "FirstName")
        }
        if(LastName.text!.isEmpty==false){
            new_user.setObject(FirstName.text!, forKey: "LastName")
        }
        if(profileImage.image != nil){
            let profileImageData = UIImageJPEGRepresentation(profileImage.image!, 1)
            let profileFileObject = PFFile(data: profileImageData!)
            new_user.setObject(profileFileObject!, forKey: "User_Profile_Picture")
        }
        new_user.email = email.text
        if(test == true){
            new_user.signUpInBackgroundWithBlock{ (success: Bool, error:NSError?) -> Void in
                var userMessage = "Sign up is successful"
                if(success == false){
                    userMessage = "Error, username or email already exist"
                }
                let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                    if(success == true){
                        
                    }
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        NSThread.sleepForTimeInterval(2)
        self.performSegueWithIdentifier("BackToLogin", sender: self)
    }

    
    
    
}