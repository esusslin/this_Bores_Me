//
//  imageSynch.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/11/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.
//

import Foundation
import UIKit

func getImageFromURL(url: String, result: (image: UIImage?) ->Void) {
    
    let URL = NSURL(string: url)
    //    print(URL)
    
    let downloadQue = dispatch_queue_create("imageDownloadQue", nil)
    
    dispatch_async(downloadQue) { () -> Void in
        let data = NSData(contentsOfURL: URL!)
        
        //        print(data)
        
        let image: UIImage!
        
        //        print(image)
        
        if data != nil {
            image = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue()) {
                result(image: image)
            }
        }
    }
}

