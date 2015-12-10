//
//  FilterDisplayViewController.swift
//  Fire Up
//
//  Created by Kai Sun on 12/9/15.
//
//

import UIKit

class FilterDisplayViewController: UIViewController {
    
    var selectedFilter: Int = 0;
    
    @IBOutlet var all:UIButton!
    @IBOutlet var locationSharing:UIButton!
    @IBOutlet var sameCity:UIButton!
    @IBOutlet var byDistance:UIButton!
    
    @IBOutlet var sanshi:UIButton!
    @IBOutlet var liushi:UIButton!
    @IBOutlet var yibai:UIButton!
    
    @IBOutlet var sanshiL:UILabel!
    @IBOutlet var liushiL:UILabel!
    @IBOutlet var yibanL:UILabel!
    
    @IBAction func allF(sender: UIButton){
        all.setImage(UIImage(named: "check"), forState: .Normal)
        locationSharing.setImage(UIImage(named: "unckeck"), forState: .Normal)
        sameCity.setImage(UIImage(named: "unckeck"), forState: .Normal)
        byDistance.setImage(UIImage(named: "unckeck"), forState: .Normal)
    
    }
    
    @IBAction func locationSharingF(sender: UIButton){
        all.setImage(UIImage(named: "unckeck"), forState: .Normal)
        locationSharing.setImage(UIImage(named: "check"), forState: .Normal)
        sameCity.setImage(UIImage(named: "unckeck"), forState: .Normal)
        byDistance.setImage(UIImage(named: "unckeck"), forState: .Normal)
    }
    
    @IBAction func sameCityF(sender: UIButton){
        all.setImage(UIImage(named: "unckeck"), forState: .Normal)
        locationSharing.setImage(UIImage(named: "unckeck"), forState: .Normal)
        sameCity.setImage(UIImage(named: "check"), forState: .Normal)
        byDistance.setImage(UIImage(named: "unckeck"), forState: .Normal)
        
    }
    
    @IBAction func byDistanceF(sender: UIButton){
        all.setImage(UIImage(named: "unckeck"), forState: .Normal)
        locationSharing.setImage(UIImage(named: "unckeck"), forState: .Normal)
        sameCity.setImage(UIImage(named: "unckeck"), forState: .Normal)
        byDistance.setImage(UIImage(named: "check"), forState: .Normal)
        
    }
    
    @IBAction func sanshiF(sender: UIButton){
        
    }
    
    @IBAction func liushiF(sender: UIButton){
        
    }
    
    @IBAction func yibaiF(sender: UIButton){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        addLeftBarItem()
        sanshi.hidden = true
        liushi.hidden = true
        yibai.hidden = true
        sanshiL.hidden = true
        liushiL.hidden = true
        yibanL.hidden = true
        
        sanshi.enabled = false
        sanshi.enabled = false
        sanshi.enabled = false
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
