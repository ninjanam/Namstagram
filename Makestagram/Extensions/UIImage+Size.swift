//
//  UIImage+Size.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/11/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import UIKit

extension UIImage {
    
    // calculate the aspect height for the instance of a UIImage based on
    // the size property of an image
    var aspectHeight: CGFloat {
        
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
    }
}
