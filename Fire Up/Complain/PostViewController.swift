//
//  PostViewController.swift
//  Complain
//
//  Created by sunkai on 1/13/15.
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var addPhoto: UIButton!
    @IBOutlet var addText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightBarItem()
        addLeftBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addPhoto(sender: AnyObject){
        let SelectImages:UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Pick images", "Take photos")
        SelectImages.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)){
                self.navigationController?.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        if(buttonIndex == 2){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                self.navigationController?.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: {
            self.addPhoto.setImage(image, forState: .Normal)
        })
    }

    func addRightBarItem(){
        let rightBarItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "rightBarButtonAction")
        self.navigationItem.rightBarButtonItem = rightBarItem
    }

    func rightBarButtonAction(){
        var post = PFObject(className: "timeline")
        post["text"] = addText.text
        //post["user"] = PFUser.currentUser()
        let imageData = UIImagePNGRepresentation(addPhoto.currentImage)
        let imageFile = PFFile(name:"image.png", data:imageData)
        post["image"] = imageFile
        post.saveInBackgroundWithBlock(nil)
        self.performSegueWithIdentifier("MainPageTableViewController", sender: self.navigationItem.rightBarButtonItem)
    }
    
    func addLeftBarItem(){
        let leftBarItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "leftBarButtonAction")
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func leftBarButtonAction(){
        self.performSegueWithIdentifier("MainPageTableViewController", sender: navigationController?.navigationItem.leftBarButtonItem)
    }
}
