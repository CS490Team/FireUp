//
//  AddCommentsViewController.swift
//
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextFieldDelegate{
    
    var TRImage:UIImage!

    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var theTextField: UITextField!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theImage.image = TRImage
        addLeftBarItem()
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addLeftBarItem(){
        let leftBarItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "leftBarButtonAction")
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func leftBarButtonAction(){
        if(self.navigationItem.rightBarButtonItem?.enabled == false){
            self.performSegueWithIdentifier("CommentBackToMain", sender: navigationController?.navigationItem.leftBarButtonItem)
        }else{
            theTextField.hidden = false
            self.navigationItem.rightBarButtonItem?.enabled = false
            theTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func post(sender: AnyObject) {
        
        let post = PFObject(className: "comment")
        post["comm"] = theTextField.text
       // post["image"] =
        post["user"] = PFUser.currentUser()
        post.saveInBackgroundWithBlock(nil)

    }
}
