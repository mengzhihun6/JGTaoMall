//
//  AppDelegate_file.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/5/5.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

extension AppDelegate {
    
    class func tiaozhuan() {
        
        let request = SKRequest.init()
        request.callGET(withUrl: LNUrls().kVersion) { (response) in
//            kDeBugPrint(item: "nihaodfhu8gi\(response?.data)")
            var appVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String// App 版本号  //主程序版本号
            appVersion = appVersion.replacingOccurrences(of: ".", with: "")
            if !(response?.success)! {
                return
            }
            var datas =  JSON((response?.data["data"])!)["ios"]["versionName"].stringValue
            datas = datas.replacingOccurrences(of: ".", with: "")
            kDeBugPrint(item: "appVersion = \(appVersion)     datas = \(datas)")
            if StringToFloat(str: appVersion) < StringToFloat(str: datas) {
                let alertController = UIAlertController(title: JSON((response?.data["data"])!)["ios"]["title"].stringValue, message: JSON((response?.data["data"])!)["ios"]["content"].stringValue, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "去更新", style: .default, handler: {
                    action in
                    print("点击了去更新")
                    let appNsUrl = NSURL(string: "https://itunes.apple.com/cn/app/id1445381198?mt=8")
                    UIApplication.shared.openURL(appNsUrl! as URL)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
}
