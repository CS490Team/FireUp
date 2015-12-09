//
//  ViewOtherUserProfileTableViewController.swift
//  Fire Up
//
//  Created by HuangHanxun on 12/9/15.
//
//

import UIKit

class ViewOtherUserProfileTableViewController: UITableViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var followButton: UIButton!
    
    var TRImage:UIImage!
    var TRUsername:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = TRUsername
    }
}
