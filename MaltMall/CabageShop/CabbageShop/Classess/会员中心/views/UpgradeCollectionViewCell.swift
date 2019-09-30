//
//  Upgrade CollectionViewCell.swift
//  CabbageShop
//
//  Created by 赵马刚 on 2018/12/23.
//  Copyright © 2018 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class UpgradeCollectionViewCell: UICollectionViewCell {

    // 1.定义一个闭包类型
    typealias swiftBlock = (_ btnTag : Int) -> Void
    
    // 2. 声明一个变量
    var callBack: swiftBlock?
    
    @IBOutlet weak var retext: UILabel!
    

    @IBOutlet weak var attentionBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var SignInBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        
        self.SignInBtn.clipsToBounds = true
        self.SignInBtn.layer.cornerRadius = 11
        
        self.shareBtn.clipsToBounds = true
        self.shareBtn.layer.cornerRadius = 11
        
        self.attentionBtn.clipsToBounds = true
        self.attentionBtn.layer.cornerRadius = 11
        self.SignInBtn.backgroundColor = UIColor(red: 0.95, green: 0.42, blue: 0.42, alpha: 1)
        self.shareBtn.backgroundColor = UIColor(red: 0.95, green: 0.42, blue: 0.42, alpha: 1)
        self.attentionBtn.backgroundColor = UIColor(red: 0.95, green: 0.42, blue: 0.42, alpha: 1)
        
        if OCTools().judgeTimeByStartAndEnd() {
            retext.text = retext.text!+"和现金奖励"
        }
        
        let request = SKRequest.init()
        weak var weakSelf = self
        request.callGET(withUrl: BaseUrl+"/user/issign") { (response) in
            if !(response?.success)! {
                return
            }
            if JSON((response?.data)!)["data"].stringValue == "1" {
//                weakSelf?.SignInBtn.setTitleColor(kGaryColor(num: 166), for: .normal)
                weakSelf?.SignInBtn.backgroundColor = kGaryColor(num: 166)
                weakSelf?.SignInBtn.setTitle("已签到", for: .normal)
                weakSelf?.SignInBtn.isEnabled = false
            }else{
                weakSelf?.SignInBtn.backgroundColor = UIColor(red: 0.95, green: 0.42, blue: 0.42, alpha: 1)
                weakSelf?.SignInBtn.setTitle("点击签到", for: .normal)
                weakSelf?.SignInBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
//        switch sender.tag {
//        case 998: print( "index 的值为 998")
//        case 999: print( "index 的值为 999")
//       
//            
//        default:
//             print( "默认 1000")
//        }
        //4. 调用闭包,设置你想传递的参数,调用前先判定一下,是否已实现
        if sender.tag == 998 {
            let request = SKRequest.init()
            weak var weakSelf = self
            LQLoadingView().SVPwillShowAndHideNoText()
            request.callGET(withUrl: kSignin) { (response) in
                 LQLoadingView().SVPHide()
                if !(response?.success)! {
                    return
                }
                if weakSelf?.callBack != nil {
                    weakSelf?.callBack!(sender.tag)
                }
                setToast(str: "签到成功")
                weakSelf?.SignInBtn.backgroundColor = kGaryColor(num: 166)
                weakSelf?.SignInBtn.setTitle("已签到", for: .normal)
            }

        }else{
            if callBack != nil {
                callBack!(sender.tag)
            }
            
        }
        
    }
    // 3. 定义一个方法,方法的参数为和swiftBlock类型一致的闭包,并赋值给callBack
    func callBackBlock(block: @escaping swiftBlock) {
        callBack = block
    }
    
}
