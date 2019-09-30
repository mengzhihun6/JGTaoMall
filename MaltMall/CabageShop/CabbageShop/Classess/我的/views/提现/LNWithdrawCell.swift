//
//  LNWithdrawCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LNWithdrawCell: UITableViewCell {

    
//    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    @IBOutlet weak var alipay_account: UITextField!
    
    @IBOutlet weak var hiddenView: UIView!

    @IBOutlet weak var change: UIButton!
    
    
    @IBOutlet weak var user_name: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var max_count: UILabel!
//    @IBOutlet weak var min_count: UILabel!
    
    @IBOutlet weak var done: UIButton!
    
    
    //    回调
    typealias swiftBlock = (_ aliNum:String, _ realName:String) -> Void
    var willClick : swiftBlock? = nil
    @objc func callKeywordBlock(block: @escaping (_ aliNum:String, _ realName:String) -> Void ) {
        willClick = block
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        change.cornerRadius = change.height/2
        change.clipsToBounds = true
        change.layer.borderWidth = 1
        change.layer.borderColor = kSetRGBColor(r: 85, g: 85, b: 85).cgColor
        
        done.cornerRadius = 5
        done.clipsToBounds = true
        
        alipay_account.delegate = self
        
        amount.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        user_name.delegate = self
        user_name.tag = 1001
        
        hiddenView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1001 {
            
            
            
            
            return false
        }else{
            return true
        }
    }

    
    @objc func textDidChanged() {
        let inputMoney = StringToFloat(str: amount.text!)
        let totalMoney = StringToFloat(str: model.credit1)
        
        if inputMoney > totalMoney {
            setToast(str: "超出可提现最大金额")
//            amount.text = model.credit1
        }
    }

    
    var model = LNMemberModel() {
        didSet {
            alipay_account.text = model.alipay
            user_name.text = model.realname
            max_count.text = "可提现 "+model.credit1
        }
    }
    
    @IBAction func getAll(_ sender: Any) {
        amount.text = model.credit1
    }
    
    
    @IBAction func changeAction(_ sender: UIButton) {
        

        sender.setTitle("修改", for: .normal)
        alipay_account.resignFirstResponder()
        hiddenView.isHidden = false

        let banding = LNBandingAlipayViewController()
        banding.model = model
        weak var weakSelf = self
        banding.callKeywordBlock { (aliAccount, realName) in
            DispatchQueue.main.async {
                weakSelf?.alipay_account.text = aliAccount
                weakSelf?.user_name.text = realName
                weakSelf?.alipay_account.resignFirstResponder()
            }
        }
        viewContainingController()?.navigationController?.pushViewController(banding, animated: true)
        
    }
    
    
    
    
    @IBAction func commitAction(_ sender: UIButton) {
        
        
        if alipay_account.text?.count == 0 {
            setToast(str: "请输入微信号")
            return
        }
        
        if user_name.text?.count == 0 {
            setToast(str: "请输入真实姓名")
            return
        }
        
        if amount.text?.count == 0 {
            setToast(str: "请输入金额")
            return
        }
        
        if StringToFloat(str: amount.text!) == 0 {
            setToast(str: "请输入正确的金额")
            return
        }
        let request = SKRequest.init()
        request.setParam(alipay_account.text! as NSObject, forKey: "alipay")
        request.setParam(user_name.text! as NSObject, forKey: "realname")
        request.setParam(amount.text! as NSObject, forKey: "money")
        weak var weakSelf = self
        request.callPOST(withUrl: LNUrls().kWithdraw) { (response) in
            DispatchQueue.main.async {
                
                if !(response?.success)! {
                    return
                }
                let succeed = LNShowSucceedViewController()
                succeed.textStr = "提现成功"
                weakSelf?.viewContainingController()?.navigationController?.pushViewController(succeed, animated: true)
            }
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


extension LNWithdrawCell:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        change.setTitle("修改", for: .normal)
//        alipay_account.resignFirstResponder()
//        hiddenView.isHidden = false
    }
    
}

