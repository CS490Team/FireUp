//
//  ChatOverViewConttroller.swift
//  Fire Up
//
//  Created by HuangHanxun on 11/4/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class ChatOverViewConttroller: UITableViewController {
    @IBOutlet var AddContactButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.navigationItem.setRightBarButtonItem(AddContactButton, animated: false)
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
}