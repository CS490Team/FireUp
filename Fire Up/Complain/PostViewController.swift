//
//  PostViewController.swift
//  Complain
//
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
    
    func shouldUpload(var theImage: UIImage) -> UIImage{
        let width:CGFloat = 500
        let height:CGFloat = 500
        
        let size = CGSizeMake(width, height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        theImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
    func sizeCheck(imageSize: Int) -> Bool{
        if(imageSize > 10485760){
            return false
        }else{
            return true
        }
    }

    func rightBarButtonAction(){
        let post = PFObject(className: "feed")
        post["text"] = addText.text
        
        let orginImage = addPhoto.currentImage!
        let resizedImage = shouldUpload(orginImage)
        
        
        let imageData = UIImagePNGRepresentation(resizedImage)
        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        post["image"] = imageFile
        post["feeder"] = PFUser.currentUser()
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
