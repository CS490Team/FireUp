//
//  Login.swift
//  Complain
//
//  Created by sunkai on 1/15/15.
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class Login: UIViewController, UITextFieldDelegate{
   
    @IBOutlet var passwordTextField:UITextField!
    @IBOutlet var usernameTextField:UITextField!
    
    override func viewDidLoad() {
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
       
        return true
    }
    @IBAction func login(sender: AnyObject){
        let username = usernameTextField.text
        let password = passwordTextField.text
        PFUser.logInWithUsernameInBackground(username, password: password, block: {
            (user:PFUser!, error:NSError!)->Void in
            if(error == nil){
                self.performSegueWithIdentifier("LoginToMain", sender: self)
            }else{
                let userMessage = "Login Error"
                let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func signup(sender: AnyObject){
        
    }
}
