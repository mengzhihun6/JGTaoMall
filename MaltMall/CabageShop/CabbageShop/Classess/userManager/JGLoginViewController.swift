//
//  JGLoginViewController.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/8/28.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import DeviceKit
import SwiftyJSON

class JGLoginViewController: LNBaseViewController {

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
        button.titleLabel?.font = UIFont.boldFont(18)
        button.setImage(UIImage(named: "jg_wechat"), for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.layoutButton(with: MKButtonEdgeInsetsStyle.left, imageTitleSpace: 2)
        button.addTarget(self, action: #selector(WXBtnClick), for: .touchUpInside)
        return button;
    }()
    
    
    private lazy var ForgetPwdBtn: UIButton = {
        let button = UIButton()
        button.setTitle("忘记密码", for: .normal)
        button.titleLabel?.font = UIFont.font(size: 14)
        button.addTarget(self, action: #selector(ForgetPwdBtnClick), for: .touchUpInside)
        return button;
    }()
    
//    private lazy var RegisterBtn: UIButton = {
//        let button = UIButton()
//        button.setTitle("注册", for: .normal)
//        button.titleLabel?.font = UIFont.font(size: 14)
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
//        button.addTarget(self, action: #selector(RegisterBtnClick), for: .touchUpInside)
//        return button;
//    }()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        backBtn.isHidden = true;
        
        configUI()
    }
    
    @objc func pressBack() {
        
        if self.presentingViewController == nil {
            Defaults[kBandingPhone] = "1"
            Defaults[kBandingInviter] = "1"
            self.view.window?.rootViewController = LNMainTabBarController()
        }else{
            let tab =   LNMainTabBarController()
            tab.selectIndex = 0
            self.view.window?.rootViewController = tab
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func configUI() {
       
        let bg_icon = UIImageView()
        bg_icon.image = UIImage(named: "login_bg")
        
        let closeLoginBtn = UIButton()
        closeLoginBtn.setImage(UIImage(named: "login_close"), for: .normal)
        closeLoginBtn.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        
        
        let LoginLbl = UILabel()
        LoginLbl.text = "登\t陆"
        LoginLbl.textColor = UIColor.hex("#C4A364")
        LoginLbl.font =  UIFont.boldFont(30)
        
        
        let InfoLbl = UILabel()
        InfoLbl.text = "登陆后购物即可享受麦芽返佣"
        InfoLbl.textColor = UIColor.hex("#CBCBCB")
        InfoLbl.font =  UIFont.font(size: 14)
        
        
        self.view.addSubview(bg_icon)
        self.view.addSubview(closeLoginBtn)
        self.view.addSubview(LoginLbl)
        self.view.addSubview(InfoLbl)
        self.view.addSubview(phone_number)
        self.view.addSubview(password)
        self.view.addSubview(LoginBtn)
        self.view.addSubview(WXBtn)
        self.view.addSubview(ForgetPwdBtn)
//        self.view.addSubview(RegisterBtn)
        
        
        bg_icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        closeLoginBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(SJHeight - 44)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(44)
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
        
        password.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phone_number)
            make.top.equalTo(phone_number.snp_bottom).offset(15)
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
        
        
        ForgetPwdBtn.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(WXBtn)
            make.right.equalTo(LoginBtn.snp_right)
        }
        
    }
    
    
    
    @objc func LoginBtnClick() {
        
        phone_number.resignFirstResponder()
        password.resignFirstResponder()
        
        if phone_number.text?.count == 0 {
            setToast(str: "请输入手机号")
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
        request.setParam(password.text! as NSObject, forKey: "password")
        request.setParam("phone" as NSObject, forKey: "type")
        
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
                kDeBugPrint(item: iResCode)
                kDeBugPrint(item: iTags)
                kDeBugPrint(item: iAlias)
            }, seq: 1)
            
            let alias = data["tag"].stringValue
            JPUSHService.setAlias(alias, completion: { (int, str, int2) in
                kDeBugPrint(item: int)
                kDeBugPrint(item: str)
                kDeBugPrint(item: int2)
            }, seq: 2)
            
            if data["user"]["inviter_id"].stringValue.count != 0 && data["user"]["phone"].stringValue.count != 0{
                Defaults[kBandingPhone] = "1"
                Defaults[kBandingInviter] = "1"
                weakSelf?.view.window?.rootViewController = LNMainTabBarController()
            }else{
                if data["user"]["phone"].stringValue.count == 0 && data["user"]["inviter_id"].stringValue.count == 0 {
                    Defaults[kBandingPhone] = "0"
                    Defaults[kBandingInviter] = "0"
                    weakSelf?.navigationController?.pushViewController(LNBandingPhoneViewController(), animated: true) //绑定手机号
                }else if  data["user"]["phone"].stringValue.count != 0 &&  data["user"]["inviter_id"].stringValue.count == 0{
                    
                    Defaults[kBandingPhone] = "1"
                    Defaults[kBandingInviter] = "0"
                    let vc = LNBandingCodeViewController()
                    vc.ytpeStr = "1"
                    weakSelf?.navigationController?.pushViewController(vc, animated: true) //绑定邀请码
                }else if  data["user"]["phone"].stringValue.count == 0 &&  data["user"]["inviter_id"].stringValue.count != 0 {
                    Defaults[kBandingPhone] = "0"
                    Defaults[kBandingInviter] = "1"
                    
                    weakSelf?.navigationController?.pushViewController(LNBandingPhoneViewController(), animated: true)
                }else{
                    Defaults[kBandingPhone] = "0"
                    Defaults[kBandingInviter] = "0"
                    
                    weakSelf?.navigationController?.pushViewController(LNBandingPhoneViewController(), animated: true) //绑定手机号
                }
            }
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
    
    @objc func ForgetPwdBtnClick() {
        
        
        self.navigationController?.pushViewController(JGForgotPwdViewController(), animated: true)
    }
    
    @objc func RegisterBtnClick() {
        
        self.navigationController?.pushViewController(JGRegisterViewController(), animated: true)
    }
    
}
