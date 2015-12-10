//
//  FilterDisplayViewController.swift
//  Fire Up
//
//  Created by Kai Sun on 12/9/15.
//
//

import UIKit

class FilterDisplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        addLeftBarItem()
        // Do any additional setup after loading the view.
    }

    func addLeftBarItem(){
        let leftBarItem = UIBarButtonItem()
        leftBarItem.target = self
        leftBarItem.action = "leftBarAction"
        leftBarItem.title = "Back"
        
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func leftBarAction(){
        self.performSegueWithIdentifier("toMain", sender: self.navigationItem.rightBarButtonItem)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toMain"){
            let VC = segue.destinationViewController as! MainPageTableViewController
            VC.filter = 1
        }
    }
}
