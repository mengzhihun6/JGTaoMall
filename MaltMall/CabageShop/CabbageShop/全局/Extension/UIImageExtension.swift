//
//  UIImageExtension.swift
//  FD_Rider_Swift
//
//  Created by 郭军 on 2019/6/11.
//  Copyright © 2019 JG. All rights reserved.
//

import UIKit

extension UIImage{
    
    /// 更改图片颜色
    public class func imageWithColor(color : UIColor) -> UIImage{
        let rect = CGRect.init(x:0, y:0, width:1.0, height:1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
