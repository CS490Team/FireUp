//
//  PasswordRecover.swift
//  Fire Up
//
//  Created by Hanxun Huang on 10/31/15.
//  Copyright © 2015 sunkai. All rights reserved.
//
import Foundation
import UIKit
import Parse

class PasswordRecover :UIViewController, UITextFieldDelegate{
    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        let emailAdress = emailTextField.text
        PFUser.requestPasswordResetForEmailInBackground(emailAdress, block: {
            (success:Bool,error:NSError?) -> Void in
            if(error != nil){
                let userMessage = "Email Error"
                let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else{
                let userMessage = "Email Sent"
                let alert = UIAlertController(title: "Success", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                }
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })

    }
    
    
    
    
}