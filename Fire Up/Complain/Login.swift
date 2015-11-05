//
//  Login.swift
//
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
        var test = true
        let username = usernameTextField.text
        let password = passwordTextField.text
        if(usernameTextField.text!.isEmpty){
            let userMessage = "Username empty"
            let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            test = false;
        }
        else if(passwordTextField.text!.isEmpty){
            let userMessage = "password empty"
            let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            test = false;
        }
        if(test == true){
            PFUser.logInWithUsernameInBackground(username as String!, password: password as String!, block: {
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
    }
    
    @IBAction func signup(sender: AnyObject){
        
    }
}
