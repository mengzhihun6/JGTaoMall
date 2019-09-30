//
//  JGForgotPwdViewController.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/8/28.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import DeviceKit
import SwiftyJSON


class JGForgotPwdViewController: LNBaseViewController {

    private lazy var phone_number: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = UITextField.ViewMode.always
        tf.textAlignment = NSTextAlignment.center
        tf.backgroundColor = UIColor.hex("#3E3F46")
        tf.placeholder = "请输入手机号"
        tf.setValue(UIColor.hex("#979797"), forKeyPath: "_placeholderLabel.textColor")
        tf.font = UIFont.font(size: 14)
        return tf;
    }()
    
    private lazy var codeTF: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = UITextField.ViewMode.always
        tf.textAlignment = NSTextAlignment.center
        tf.backgroundColor = UIColor.hex("#3E3F46")
        tf.placeholder = "请输入验证码"
        tf.setValue(UIColor.hex("#979797"), forKeyPath: "_placeholderLabel.textColor")
        tf.font = UIFont.font(size: 14)
        return tf;
    }()
 
    private lazy var sendCodeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("获取验证码", for: .normal)
        button.titleLabel?.font = UIFont.font(size: 14)
        button.addTarget(self, action: #selector(sendCodeBtnClick), for: .touchUpInside)
        return button;
    }()
    
    
    private lazy var password: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = UITextField.ViewMode.always
        tf.textAlignment = NSTextAlignment.center
        tf.backgroundColor = UIColor.hex("#3E3F46")
        tf.placeholder = "请输入密码"
        tf.isSecureTextEntry = true
        tf.setValue(UIColor.hex("#979797"), forKeyPath: "_placeholderLabel.textColor")
        tf.font = UIFont.font(size: 14)
        return tf;
    }()
    
    private lazy var LoginBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 0, width: kDeviceWidth - 40, height: 50))
        button.layer.cornerRadius = 7.0
        button.clipsToBounds = true
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = UIFont.font(size: 14)
        button.setTitleColor(UIColor.hex("#2F3035"), for: .normal)
        button.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor.hex("#EBD9AE").cgColor,UIColor.hex("#C4A364").cgColor])
        button.addTarget(self, action: #selector(LoginBtnClick), for: .touchUpInside)
        return button;
    }()
    
    private lazy var WXBtn: UIButton = {
        let button = UIButton()
        button.setTitle("微信登录", for: .normal)
        button.titleLabel?.font = UIFont.font(size: 14)
        button.setImage(UIImage(named: "jg_wechat"), for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.layoutButton(with: MKButtonEdgeInsetsStyle.left, imageTitleSpace: 2)
        button.addTarget(self, action: #selector(WXBtnClick), for: .touchUpInside)
        return button;
    }()
    
    
    private lazy var RegisterBtn: UIButton = {
        let button = UIButton()
        button.setTitle("注册", for: .normal)
        button.titleLabel?.font = UIFont.font(size: 14)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.addTarget(self, action: #selector(RegisterBtnClick), for: .touchUpInside)
        return button;
    }()
    
    //声明定时器
    fileprivate var timer = Timer()
    
    fileprivate var timeNow = 59
    
    fileprivate var btnTitleStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    
    ///发送验证码
    @objc func sendCodeBtnClick() {
        
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
            self.sendCodeBtn.isEnabled = false
            weakSelf?.btnTitleStr = String((weakSelf?.timeNow)!)+"s后重新发送"
            weakSelf?.sendCodeBtn.setTitle(weakSelf?.btnTitle, for: .normal)
            weakSelf?.sendCodeBtn.becomeFirstResponder()
            
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.changeBtnTitle), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer, forMode: .commonModes)
            }
        }
    }
    
    
    @objc fileprivate func changeBtnTitle(){
        
        timeNow = timeNow-1
        
        if timeNow < 0 {
            sendCodeBtn.isEnabled = true
            sendCodeBtn.setTitle("获取验证码", for: .normal)
            invalidateTimer()
            timeNow = 60
        }else{
            sendCodeBtn.isEnabled = false
            sendCodeBtn.setTitle("\(timeNow)s后重新发送", for: .normal)
        }
    }
    
    //    定时器失效
    fileprivate func invalidateTimer() {
        timer.invalidate()
    }
    
    
    func configUI() {
        
        let bg_icon = UIImageView()
        bg_icon.image = UIImage(named: "login_bg")

        
        let LoginLbl = UILabel()
        LoginLbl.text = "找\t 回\t 密\t 码"
        LoginLbl.textColor = UIColor.hex("#C4A364")
        LoginLbl.font =  UIFont.boldFont(30)
        
        
        let InfoLbl = UILabel()
        InfoLbl.text = "注册登陆后购物即可享受麦芽返佣"
        InfoLbl.textColor = UIColor.hex("#CBCBCB")
        InfoLbl.font =  UIFont.font(size: 14)
        
        
         self.view.insertSubview(bg_icon, at: 0)
        self.view.addSubview(LoginLbl)
        self.view.addSubview(InfoLbl)
        self.view.addSubview(phone_number)
        self.view.addSubview(codeTF)
        self.view.addSubview(sendCodeBtn)
        self.view.addSubview(password)
        self.view.addSubview(LoginBtn)
        self.view.addSubview(WXBtn)
        self.view.addSubview(RegisterBtn)
        
        
        
        bg_icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        LoginLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(SJHeight+61)
            make.centerX.equalToSuperview()
        }
        
        InfoLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(LoginLbl.snp_bottom).offset(25)
        }
        
        phone_number.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(InfoLbl.snp_bottom).offset(50)
            make.height.equalTo(55)
        }
        
        codeTF.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phone_number)
            make.top.equalTo(phone_number.snp_bottom).offset(15)
        }
        
        sendCodeBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(codeTF)
            make.width.equalTo(100)
        }
        
        password.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phone_number)
            make.top.equalTo(codeTF.snp_bottom).offset(15)
        }
        
        LoginBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phone_number)
            make.top.equalTo(password.snp_bottom).offset(15)
        }
        
        let W = (kDeviceWidth - 40) / 3.0
        
        WXBtn.snp.makeConstraints { (make) in
            make.left.equalTo(LoginBtn.snp_left)
            make.top.equalTo(LoginBtn.snp_bottom)
            make.height.equalTo(50)
            make.width.equalTo(W)
        }
        
        RegisterBtn.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(WXBtn)
            make.right.equalTo(LoginBtn.snp_right)
        }
    }
    
    
    
    @objc func LoginBtnClick() {
        
        if phone_number.text?.count == 0 {
            setToast(str: "请输入手机号")
            return
        }
        
        if codeTF.text?.count == 0 {
            setToast(str: "请输入验证码")
            return
        }
        
        if password.text?.count == 0 {
            setToast(str: "请输入密码")
            return
        }
        
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        
        let request = SKRequest.init()
        request.setParam(phone_number.text! as NSObject, forKey: "phone")
        request.setParam(codeTF.text! as NSObject, forKey: "code")
        request.setParam(password.text! as NSObject, forKey: "password")
        request.setParam(password.text! as NSObject, forKey: "password_confirmation")
        
        request.callPOST(withUrl: LNUrls().kReset_password) { (response) in
            
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                setToast(str: "更改密码失败!")
                return
            }
            
            setToast(str: "更改密码成功!")
            weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func WXBtnClick() {
        
        LQLoadingView().SVPwillShowAndHideNoText()
        
        ShareSDK.getUserInfo(.typeWechat) { (state, user, error) in
            if error != nil {
                LQLoadingView().SVPHide()
                setToast(str: error.debugDescription)
                return
            }
            
            if user == nil {
                LQLoadingView().SVPHide()
                return
            }
            
            kDeBugPrint(item: user?.credential)
            kDeBugPrint(item: user?.credential.token)
            
            kDeBugPrint(item: user?.uid)
            kDeBugPrint(item: user?.nickname)
            kDeBugPrint(item: user?.icon)
            
            kDeBugPrint(item: user)
            
            Defaults[kUserToken] = user?.credential.token
            Defaults[kUserUiid] = user?.credential.uid
            Defaults[kUsername] = user?.nickname
            Defaults[kUserIcon] = user?.icon
            let userInfo = JSON((user?.dictionaryValue())!)["rawData"]
            isBanding = false
            
            let request = SKRequest.init()
            request.setParam("wechat" as NSObject, forKey: "type")
            request.setParam(((userInfo["unionid"]).stringValue as NSObject), forKey: "unionid")
            request.setParam(((userInfo["openid"]).stringValue as NSObject), forKey: "openid")
            request.setParam((user?.nickname)! as NSObject, forKey: "nickname")
            request.setParam((user?.icon)! as NSObject, forKey: "headimgurl")
            
            weak var weakSelf = self
            request.callPOST(withUrl: LNUrls().kLogin) { (response) in
                kDeBugPrint(item: response?.data)
                LQLoadingView().SVPHide()
                if !(response?.success)! {
                    setToast(str: (response?.message!)!)
                    return
                }
                
                let data = JSON((response?.data)!)["data"]
                Defaults[kUserToken] = data["access_token"].stringValue
                UserDefaults.standard.set(Defaults[kUserToken], forKey: "kUserToken")
                Defaults[kSystemDeduct] = data["systemDeduct"].stringValue
                UserDefaults.standard.set(Defaults[kSystemDeduct], forKey: "kSystemDeduct")
                Defaults[kCommissionRate] = data["commissionRate"].stringValue
                UserDefaults.standard.set(Defaults[kCommissionRate], forKey: "kCommissionRate")
                
                Defaults[kUsername] = data["user"]["nickname"].stringValue
                UserDefaults.standard.set(Defaults[kUsername], forKey: "kUsername")
                
                Defaults[kIsSuper_VIP] = data["user"]["level"]["name"].stringValue
                UserDefaults.standard.set(Defaults[kIsSuper_VIP], forKey: "kIsSuper_VIP")
                
                Defaults[kUserIcon] = data["headimgurl"].stringValue
                UserDefaults.standard.set(Defaults[kUserIcon], forKey: "kUserIcon")
                
                var tag = data["tag"].stringValue
                if data["user"]["invite_code"].stringValue != "" {
                    tag = data["user"]["invite_code"].stringValue
                }
                Defaults[kHashid] = tag
                UserDefaults.standard.set(Defaults[kHashid], forKey: "kHashid")
                
                
                UserDefaults.standard.synchronize()
                
                LQLoadingView().SVPHide()
                
                let version = data["group_tag"].stringValue
                let tags = NSSet.init(objects: version) as! Set<String>
                JPUSHService.setTags(tags, completion: { (iResCode, iTags, iAlias) in
                    //                    kDeBugPrint(item: iResCode)
                    //                    kDeBugPrint(item: iTags)
                    //                    kDeBugPrint(item: iAlias)
                }, seq: 1)
                
                let alias = data["tag"].stringValue
                JPUSHService.setAlias(alias, completion: { (int, str, int2) in
                    //                    kDeBugPrint(item: int)
                    //                    kDeBugPrint(item: str)
                    //                    kDeBugPrint(item: int2)
                }, seq: 2)
                
                //                Defaults[kBandingPhone] = "1"
                //                Defaults[kBandingInviter] = "1"
                //                weakSelf?.view.window?.rootViewController = LNMainTabBarController()
                
                if data["user"]["inviter_id"].stringValue.count != 0 && data["user"]["phone"].stringValue.count != 0{
                    Defaults[kBandingPhone] = "1"
                    Defaults[kBandingInviter] = "1"
                    weakSelf?.view.window?.rootViewController = LNMainTabBarController()
                }else{
                    if data["user"]["phone"].stringValue.count == 0 && data["user"]["inviter_id"].stringValue.count == 0 {
                        Defaults[kBandingPhone] = "0"
                        Defaults[kBandingInviter] = "0"
                        
                        weakSelf?.navigationController?.pushViewController(LNBandingPhoneViewController(), animated: true)
                    }else if  data["user"]["phone"].stringValue.count != 0 &&  data["user"]["inviter_id"].stringValue.count == 0{
                        
                        Defaults[kBandingPhone] = "1"
                        Defaults[kBandingInviter] = "0"
                        
                        weakSelf?.navigationController?.pushViewController(LNBandingCodeViewController(), animated: true)
                    }else if  data["user"]["phone"].stringValue.count == 0 &&  data["user"]["inviter_id"].stringValue.count != 0 {
                        Defaults[kBandingPhone] = "0"
                        Defaults[kBandingInviter] = "1"
                        
                        weakSelf?.navigationController?.pushViewController(LNBandingPhoneViewController(), animated: true)
                    } else {
                        Defaults[kBandingPhone] = "0"
                        Defaults[kBandingInviter] = "0"
                        
                        weakSelf?.navigationController?.pushViewController(LNBandingPhoneViewController(), animated: true)
                    }
                }
            }
        }
    }
    

    
    @objc func RegisterBtnClick() {
        
        self.navigationController?.pushViewController(JGRegisterViewController(), animated: true)
    }
    
    
}
