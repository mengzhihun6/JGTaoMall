//
//  LNLoginViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class LNLoginViewController: LNBaseViewController {
    @objc var typeString : String = ""   // 3,会员升级
    @objc var webView : UIWebView = UIWebView()
    @objc var webTitle : String = ""
    @objc var nav = UINavigationController()
    
    
    @IBOutlet weak var close_space: NSLayoutConstraint!
    
    @IBOutlet weak var user_icon: UIImageView!

    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var protol: UIButton!
    @IBOutlet weak var agree: UIButton!

//    @IBOutlet weak var theButton: UIButton!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        close_space.constant = navHeight-45-kStatusBarH
        navigaView.isHidden = true
        
        login.clipsToBounds = true
        login.cornerRadius = 5//login.height/2
        login.backgroundColor = kMainColor1()
//        user_icon.clipsToBounds = true
//        user_icon.cornerRadius = 8
        
        login.layoutButton(with: .left, imageTitleSpace: 8)
//        if !OCTools().judgeTimeByStartAndEnd() {
//            theButton.isHidden = true
//        }
        
    }
    
    @IBAction func youkeAction(_ sender: Any) {
        
        Defaults[kUserToken] = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYmFpY2FpLnRvcFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTU0Mzk5OTUwMSwiZXhwIjoxOTAzOTk5NTAxLCJuYmYiOjE1NDM5OTk1MDEsImp0aSI6IktDMzBCb3M3N2R5d1VDengiLCJzdWIiOjEsInBydiI6ImI5MTI3OTk3OGYxMWFhN2JjNTY3MDQ4N2ZmZjAxZTIyODI1M2ZlNDgifQ.FPixElpL99ujZMwJg5VjVUbhnZ80R8qN-Rfa2NkoXjM"
        Defaults[kBandingPhone] = "0"
        Defaults[kBandingInviter] = "0"
        self.view.window?.rootViewController = LNMainTabBarController()
        
    }

    
    
    @IBAction func showMoreAction(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        weak var weakSelf = self
        let action2 = UIAlertAction.init(title: "手机号登录", style: .default) { (alert) in
            let regiter = LNLoginPhoneViewController()
            weakSelf?.navigationController?.pushViewController(regiter, animated: true)
        }
        let action3 = UIAlertAction.init(title: "忘记密码", style: .destructive) { (alert) in
            weakSelf?.navigationController?.pushViewController(LNForgotPasswordViewController(), animated: true)
        }
        let action4 = UIAlertAction.init(title: "取消", style: .cancel) { (alert) in
        }

        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func certainAction(_ sender: UIButton) {

        if agree.isSelected {
            setToast(str: "请先同意用户协议！")
            return
        }
        
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
    
    @IBAction func closeLogin(_ sender: Any) {
        if self.presentingViewController == nil {
            Defaults[kBandingPhone] = "1"
            Defaults[kBandingInviter] = "1"
            self.view.window?.rootViewController = LNMainTabBarController()
        }else{
            if typeString == "1" {
                self.view.window?.rootViewController = LNMainTabBarController()
            } else if typeString == "2" {
                self.dismiss(animated: true, completion: nil)
            } else if typeString == "3" {
//                nav.tabBarController?.selectedIndex = 0
//                self.dismiss(animated: true, completion: nil)
                self.view.window?.rootViewController = LNMainTabBarController()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func readProtol(_ sender: Any) {
        let vc = LNPartnerDetailViewController()
        vc.isProtcol = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func agreeProtol(_ sender: UIButton) {
     
        sender.isSelected = !sender.isSelected
    }

}
