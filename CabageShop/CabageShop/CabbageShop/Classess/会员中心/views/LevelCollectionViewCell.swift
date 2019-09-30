//
//  LevelCollectionViewCell.swift
//  CabbageShop
//
//  Created by 赵马刚 on 2018/12/23.
//  Copyright © 2018 付耀辉. All rights reserved.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var credit2Label: UILabel!
    
    
    @IBOutlet weak var lineView: UIView!

    @IBOutlet weak var piontView1: UIView!
    @IBOutlet weak var piontView2: UIView!
    @IBOutlet weak var piontView3: UIView!
    @IBOutlet weak var piontView4: UIView!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var riseLebvel: UIButton!

    
    @IBOutlet weak var showLevel1: UIButton!
    @IBOutlet weak var showLevel2: UIButton!
    @IBOutlet weak var showLevel3: UIButton!
    @IBOutlet weak var showLevel4: UIButton!

    @IBOutlet weak var chengzhangzhi1: UILabel!
    @IBOutlet weak var chengzhangzhi2: UILabel!
    @IBOutlet weak var chengzhangzhi3: UILabel!
    @IBOutlet weak var chengzhangzhi4: UILabel!

    fileprivate var member = LNMemberModel()
    fileprivate var partner = LNPartnerModel()
    
    
    typealias swiftBlock = (_ message:NSInteger) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ message:NSInteger) -> Void ) {
        willClick = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.cornerRadius = headImage.height/2
        headImage.clipsToBounds = true
        let arr = [piontView1,piontView2,piontView3,piontView4]
        
        for piontView in arr {
            piontView?.cornerRadius = (piontView?.height)!/2
            piontView?.borderWidth = 2
            piontView?.borderColor = kGaryColor(num: 212)
        }
        
        bgView.cornerRadius = 12

        self.backgroundColor = UIColor.clear
    }
    
    func setValues(models:[LNPartnerModel], current:NSInteger,memberModel:LNMemberModel) {
        member = memberModel
        partner = models[current]
        if models.count>3 {
            chengzhangzhi1.text = OCTools().getStrWithIntStr(models[0].credit)
            chengzhangzhi2.text = OCTools().getStrWithIntStr(models[1].credit)
            chengzhangzhi3.text = OCTools().getStrWithIntStr(models[2].credit)
            chengzhangzhi4.text = OCTools().getStrWithIntStr(models[3].credit)
        }
        
        if Int(memberModel.level.level)! >= Int(models[current].level)! {
            
            riseLebvel.isHidden = true
        }else{
            riseLebvel.isHidden = false
        }
        
        headImage.sd_setImage(with: OCTools.getEfficientAddress(memberModel.level.logo), placeholderImage: UIImage.init(named: "goodImage_1"))
        credit2Label.text = OCTools().getStrWithIntStr(memberModel.credit3)
        userLevel.text = memberModel.level.name
        
        let arr = [showLevel1,showLevel2,showLevel3,showLevel4]
        
        for showLevel in arr {
            
            showLevel?.layer.cornerRadius = (showLevel?.height)!/2
            showLevel?.clipsToBounds = true
            
            if current == (showLevel?.tag)!-101 {
//                showLevel?.setBackgroundImage(UIImage.init(named: "dengji_bg_1"), for: .normal)
                showLevel?.setBackgroundImage(nil, for: .normal)
                showLevel?.setTitleColor(kGaryColor(num: 255), for: .normal)
                showLevel?.titleLabel?.font = UIFont.systemFont(ofSize: 11)
//                showLevel?.titleLabel?.font = UIFont.systemFont(ofSize: 8)
                showLevel?.backgroundColor = kSetRGBColor(r: 222, g: 47, b: 47)
            }else{
                showLevel?.setBackgroundImage(nil, for: .normal)
                showLevel?.setTitleColor(kGaryColor(num: 170), for: .normal)
                showLevel?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                showLevel?.backgroundColor = UIColor.clear
            }
        }
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        
        if willClick != nil {
            willClick!(sender.tag-101)
        }
    }
    
    

    @IBAction func riseLevelAction(_ sender: Any) {
        
        if Int(OCTools().getStrWithIntStr(member.credit3))! >= Int(OCTools().getStrWithIntStr(partner.credit))! {
            
            let request = SKRequest.init()
            weak var weakSelf = self
            request.setParam(partner.id as NSObject, forKey: "level_id")
            request.callGET(withUrl: LNUrls().kCheckUpgrade) { (response) in
                if !(response?.success)! {
                    return
                }
                setToast(str: "升级成功")
                NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LNChangePersonalInfo), object: self, userInfo: nil)
                weakSelf?.riseLebvel.isHidden = true
            }
            
        }else{

            setToast(str: "您当前成长值不足")

//            if OCTools().getStrWithIntStr(partner.price1) == "0" && OCTools().getStrWithIntStr(partner.price2) == "0" {
//                setToast(str: "您当前成长值不足")
//            }else{
//                let payVc = LNPayVipViewController()
//                payVc.selectModel  = partner
//                viewContainingController()?.navigationController?.pushViewController(payVc, animated: true)
//            }
        }
    }
    
    

}
