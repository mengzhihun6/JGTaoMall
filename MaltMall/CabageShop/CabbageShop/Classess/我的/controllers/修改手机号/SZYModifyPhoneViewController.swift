//
//  SZYModifyPhoneViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/15.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class SZYModifyPhoneViewController: LNBaseViewController {
    
    
    @IBOutlet weak var textField_Top: NSLayoutConstraint!
    @IBOutlet weak var iPhoneTextField: UITextField!
    @IBOutlet weak var huoquCodeBun: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var xiugaiBun: UIButton!
    
    //声明定时器
    fileprivate var timer = Timer()
    fileprivate var timeNow = 59
    fileprivate var btnTitleStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationTitle = "修改手机号"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.black
        textField_Top.constant = navHeight + 50
        
        huoquCodeBun.cornerRadius = 5
        huoquCodeBun.clipsToBounds = true
        
        xiugaiBun.cornerRadius = 5
        xiugaiBun.clipsToBounds = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        invalidateTimer()
    }
    @IBAction func codeBun(_ sender: UIButton) {
        if iPhoneTextField.text?.count == 0 {
            setToast(str: "手机号不能为空")
            return
        }
        
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        
        let request = SKRequest.init()
        request.setParam(iPhoneTextField.text! as NSObject, forKey: "phone")
        
        request.callGET(withUrl: LNUrls().KSendSms) { (response) in
            
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            
            weakSelf?.invalidateTimer()
            weakSelf?.timeNow = 60
            sender.isEnabled = false
            weakSelf?.btnTitleStr = String((weakSelf?.timeNow)!)+"s后重新发送"
            weakSelf?.huoquCodeBun.setTitle(weakSelf?.btnTitleStr, for: .normal)
            weakSelf?.huoquCodeBun.becomeFirstResponder()
            
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.changeBtnTitle), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer, forMode: .commonModes)
            }
        }
        
    }
    @objc fileprivate func changeBtnTitle() {
        timeNow = timeNow - 1
        if timeNow < 0 {
            huoquCodeBun.isEnabled = true
            huoquCodeBun.setTitle("获取验证码", for: .normal)
            invalidateTimer()
            timeNow = 60
        }else{
            huoquCodeBun.isEnabled = false
            huoquCodeBun.setTitle("\(timeNow)s后重新发送", for: .normal)
        }
    }
    //    定时器失效
    fileprivate func invalidateTimer() {
        timer.invalidate()
    }
    
    @IBAction func xiugaiBun(_ sender: UIButton) {
        
        if iPhoneTextField.text?.count == 0 {
            setToast(str: "请输入手机号")
            return
        }
        if codeTextField.text?.count == 0 {
            setToast(str: "请输入验证码")
            return
        }
        let request = SKRequest.init()
        request.setParam(iPhoneTextField.text! as NSObject, forKey: "phone")
        request.setParam(codeTextField.text! as NSObject, forKey: "code")
        request.callGET(withUrl: LNUrls().kModifyPhone) { (response) in
            if !(response?.success)! {
                return
            }
            setToast(str: "手机号修改成功!")
            NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LNChangePersonalInfo), object: self, userInfo: nil)
        }
    }
    
}
