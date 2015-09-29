//
//  AddCommentsViewController.swift
//  Complain
//
//  Created by sunkai on 1/15/15.
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        var touches = touches.anyObject() as UITouch
        location = touches.locationInView(self.view)
        preLocation = location
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touches = touches.anyObject() as UITouch
        location = touches.locationInView(self.view)
        if((theAvatar.frame.origin.x - preLocation!.x + location!.x <= theImage.frame.origin.x)&&(theAvatar.frame.origin.y - (preLocation!.y - location!.y) <= theImage.frame.origin.y)){     //left top
            
        }else if((location!.x - preLocation!.x + theTextLabel.frame.width + theTextLabel.frame.origin.x >= theImage.frame.origin.x + theImage.frame.width)&&(theAvatar.frame.origin.y - (preLocation!.y - location!.y) <= theImage.frame.origin.y)){       //right top
            
        }else if((theAvatar.frame.origin.x - preLocation!.x + location!.x <= theImage.frame.origin.x)&&(location!.y - preLocation!.y + theAvatar.frame.origin.y + theAvatar.frame.height >= theImage.frame.origin.y + theImage.frame.height)){       //left bottom
            
        }else if((location!.x - preLocation!.x + theTextLabel.frame.width + theTextLabel.frame.origin.x >= theImage.frame.origin.x + theImage.frame.width)&&(location!.y - preLocation!.y + theAvatar.frame.origin.y + theAvatar.frame.height >= theImage.frame.origin.y + theImage.frame.height)){   //right bottom
            
        }else if(location!.x - preLocation!.x + theTextLabel.frame.width + theTextLabel.frame.origin.x >= theImage.frame.origin.x + theImage.frame.width){ //right
            theAvatar.frame = CGRectOffset(theAvatar.frame, 0, location!.y - preLocation!.y)
            theTextLabel.frame = CGRectOffset(theTextLabel.frame, 0, location!.y - preLocation!.y)
        }else if(theAvatar.frame.origin.x - preLocation!.x + location!.x <= theImage.frame.origin.x){   //left
            theAvatar.frame = CGRectOffset(theAvatar.frame, 0, location!.y - preLocation!.y)
            theTextLabel.frame = CGRectOffset(theTextLabel.frame, 0, location!.y - preLocation!.y)
        }else if(location!.y - preLocation!.y + theAvatar.frame.origin.y + theAvatar.frame.height >= theImage.frame.origin.y + theImage.frame.height){ //bottom
            theAvatar.frame = CGRectOffset(theAvatar.frame, location!.x - preLocation!.x, 0)
            theTextLabel.frame = CGRectOffset(theTextLabel.frame, location!.x - preLocation!.x, 0)
        }else if(theAvatar.frame.origin.y - (preLocation!.y - location!.y) <= theImage.frame.origin.y){//top
            theAvatar.frame = CGRectOffset(theAvatar.frame, location!.x - preLocation!.x, 0)
            theTextLabel.frame = CGRectOffset(theTextLabel.frame, location!.x - preLocation!.x, 0)
        }else{
            theAvatar.frame = CGRectOffset(theAvatar.frame, location!.x - preLocation!.x, location!.y - preLocation!.y)
            theTextLabel.frame = CGRectOffset(theTextLabel.frame, location!.x - preLocation!.x, location!.y - preLocation!.y)
        }
        preLocation = location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addRightBarItem(){
        let rightBarItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "rightBarButtonAction")
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func rightBarButtonAction(){
        println("1")
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
