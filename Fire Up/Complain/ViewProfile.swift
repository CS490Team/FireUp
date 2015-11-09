//
//  ViewProfile.swift
//  Fire Up
//
//  Created by Di Yao on 11/4/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class ViewProfile : UIViewController {
    
    
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var add: UIButton!
    
    //var usName = String()
    //var profileArray = [String]()
    
    var TRImage:UIImage!
    var TRUsername:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //do any additional setup after loading the view.
        
        username.text = TRUsername
        userimage.image = TRImage
        
         userimage.image = TRImage
         userimage.layer.borderWidth = 1.0
         userimage.layer.masksToBounds = false
         userimage.layer.borderColor = UIColor.whiteColor().CGColor
         userimage.layer.cornerRadius =  userimage.frame.size.width/2
         userimage.clipsToBounds = true
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("MainPageCell", forIndexPath: indexPath) as! MainPageTableViewCell
    
    cell.textLabel?.text = profileArray[indexPath.row]
    
    return cell
    })
    */
    
    @IBAction func btnClicked(sender: AnyObject) {
        button.setTitle("Followed", forState: .Normal)
        //button.setTitle("Follow", forState: .Normal)
    }
    
    @IBAction func addPeople(sender: UIButton) {
        add.setTitle("Request sent", forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated.
    }
    
}