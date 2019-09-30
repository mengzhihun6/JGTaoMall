//
//  LNBandingAlipayViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/15.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNBandingAlipayViewController: LNBaseViewController {

    @IBOutlet weak var aliAccount: UITextField!
    
    @IBOutlet weak var realName: UITextField!
    
    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var yanzhengCode: UITextField!
    
    @IBOutlet weak var certain: UIButton!
    
    @IBOutlet weak var sendCode: UIButton!
    
    @IBOutlet weak var top_sapce: NSLayoutConstraint!
    
    //声明定时器
    fileprivate var timer = Timer()
    
    fileprivate var timeNow = 59

    var model = LNMemberModel()

    //    回调
    typealias swiftBlock = (_ aliNum:String, _ realName:String) -> Void
    var willClick : swiftBlock? = nil
    @objc func callKeywordBlock(block: @escaping (_ aliNum:String, _ realName:String) -> Void ) {
        willClick = block
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        titleLabel.text = "绑定支付宝"
        titleLabel.textColor = UIColor.white
        
        top_sapce.constant = navHeight+20
        
        certain.clipsToBounds = true
        certain.cornerRadius = 6
        
        phoneNum.delegate = self
        phoneNum.tag = 1001
        
        aliAccount.text = model.alipay
        realName.text = model.realname
        phoneNum.text = model.phone
    }
    
    @IBAction func sendCodeAction(_ sender: UIButton) {
        
        if phoneNum.text?.count == 0 {
            setToast(str: "手机号不能为空")
            return
        }
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        
        let request = SKRequest.init()
        request.setParam(phoneNum.text! as NSObject, forKey: "phone")
        
        request.callGET(withUrl: LNUrls().KSendSms) { (response) in
            
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            
            weakSelf?.invalidateTimer()
            weakSelf?.timeNow = 60
            sender.isEnabled = false
            let btnTitleStr = String((weakSelf?.timeNow)!)+"s后重新发送"
            weakSelf?.sendCode.setTitle(btnTitleStr, for: .normal)
            weakSelf?.sendCode.becomeFirstResponder()
            
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.changeBtnTitle), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer, forMode: .commonModes)
            }
        }

    }
    
    @IBAction func certainAction(_ sender: UIButton) {
        
        if aliAccount.text?.count == 0 {
            setToast(str: "请输入支付宝账号")
            return
        }
        
        if realName.text?.count == 0 {
            setToast(str: "请输入姓名")
            return
        }
        
        if yanzhengCode.text?.count == 0 {
            setToast(str: "请输入验证码")
            return
        }
        
        let request = SKRequest.init()
        request.setParam(aliAccount.text! as NSObject, forKey: "alipay")
        request.setParam(realName.text! as NSObject, forKey: "realname")
        request.setParam(model.phone as NSObject, forKey: "phone")
        request.setParam(yanzhengCode.text! as NSObject, forKey: "code")
        weak var weakSelf = self
        request.callPOST(withUrl: LNUrls().kBind_alipay) { (response) in
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }

                if weakSelf?.willClick != nil {
                    weakSelf?.willClick!((weakSelf?.aliAccount.text!)!,(weakSelf?.realName.text!)!)
                }
                weakSelf?.navigationController?.popViewController(animated: true)
            }
        }
    }

    
    @objc fileprivate func changeBtnTitle(){
        
        timeNow = timeNow-1
        
        if timeNow < 0 {
            sendCode.isEnabled = true
            sendCode.setTitle("发送验证码", for: .normal)
            invalidateTimer()
            timeNow = 60
        }else{
            sendCode.isEnabled = false
            sendCode.setTitle("\(timeNow)s后重新发送", for: .normal)
        }
    }
    
    //    定时器失效
    fileprivate func invalidateTimer() {
        timer.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        invalidateTimer()
    }

    
}

extension LNBandingAlipayViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1001 {
            setToast(str: "手机号不能修改")
            return false
        }else{
            return true
        }
    }
}
