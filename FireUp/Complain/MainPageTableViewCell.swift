//
//  MainPageTableViewCell.swift
//
//  Copyright (c) 2015 sunkai. All rights reserved.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {
    
    @IBOutlet var TheImage: PFImageView! = PFImageView()

    @IBOutlet weak var TheText: UITextView!
    
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBOutlet weak var UserName: UIButton!
    
    @IBOutlet var thumbnailImage: PFImageView! = PFImageView()
    
    @IBOutlet weak var Location: UIButton!
    @IBOutlet weak var LocationImage: UIButton!
    var Username:String!
    var Title:String!
    var Recipe:String!
    var feedCity:String!
    var feedState:String!
    var share:Bool = false
    
    func reset(){
        Location.hidden = true
        LocationImage.hidden = true
    }
}
