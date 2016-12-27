//
//  navVC.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/27/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import UIKit

class navVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //color of title at the top of nav controller
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // color of buttons in nav controller
        self.navigationBar.tintColor = UIColor.whiteColor()
        
        //color of background nav controller
        self.navigationBar.barTintColor = UIColor(red: 155.0 / 255.0, green: 159.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
        
        self.navigationBar.translucent = false
        
    }
    
    //white status bar function
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}