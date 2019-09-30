//
//  LNMineSettingCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMineSettingCell: UITableViewCell {
    
    @IBOutlet weak var option_icon: UIButton!
    @IBOutlet weak var option_title: UILabel!
    
    @IBOutlet weak var option_value: UILabel!
    @IBOutlet weak var qingChu: UIButton!
    
    @IBOutlet weak var clickLable: UILabel!
    var authorizationStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpValues(image:UIImage, title:String, value:String, type:String) {
        authorizationStr = type
        option_icon.setImage(image, for: .normal)
        option_value.text = value
        option_title.text = title
        if type == "1" {
            option_value.isHidden = false
            qingChu.isHidden = true
            clickLable.isHidden = false
            option_value.text = "清除"
            qingChu.setTitle("清除", for: .normal)
//            qingChu.setBackgroundImage(UIImage.init(named: "Rectangle38"), for: .normal)
            qingChu.isUserInteractionEnabled = false
        } else if type == "2" {
            qingChu.isUserInteractionEnabled = true
            option_value.isHidden = false
            clickLable.isHidden = false
            qingChu.isHidden = true
            qingChu.setTitle("", for: .normal)
            if ALBBSession.sharedInstance()!.isLogin() {
                qingChu.setBackgroundImage(UIImage.init(named: "开关／开关(开)"), for: .normal)
                option_value.text = "已授权"
            } else {
                qingChu.setBackgroundImage(UIImage.init(named: "开关／开关(关)"), for: .normal)
                option_value.text = "未授权"
                
            }
        } else {
            option_value.isHidden = false
            qingChu.isHidden = true
            clickLable.isHidden = true
        }
    }
    
    @IBAction func shouquan(_ sender: UIButton) {
        if authorizationStr == "2" {
            weak var weakSelf = self
            if !ALBBSession.sharedInstance()!.isLogin() {
                let loginService = ALBBSDK.sharedInstance()  //.setLoginResultHandler
                loginService?.auth(self.viewContainingController(), successCallback: { (albbsession) in // 成功
                    if (albbsession?.isLogin())! {
                        weakSelf!.qingChu.setBackgroundImage(UIImage.init(named: "开关／开关(开)"), for: .normal)
                    }
//                    kDeBugPrint(item: "=============")
//                    kDeBugPrint(item: albbsession?.bindCode)
//                    kDeBugPrint(item: "=============")
                }, failureCallback: { (albbsession, error) in   //失败
                    
                })
            } else { // 阿里百川 取消授权
                let loginService = ALBBSDK.sharedInstance()
                loginService?.logout()
                weakSelf!.qingChu.setBackgroundImage(UIImage.init(named: "开关／开关(关)"), for: .normal)
            }
        } else {
            
        }
    }
    
    func getTaokeParam() -> AlibcTradeTaokeParams {
        if ALiTradeSDKShareParam.sharedInstance().isUseTaokeParam {
            let taoke = AlibcTradeTaokeParams.init()
            taoke.pid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "pid") as? String
            taoke.subPid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "subPid") as? String
            taoke.unionId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "unionId") as? String
            taoke.adzoneId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "adzoneId") as? String
            taoke.extParams = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "extParams") as? [AnyHashable : Any]
            
            return taoke
        }else{
            return AlibcTradeTaokeParams()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
