//
//  LNBandingPhoneViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/19.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyUserDefaults
class LNBandingPhoneViewController: LNBaseViewController {

    @IBOutlet weak var phone_number: UITextField!
    
    @IBOutlet weak var yanzheng_code: UITextField!
    
    @IBOutlet weak var new_password: UITextField!
    
    @IBOutlet weak var send_code: UIButton!
    
    @IBOutlet weak var show_paw: UIButton!
    
    @IBOutlet weak var certian: UIButton!
    
    @IBOutlet weak var top_space: NSLayoutConstraint!
    //声明定时器
    fileprivate var timer = Timer()
    
    fileprivate var timeNow = 59
    
    @IBOutlet weak var bgheight: NSLayoutConstraint!
    @IBOutlet weak var bgtop: NSLayoutConstraint!
    fileprivate var btnTitleStr = String()
    
    var typeBollStr = ""   // 5.表示弹框没有绑定手号 4.商品详情跳转时用的
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Device() == .iPhoneX {
            bgheight.constant = 208 + 20
            bgtop.constant = 70 + 20
        }
        if kSCREEN_HEIGHT == 812 {
            bgheight.constant = 208 + 20
            bgtop.constant = 70 + 20
        }
        titleLabel.text = "绑定手机号"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
        
        top_space.constant = 160+44
        certian.backgroundColor = kMainColor1()

        certian.clipsToBounds = true
        certian.cornerRadius = certian.height/2
        
        send_code.clipsToBounds = true
        send_code.cornerRadius = send_code.height / 2
        btnTitle = "暂不绑定"
        
        if typeBollStr == "5" || typeBollStr == "4" {
            backBtn.isHidden = true
        }
    }
    
    @objc fileprivate func changeBtnTitle(){
        
        timeNow = timeNow-1
        
        if timeNow < 0 {
            send_code.isEnabled = true
            send_code.setTitle("获取验证码", for: .normal)
            invalidateTimer()
            timeNow = 60
        }else{
            send_code.isEnabled = false
            send_code.setTitle("\(timeNow)s后重新发送", for: .normal)
        }
    }
    
    override func backAction(sender: UIButton) {
//        if (self.navigationController?.childViewControllers.count)! == 1 {
//            self.dismiss(animated: true, completion: nil)
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
        self.view.window?.rootViewController = LNMainTabBarController()
    }
    //    定时器失效
    fileprivate func invalidateTimer() {
        timer.invalidate()
    }
    
    @IBAction func sendCode(_ sender: UIButton) {
        
        if phone_number.text?.count == 0 {
            setToast(str: "手机号不能为空")
            return
        }
        
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        
        let request = SKRequest.init()
        request.setParam(phone_number.text! as NSObject, forKey: "phone")
        
        request.callGET(withUrl: LNUrls().KSendSms) { (response) in
            
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            
            weakSelf?.invalidateTimer()
            weakSelf?.timeNow = 60
            sender.isEnabled = false
            weakSelf?.btnTitleStr = String((weakSelf?.timeNow)!)+"s后重新发送"
            weakSelf?.send_code.setTitle(weakSelf?.btnTitleStr, for: .normal)
            weakSelf?.send_code.becomeFirstResponder()
            
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.changeBtnTitle), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer, forMode: .commonModes)
            }
        }
    }
    
    
    
    override func rightAction(sender: UIButton) {
//        if (self.navigationController?.childViewControllers.count)! == 1 {
//            self.dismiss(animated: true, completion: nil)
//        }else{
//            self.view.window?.rootViewController = LNMainTabBarController()
//        }
        view.endEditing(true)
        if typeBollStr == "5" || typeBollStr == "4" {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.view.window?.rootViewController = LNMainTabBarController()
        }
    }
    
    @IBAction func showPaw(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        new_password.isSecureTextEntry = !sender.isSelected
    }
    
    
    @IBAction func certainAction(_ sender: UIButton) {
        
        if phone_number.text?.count == 0 {
            setToast(str: "请输入手机号")
            return
        }
        
        if yanzheng_code.text?.count == 0 {
            setToast(str: "请输入验证码")
            return
        }
        
        if new_password.text?.count == 0 {
            setToast(str: "请输入密码")
            return
        }
        
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        
        let request = SKRequest.init()
        request.setParam(phone_number.text! as NSObject, forKey: "phone")
        request.setParam(yanzheng_code.text! as NSObject, forKey: "code")
        request.setParam(new_password.text! as NSObject, forKey: "password")
        
        request.callGET(withUrl: LNUrls().mobilekBaningMobile) { (response) in
            
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                setToast(str: "绑定手机号失败!")
                return
            }
            Defaults[kBandingPhone] = "1"
            setToast(str: "绑定手机号成功!")
            
            if weakSelf?.typeBollStr == "4" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().SZYGoodsViewController), object: self, userInfo: nil)
            }
            
            if Defaults[kBandingInviter] == "1" {
                weakSelf?.view.window?.rootViewController = LNMainTabBarController()
            } else {
                weakSelf?.navigationController?.pushViewController(LNBandingCodeViewController(), animated: true)
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        invalidateTimer()
    }
    
}
