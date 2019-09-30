//
//  LNPayVipViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/27.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNPayVipViewController: LNBaseViewController {

    
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var alwaysView: UIView!
    @IBOutlet weak var PRView: UIView!

    @IBOutlet weak var monthMark: UILabel!
    @IBOutlet weak var yearMark: UILabel!
    @IBOutlet weak var alwaysMark: UILabel!
    @IBOutlet weak var PRsMark: UILabel!

    @IBOutlet weak var monthPrice: UILabel!
    @IBOutlet weak var yearPrice: UILabel!
    @IBOutlet weak var alwaysPrice: UILabel!
    @IBOutlet weak var PRPrice: UILabel!

    @IBOutlet weak var monthDan: UILabel!
    @IBOutlet weak var yearDan: UILabel!
    @IBOutlet weak var alwaysDan: UILabel!
    @IBOutlet weak var PRDan: UILabel!

    @IBOutlet weak var monthSelected: UIButton!
    @IBOutlet weak var yearSelected: UIButton!
    @IBOutlet weak var alwaysSelected: UIButton!
    @IBOutlet weak var PRSelected: UIButton!

    @IBOutlet weak var pay: UIButton!

    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!

    
    var seletedType = String()
    var selectModel = LNPartnerModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigaView.backgroundColor = UIColor.white
        navigationTitle = "支付通道"
        backBtn.setImage(UIImage.init(named: "back_icon"), for: .normal)
        
        monthView.clipsToBounds = true
        monthView.cornerRadius = 3
        
        yearView.clipsToBounds = true
        yearView.cornerRadius = 3
        
        alwaysView.clipsToBounds = true
        alwaysView.cornerRadius = 3
        
        PRView.clipsToBounds = true
        PRView.cornerRadius = 3

        monthMark.clipsToBounds = true
        monthMark.cornerRadius = 3
        
        yearMark.clipsToBounds = true
        yearMark.cornerRadius = 3
        
        alwaysMark.clipsToBounds = true
        alwaysMark.cornerRadius = 3
        
        PRsMark.clipsToBounds = true
        PRsMark.cornerRadius = 3

        topSpace.constant = navHeight+10
        
        pay.clipsToBounds = true
        pay.cornerRadius = pay.height/2
        
        monthPrice.text = selectModel.price1 + " "
        yearPrice.text = selectModel.price2 + " "
        alwaysPrice.text = selectModel.price3 + " "
        PRPrice.text = selectModel.price4 + " "
        
        if selectModel.price1 == "0.00" {
            monthPrice.text = ""
            monthDan.text = "暂不支持月付"
            button1.isEnabled = false
        }
        
        if selectModel.price2 == "0.00" {
            yearPrice.text = ""
            yearDan.text = "暂不支持季付"
            button2.isEnabled = false
        }
        
        if selectModel.price3 == "0.00" {
            alwaysPrice.text = ""
            alwaysDan.text = "暂不支持年付"
            button3.isEnabled = false
        }
        
        if selectModel.price4 == "0.00" {
            PRPrice.text = ""
            PRDan.text = "暂不支持永久"
            button4.isEnabled = false
        }
        
        //微信支付成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNitification(nitofication:)), name: NSNotification.Name(rawValue: WXPaySuccessNotification), object: nil)
    }
    
    @objc func receiveNitification(nitofication:Notification) {

        NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LNChangePersonalInfo), object: self, userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            seletedType = "1"
            monthSelected.isSelected = true
            yearSelected.isSelected = false
            alwaysSelected.isSelected = false
            PRSelected.isSelected = false
            
            break
        case 102:
            seletedType = "2"
            monthSelected.isSelected = false
            yearSelected.isSelected = true
            alwaysSelected.isSelected = false
            PRSelected.isSelected = false
            break
            
        case 103:
            seletedType = "3"
            monthSelected.isSelected = false
            yearSelected.isSelected = false
            alwaysSelected.isSelected = true
            PRSelected.isSelected = false
            break
        default:
            seletedType = "4"
            monthSelected.isSelected = false
            yearSelected.isSelected = false
            alwaysSelected.isSelected = false
            PRSelected.isSelected = true
            break
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }

    
    @IBAction func payAction(_ sender: Any) {
        
        if seletedType.count == 0{
            setToast(str: "请选择类型")
            return
        }
        
        LQLoadingView().SVPwillShowAndHideNoText()
        let request = SKRequest.init()
        weak var weakSelf = self
        request.setParam(selectModel.id as NSObject, forKey: "level_id")
        request.setParam(seletedType as NSObject, forKey: "type")
        request.setParam("level" as NSObject, forKey: "pay_type")
        request.callGET(withUrl: LNUrls().kPay) { (response) in
            
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                LQLoadingView().SVPHide()
                let JSOnDictory =  JSON((response?.data["data"])!)
                let prepayid =  JSOnDictory["prepayid"].stringValue
                let sign =  JSOnDictory["sign"].stringValue
                let appid =  JSOnDictory["appid"].stringValue
                let partnerid =  JSOnDictory["partnerid"].stringValue
                let noncestr =  JSOnDictory["noncestr"].stringValue
                let package =  JSOnDictory["package"].stringValue
                let timestamp =  JSOnDictory["timestamp"].stringValue
                
                let request = PayReq.init()
                request.openID = appid
                request.partnerId = partnerid
                request.prepayId = prepayid
                request.package = package
                request.nonceStr = noncestr
                request.sign = sign
                request.timeStamp = UInt32(Int32(timestamp)!)
                WXApi.send(request)
            }
        }
    }
}
