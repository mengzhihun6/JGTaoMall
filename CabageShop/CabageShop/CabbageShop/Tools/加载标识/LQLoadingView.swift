//
//  LQLoadingView.swift
//  LingQuan
//
//  Created by 付耀辉 on 2018/6/3.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SVProgressHUD

class LQLoadingView: NSObject {
    let gray = 69
    
    //可控制的
    public func SVPWillControllerShow(_ str: String) {
        
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: "\(str)")
        }
    }
    
    public func SVPwillControllerShowAndHide() {
        
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setMinimumDismissTimeInterval(1.0)
            //    SVProgressHUD.showError(withStatus: str)
        }
    }
    
    
    public func SVPWillShow(_ str: String) {
        
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: "\(str)")
        }
    }
    
    public func SVPwillShowAndHide(_ str: String) {
        
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setMinimumDismissTimeInterval(1.0)
            SVProgressHUD.show(withStatus: str)
        }
    }
    
    public func SVPwillShowAndHideNoText() {
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.setMinimumDismissTimeInterval(1.0)
            SVProgressHUD.show()
        }

    }
    
    
    public func SVPwillShowAndHideNoText1() {
        
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
            //        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
                    SVProgressHUD.show()
        }
    }


    
    public func SVPErrorwillShowAndHide(_ str: String) {

        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setMinimumDismissTimeInterval(1.0)
            SVProgressHUD.showError(withStatus: str)
        }
    }
    public func SVPwillSuccessShowAndHide(_ str: String) {
        
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(kGaryColor(num: self.gray))
            SVProgressHUD.setForegroundColor(UIColor.white)
            //    SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setMinimumDismissTimeInterval(1.0)
            SVProgressHUD.showSuccess(withStatus: str)
        }
    }
    
    
    
    public func SVPHide() {
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

    public func SVPHideq() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

}
