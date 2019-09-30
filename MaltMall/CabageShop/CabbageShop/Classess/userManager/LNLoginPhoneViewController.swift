//
//  LNLoginPhoneViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/19.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyJSON
import SwiftyUserDefaults

class LNLoginPhoneViewController: LNBaseViewController {
    @IBOutlet weak var phone_number: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var show_paw: UIButton!
    @IBOutlet weak var certain: UIButton!
    
    @IBOutlet weak var bg_height: NSLayoutConstraint!
    @IBOutlet weak var bg_topheight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Device() == .iPhoneX {
            bg_height.constant = 208 + 20
            bg_topheight.constant = 70 + 20
        }
        if kSCREEN_HEIGHT == 812 {
            bg_height.constant = 208 + 20
            bg_topheight.constant = 70 + 20
        }
        
        phone_number.borderStyle = .line
        phone_number.borderStyle = .none
        phone_number.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: 8, height: 17))
        phone_number.leftViewMode = .always
        phone_number.clearButtonMode = .whileEditing
        phone_number.layer.cornerRadius = 5
        phone_number.clipsToBounds = true
        phone_number.font = UIFont.systemFont(ofSize: 14)
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 14))
        view.addSubview(leftImage)
        phone_number.leftView = view
        
        
        password.borderStyle = .line
        password.borderStyle = .none
        password.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: 8, height: 17))
        password.leftViewMode = .always
        password.clearButtonMode = .whileEditing
        password.layer.cornerRadius = 5
        password.clipsToBounds = true
        password.font = UIFont.systemFont(ofSize: 14)
        
        let view2 = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 17))
        let leftImage2 = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 14))
        view2.addSubview(leftImage2)
        password.leftView = view2

        
        titleLabel.text = "手机登录"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)

        certain.cornerRadius = certain.height/2
//        certain.backgroundColor = kMainColor1()

         isBanding = false
    }
    override func backAction(sender: UIButton) {
//        if webView.canGoBack {
//            webView.goBack()
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func showPaw(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        password.isSecureTextEntry = !sender.isSelected
    }

    @IBAction func certainAction(_ sender: UIButton) {
        
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


}
