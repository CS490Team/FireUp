//
//  SignUp.swift
//  Fire Up
//
//  Created by HuangHanxun on 10/4/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class SignUp: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirm_password: UITextField!
    @IBOutlet var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.password.delegate = self
        self.confirm_password.delegate = self
        self.email.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        username.resignFirstResponder()
        password.resignFirstResponder()
        confirm_password.resignFirstResponder()
        email.resignFirstResponder()
        return true
    }
    
    @IBAction func SignUpParse(sender: AnyObject) {
        self.save_user()
    }
    
    func save_user(){
        let new_user = PFUser()
        new_user.username = username.text
        new_user.password = password.text
        new_user.email = email.text
        new_user.signUpInBackgroundWithBlock{ (success: Bool, error:NSError?) -> Void in
            var userMessage = "Sign up is successful"
            if(success == false){
                userMessage = "Error"
            }
            var alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                if(success == true){
                    
                }
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}