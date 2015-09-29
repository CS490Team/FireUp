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
        usernameTextField.secureTextEntry = true
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: AnyObject){
        let username = usernameTextField.text
        let password = passwordTextField.text
        PFUser.logInWithUsernameInBackground(username, password: password, block: {
            (user:PFUser!, error:NSError!)->Void in
            if(error == nil){
                self.performSegueWithIdentifier("LoginToMain", sender: self)
            }else{
                println("Login error")
            }
        })
    }
    
    @IBAction func signup(sender: AnyObject){
        
    }
}
