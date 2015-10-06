//
//  ProfileViewController.swift
//  Complain
//
//  Created by sunkai on 1/16/15.
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var LogoutButton: UIButton!
    @IBOutlet var LabelTest: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Signout(sender: AnyObject){
        PFUser.logOut()
        self.performSegueWithIdentifier("ProfileToLogin", sender: self)
    }
}
