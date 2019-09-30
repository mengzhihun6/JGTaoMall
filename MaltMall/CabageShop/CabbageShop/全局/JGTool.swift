//
//  JGTool.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/8/27.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit

var isIphoneX: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
            || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}


/// 尺寸相关
let kDeviceWidth = UIScreen.main.bounds.width
let kDeviceHight = UIScreen.main.bounds.height
let SJHeight = isIphoneX ? 86 : 64
let IphoneXTabbarH = isIphoneX ? 83 : 49

//这里的375我是针对6为标准适配的,如果需要其他标准可以修改
func kWidthScale(_ R:CGFloat) -> CGFloat {
    return ((R)*(kDeviceWidth/375.0))
}

/// 颜色相关
let JGMainColor:UIColor = UIColor.hex("#000000")


//MARK: print
func JGLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

