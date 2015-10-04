//
//  SignUp.swift
//  Fire Up
//
//  Created by HuangHanxun on 10/4/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class SignUp: UIViewController{
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirm_password: UITextField!
    @IBOutlet var email: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func parse_signup(sender: AnyObject) {
        self.save_user()
    }
    func save_user(){
        let new_user = PFUser()
        new_user.username = username.text
        new_user.password = password.text
        new_user.email = email.text
        new_user.signUp()
        new_user.save()
    }
}