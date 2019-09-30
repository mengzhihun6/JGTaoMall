//
//  SZYLNWithdrawCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/16.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYLNWithdrawCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var ketixianjineLabel: UILabel!
    @IBOutlet weak var yijiexuanLabel: UILabel!
    @IBOutlet weak var daijiesuanLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var yanzhengmaTextField: UITextField!
    @IBOutlet weak var yanzhengmaBun: UIButton!
    @IBOutlet weak var tixianjineTextField: UITextField!
    @IBOutlet weak var shouxufeilvLabel: UILabel!
    @IBOutlet weak var ketixianLabel: UILabel!
    
    @IBOutlet weak var quanbutixianBun: UIButton!
    @IBOutlet weak var lijitixianBun: UIButton!
    
    var userModel : SZYPersonalCenterModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tixianjineTextField.tag = 1000
        tixianjineTextField.delegate = self
//        lijitixianBun.backgroundColor = kSetRGBColor(r: 239, g: 6, b: 93)
        lijitixianBun.isUserInteractionEnabled = false
        
        phoneTextField.keyboardType = .numberPad
        yanzhengmaTextField.keyboardType = .numberPad
        tixianjineTextField.keyboardType = .decimalPad
        bgImageView.backgroundColor = kSetRGBColor(r: 233, g: 13, b: 68)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var model = SZYPersonalCenterModel() {
        didSet {
            ketixianjineLabel.text = model.credit1
            yijiexuanLabel.text = ""
            daijiesuanLabel.text = ""
        }
    }
    
    func setUpUserInfo(model:SZYPersonalCenterModel, chart:SZYChartModel) {
        userModel = model
        phoneTextField.isUserInteractionEnabled = false
        
        ketixianjineLabel.text = model.credit1
        yijiexuanLabel.text = chart.money
        daijiesuanLabel.text = chart.income
        ketixianLabel.text = "可提现"+model.credit1
        phoneTextField.text = model.phone
    }
    
    @IBAction func yanzhengmaBunClick(_ sender: UIButton) {
        kDeBugPrint(item: "获取验证码")
        self.endEditing(true)
        if phoneTextField.text == "" {
            setToast(str: "请输入手机号")
            return
        }
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        let request = SKRequest.init()
        request.setParam(phoneTextField.text! as NSObject, forKey: "phone")
        request.setParam("2" as NSObject, forKey: "type")
        request.callGET(withUrl: LNUrls().tixian) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
//            kDeBugPrint(item: response?.data)
        }
    }
    @IBAction func quanbutixianBunClick(_ sender: UIButton) { //全部提现
        self.endEditing(true)
        tixianjineTextField.text = userModel!.credit1
        
        if StringToFloat(str: tixianjineTextField.text!) >= 5.0 {
            lijitixianBun.backgroundColor = kSetRGBColor(r: 239, g: 6, b: 93)
            lijitixianBun.isUserInteractionEnabled = true
        } else {
            lijitixianBun.backgroundColor = kSetRGBColor(r: 200, g: 200, b: 200)
            lijitixianBun.isUserInteractionEnabled = false
        }
    }
    @IBAction func lijitixianBunClick(_ sender: UIButton) { //立即提现
        self.endEditing(true)
//        if nameTextField.text == "" {
//            setToast(str: "请输入名字")
//            return
//        }
        if phoneTextField.text == "" {
            setToast(str: "请输入手机号")
            return
        }
        if yanzhengmaTextField.text == "" {
            setToast(str: "请输入验证码")
            return
        }
        if tixianjineTextField.text == "" {
            setToast(str: "请输入提现金额")
            return
        }
        let request = SKRequest.init()
//        request.setParam(nameTextField.text! as NSObject, forKey: "realname")
        weak var weakSelf = viewContainingController()
        request.setParam(tixianjineTextField.text! as NSObject, forKey: "money")
        request.setParam(yanzhengmaTextField.text! as NSObject, forKey: "code")
        request.setParam(phoneTextField.text! as NSObject, forKey: "phone")
        request.setParam("1" as NSObject, forKey: "credit_type")
        request.callPOST(withUrl: LNUrls().kWithdraw) { (response) in
            LQLoadingView().SVPHide()
            
            kDeBugPrint(item: response?.message)
            kDeBugPrint(item: response?.data)
            kDeBugPrint(item: response?.code)
            
            if !(response?.success)! {
                setToast(str: (response?.message)!)
//                setToast(str: "提现失败!")
                return
            }
            setToast(str: "提现成功!")
            weakSelf?.navigationController?.popViewController(animated: true)
//            setToast(str: (response?.message)!)
//            kDeBugPrint(item: response?.data)
//            let data = JSON((response?.data)!)["data"]
//            kDeBugPrint(item: data)
        }
    }
}
extension SZYLNWithdrawCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1000 {
            kDeBugPrint(item: "666")
            kDeBugPrint(item: textField.text)
            kDeBugPrint(item: range)
            kDeBugPrint(item: string)
            
            kDeBugPrint(item: range.location)
            kDeBugPrint(item: range.length)
            var text = textField.text
            if range.length == 0 {
                text = text!+string
            } else if range.length == 1 {
                let index = text!.index(text!.startIndex, offsetBy: (text?.count)! - 1)
                text = text!.substring(to: index)
                //下面功能也一样
//                let startIndex = text!.index(text!.startIndex, offsetBy:0)//获取d的索引
//                let endIndex = text!.index(startIndex, offsetBy:text!.count - 1)//从d的索引开始往后两个,即获取f的索引
//                text = text!.substring(with: startIndex..<endIndex)//输出d的索引到f索引的范围,注意..<符号表示输出不包含f
            }
            kDeBugPrint(item: text)
            if StringToFloat(str: OCTools().getStrWithFloatStr(text)) >= 5.0 {
                lijitixianBun.backgroundColor = kSetRGBColor(r: 239, g: 6, b: 93)
                lijitixianBun.isUserInteractionEnabled = true
            } else {
                lijitixianBun.backgroundColor = kSetRGBColor(r: 200, g: 200, b: 200)
                lijitixianBun.isUserInteractionEnabled = false
            }
        }
        return true
    }
    func StringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string) {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
}
