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
    
    var Username:String!
    var Title:String!
    var Recipe:String!
    
}
