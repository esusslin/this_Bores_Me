//
//  newsCell.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 1/7/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import UIKit

class newsCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // constraints
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        infoLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-10-[ava(30)]-10-[username]-7-[info]-7-[date]",
            options: [], metrics: nil, views: ["ava":avatarImage, "username":usernameBtn, "info":infoLbl, "date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[ava(30)]-10-|",
            options: [], metrics: nil, views: ["ava":avatarImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[username(30)]",
            options: [], metrics: nil, views: ["username":usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[info(30)]",
            options: [], metrics: nil, views: ["info":infoLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[date(30)]",
            options: [], metrics: nil, views: ["date":dateLbl]))
        
        // round ava
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        
    }

}
