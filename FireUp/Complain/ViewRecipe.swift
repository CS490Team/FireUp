//
//  ViewRecipe.swift
//  Fire Up
//
//  Created by Di Yao on 12/6/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import Foundation
import UIKit

class ViewRecipe : UIViewController {
    
    @IBOutlet weak var recipetitle: UITextView!
    @IBOutlet weak var image: UIImageView!
    //@IBOutlet weak var recipe: UITextView!
    
    var TRTitle:String!
    var TRImage:UIImage!
    var TRRecipe:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //do any additional setup after loading the view.
        
        
        recipetitle.text = TRTitle
        image.image = TRImage
        //recipe.text = TRRecipe
        
        image.image = TRImage
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.whiteColor().CGColor
        //image.layer.cornerRadius =  image.frame.size.width/2
        image.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated.
    }
    
    
}