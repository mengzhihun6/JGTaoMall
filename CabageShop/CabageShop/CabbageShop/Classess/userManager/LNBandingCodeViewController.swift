//
//  LNBandingCodeViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyUserDefaults
import SwiftyJSON

class LNBandingCodeViewController: LNBaseViewController {
    
    @IBOutlet weak var invite_code: UITextField!  //验证码
    
    
    @IBOutlet weak var inviter_icon: UIImageView!  //上级头像
    @IBOutlet weak var inviter_name: UILabel!
    
    @IBOutlet weak var bgView: UIView!
//    @IBOutlet weak var bgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bgtop: NSLayoutConstraint!
    @IBOutlet weak var bgheight: NSLayoutConstraint!
    @IBOutlet weak var certian: UIButton!   //按钮
    
    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    var ytpeStr = ""
    var typeBollStr = ""   // 5.表示弹框没有绑定邀请码  4.商品详情跳转时用的
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "绑定邀请码"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
        if Device() == .iPhoneX {
            bgheight.constant = 208 + 20
            bgtop.constant = 70 + 20
        }
        if kSCREEN_HEIGHT == 812 {
            bgheight.constant = 208 + 20
            bgtop.constant = 70 + 20
        }
//        top_space.constant = 160+44
        
        certian.clipsToBounds = true
        certian.cornerRadius = certian.height/2
        certian.isUserInteractionEnabled = false
//        certian.backgroundColor = kMainColor1()

//        bgView.clipsToBounds = true
//        bgView.cornerRadius = 4
        
        inviter_icon.clipsToBounds = true
        inviter_icon.cornerRadius = inviter_icon.height/2
        
//        bgView.isHidden = true
//        bgHeight.constant = 0
        
        btnTitle = "暂不绑定"
        if typeBollStr == "5" || typeBollStr == "4" {
            backBtn.isHidden = true
        }
    }
    
    override func rightAction(sender: UIButton) {
//        if (self.navigationController?.childViewControllers.count)! == 1 {
//            self.dismiss(animated: true, completion: nil)
//            view.window?.rootViewController = LNMainTabBarController()
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
//        if ytpeStr == "1" {
//            view.window?.rootViewController = LNMainTabBarController()
//        } else {
//            self.navigationController?.popViewController(animated: true)
//        }
        view.endEditing(true)
        if typeBollStr == "5" || typeBollStr == "4" {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.view.window?.rootViewController = LNMainTabBarController()
        }
    }

    
    @IBAction func textDidChangedAction(_ sender: UITextField) {
        let strText = sender.text!.replacingOccurrences(of: " ", with: "")
        if strText.count >= 1 {
            certian.setTitle("确认绑定", for: .normal)
            certian.isUserInteractionEnabled = true
            certian.backgroundColor = kMainColor1()
            weak var weakSelf = self
//            invite_code.resignFirstResponder()
            let request = SKRequest.init()
            request.setParam(invite_code.text! as NSObject, forKey: "tag")
            request.callGET(withUrl: LNUrls().kGetInviter) { (response) in
                kDeBugPrint(item: response?.data)
                if !(response?.success)! {
                    weakSelf?.inviter_icon.image = UIImage.init(named: "")
                    return
                }
                let data = JSON((response?.data)!)["data"]
                DispatchQueue.main.async {
                    weakSelf?.inviter_icon.sd_setImage(with: OCTools.getEfficientAddress(data["headimgurl"].stringValue), placeholderImage: UIImage.init(named: "goodImage_1"))
//                    weakSelf?.inviter_name.text = data["nickname"].stringValue
//                    weakSelf?.bgView.isHidden = false
//                    weakSelf?.bgHeight.constant = 60
                }
            }
        }
    }
    
    override func backAction(sender: UIButton) {
//        if (self.navigationController?.childViewControllers.count)! == 1 {
//            self.dismiss(animated: true, completion: nil)
//        }else{
//            self.view.window?.rootViewController = LNMainTabBarController()
//        }
        self.view.window?.rootViewController = LNMainTabBarController()
    }
    
    @IBAction func certainAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if invite_code.text?.count == 0 {
            setToast(str: "请输入邀请码")
            return
        }
        
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        
        let request = SKRequest.init()
        request.setParam(invite_code.text! as NSObject, forKey: "number")
        
        request.callGET(withUrl: LNUrls().mobilekBaningInviter) { (response) in
            
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                setToast(str: "绑定失败!")
                return
            }
            Defaults[kBandingPhone] = "1"
            Defaults[kBandingInviter] = "1"
            setToast(str: "绑定成功!")
            
            if weakSelf?.typeBollStr == "4" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().SZYGoodsViewController), object: self, userInfo: nil)
            }
            
            if isBanding {
                weakSelf?.navigationController?.dismiss(animated: true, completion: nil)
            }else{
                weakSelf?.view.window?.rootViewController = LNMainTabBarController()
            }
        }
    }
    
}
