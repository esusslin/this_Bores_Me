//
//  pictureCell.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/22/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//


import UIKit

class pictureCell: UICollectionViewCell {
    
    @IBOutlet weak var picImg: UIImageView!
    
    //default func
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = UIScreen.mainScreen().bounds.width
        
        picImg.frame = CGRectMake(0, 0, width / 3, width / 3)
    }
}

