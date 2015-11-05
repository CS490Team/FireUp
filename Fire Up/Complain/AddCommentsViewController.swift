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
/*
//
//  AddCommentsViewController.swift
//
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextFieldDelegate{

@IBOutlet var theImage:UIImageView!
@IBOutlet var theTextField:UITextField!
@IBOutlet var theTextLabel:UILabel!
@IBOutlet var theAvatar:UIImageView!
var TRImage:UIImage!
var location:CGPoint?
var preLocation:CGPoint?

override func viewDidLoad() {
super.viewDidLoad()
theImage.image = TRImage
theTextField.delegate = self
theTextLabel.hidden = true
theAvatar.image = UIImage(named: "1418636834_bike-128")
theAvatar.hidden = true
addRightBarItem()
addLeftBarItem()
self.navigationItem.rightBarButtonItem?.enabled = false
}

func textFieldDidEndEditing(textField: UITextField) {
theTextLabel.text = theTextField.text
theTextField.hidden = true
theTextLabel.hidden = false
theAvatar.hidden = false
theTextLabel.sizeToFit()
self.navigationItem.rightBarButtonItem?.enabled = true
theTextLabel.frame = CGRectMake(theImage.center.x, theImage.center.y - 1/2 * theTextLabel.frame.height, theTextLabel.frame.width, theTextLabel.frame.height)
theAvatar.frame = CGRectMake(theTextLabel.center.x - ((theAvatar.frame.width * 2 + theTextLabel.frame.width) / 2), theTextLabel.center.y - theAvatar.frame.height / 2, theAvatar.frame.width, theAvatar.frame.height)
}

func textFieldShouldReturn(textField: UITextField) -> Bool {
if(textField == theTextField){
theTextField.resignFirstResponder()
}
return false
}


override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
}

func addRightBarItem(){
let rightBarItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "rightBarButtonAction")
self.navigationItem.rightBarButtonItem = rightBarItem
}

func rightBarButtonAction(){
print("1")
}

func addLeftBarItem(){
let leftBarItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "leftBarButtonAction")
self.navigationItem.leftBarButtonItem = leftBarItem
}

func leftBarButtonAction(){
if(self.navigationItem.rightBarButtonItem?.enabled == false){
self.performSegueWithIdentifier("CommentBackToMain", sender: navigationController?.navigationItem.leftBarButtonItem)
}else{
theTextLabel.hidden = true
theTextField.hidden = false
theAvatar.hidden = true
self.navigationItem.rightBarButtonItem?.enabled = false
theTextField.becomeFirstResponder()
}
}
}




*/
