//
//  NextLevelCollectionViewCell.swift
//  CabbageShop
//
//  Created by 赵马刚 on 2018/12/23.
//  Copyright © 2018 付耀辉. All rights reserved.
//

import UIKit

class NextLevelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var theNextLevelLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var growValueLabel: UILabel!
    
    @IBOutlet weak var riseLevel: UIButton!
    
    var selectModel = LNPartnerModel()
    var memberMdel = LNMemberModel()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        
        moneyLabel.textColor = UIColor(red: 0.96, green: 0.4, blue: 0.27,alpha:1)
        
        growValueLabel.textColor = UIColor(red: 0.8, green: 0.53, blue: 0.31,alpha:1)
        riseLevel.backgroundColor = kMainColor1()
        riseLevel.cornerRadius = 5
      
    }
    func setValues(model:LNPartnerModel,member:LNMemberModel){
        selectModel = model
        memberMdel = member
        if model.credit.contains(".00") {
            growValueLabel.text = model.credit.replacingOccurrences(of: ".00", with: "")
            growValueLabel.text = model.credit.replacingOccurrences(of: ".00", with: "")
        }else{
            growValueLabel.text = model.credit;
            growValueLabel.text = model.credit;
        }
        moneyLabel.text = model.price1
        
        if Int(memberMdel.level.level)! >= Int(model.level)! {
            
            riseLevel.isHidden = true
        }else{
            riseLevel.isHidden = false
        }
        
    }
    
    
    func theNextLevelLabelStr(level:String,lastModel:LNPartnerModel?,member:LNMemberModel){
        if lastModel != nil {
            selectModel = lastModel!
        }
        memberMdel = member

        if level == "当前等级已是最高级" {
            
            theNextLevelLabel.text = level
            growValueLabel.text = "0"
            moneyLabel.text = "0.00"
        }else{
            theNextLevelLabel.text = "距离下一个等级 " + level
        }
        
        if lastModel != nil {
            if Int(member.level.level)! >= Int(lastModel!.level)! {
                
                riseLevel.isHidden = true
            }else{
                riseLevel.isHidden = false
            }
        }
    }
    
    @IBAction func riseNow(_ sender: Any) {
        
        if Int(OCTools().getStrWithIntStr(memberMdel.credit3))! >= Int(OCTools().getStrWithIntStr(selectModel.credit))! {
            
            let request = SKRequest.init()
            weak var weakSelf = self
            request.setParam(selectModel.id as NSObject, forKey: "level_id")
            request.callGET(withUrl: LNUrls().kCheckUpgrade) { (response) in
                if !(response?.success)! {
                    return
                }
                setToast(str: "升级成功")
                NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LNChangePersonalInfo), object: self, userInfo: nil)
                weakSelf?.riseLevel.isHidden = true
            }
            
        }else{
            
            if OCTools().getStrWithIntStr(selectModel.price1) == "0" && OCTools().getStrWithIntStr(selectModel.price2) == "0" {
                setToast(str: "您当前成长值不足")
            }else{
                let payVc = LNPayVipViewController()
                payVc.selectModel  = selectModel
                viewContainingController()?.navigationController?.pushViewController(payVc, animated: true)
            }
        }
    }
    
    
}
