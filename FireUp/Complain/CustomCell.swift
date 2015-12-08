//
//  CustomCell.swift
//  AutoLayoutButtonInCell
//
//  Created by Kubilay Erdogan on 30/06/15.
//  Copyright (c) 2015 kublaios. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var myButton: UIButton?
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        self.myButton?.titleLabel?.numberOfLines = 0
        self.myButton?.titleLabel?.textAlignment = NSTextAlignment.Center
        self.myButton?.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    override func updateConstraints() {
        self.myButton?.layoutIfNeeded()
        self.myButton?.titleLabel?.preferredMaxLayoutWidth = self.myButton!.titleLabel!.frame.size.width
        super.updateConstraints()
    }
    
}