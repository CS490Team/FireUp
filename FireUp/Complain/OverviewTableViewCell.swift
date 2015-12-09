//
//  OverviewTableViewCell.swift
//  Fire Up
//
//  Created by HuangHanxun on 11/5/15.
//  Copyright © 2015 sunkai. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!

    @IBOutlet var messageIndicator: UIView!
    @IBOutlet var userProfileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
