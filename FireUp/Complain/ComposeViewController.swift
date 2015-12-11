//
//  ComposeViewController.swift
//  Fire Up
//
//  Created by Yijie Wu on 12/11/15.
//
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var sweetTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sweetTextView.layer.borderColor=UIColor.blackColor().CGColor
        sweetTextView.layer.borderWidth=0.5
        sweetTextView.layer.cornerRadius=5
        sweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSweet(sender: AnyObject) {
        let sweet:PFObject=PFObject(className: "discuss")
        sweet["content"]=sweetTextView.text
        sweet["user"]=PFUser.currentUser()
        sweet.saveInBackgroundWithBlock(nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
