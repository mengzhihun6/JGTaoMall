//
//  LNMineInfoCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyJSON

class LNMineInfoCell: UITableViewCell {

    @IBOutlet weak var user_icon: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var heHupMark: UILabel!
    
    
    @IBOutlet weak var detail1: UILabel!
    
    @IBOutlet weak var invate_code: UILabel!
    @IBOutlet weak var copy_button: UIButton!
    
    @IBOutlet weak var fans_label: UILabel!
    @IBOutlet weak var express_label: UILabel!
    @IBOutlet weak var group_value: UILabel!

    
    @IBOutlet weak var user_balance: UILabel!
    
    
//    @IBOutlet weak var withdraw_button: UIButton!
    @IBOutlet weak var Line1: UIView!
    

    @IBOutlet weak var total_money: UILabel!
    @IBOutlet weak var today_money: UILabel!
    @IBOutlet weak var today1_money: UILabel!
    @IBOutlet weak var today2_money: UILabel!

    
    @IBOutlet weak var invite_partner: UIButton!
    
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!

    
    
    @IBOutlet weak var bgView1: UIView!
    @IBOutlet weak var bgView2: UIView!
    @IBOutlet weak var bgView3: UIView!
    @IBOutlet weak var bgView4: UIView!
    
    
    @IBOutlet weak var head_height: NSLayoutConstraint!
    
    var userModel : LNMemberModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        if Device() == .iPhoneX || kSCREEN_HEIGHT>800 {
            head_height.constant = 176+24
        }

        bgView1.layer.cornerRadius = 12
        bgView1.clipsToBounds = true

        bgView2.layer.cornerRadius = 8
        bgView3.clipsToBounds = true
        
        bgView3.layer.cornerRadius = 5
        bgView3.clipsToBounds = true

        bgView4.layer.cornerRadius = 5
        bgView4.clipsToBounds = true

        copy_button.setTitleColor(kSetRGBColor(r: 254, g: 189, b: 189), for: .normal)
        copy_button.backgroundColor = UIColor.clear
        
        heHupMark.layer.cornerRadius = heHupMark.height/2
        heHupMark.clipsToBounds = true

        user_icon.layer.cornerRadius = user_icon.height/2
        user_icon.clipsToBounds = true

        
        invate_code.layer.cornerRadius = invate_code.height/2
        invate_code.clipsToBounds = true
        invate_code.textColor = kSetRGBColor(r: 252, g: 192, b: 91)
        invate_code.borderColor = kSetRGBColor(r: 252, g: 192, b: 91)
        invate_code.borderWidth = 1
        
        option1.layoutButton(with: .top, imageTitleSpace: 0)
        option2.layoutButton(with: .top, imageTitleSpace: 0)
        option3.layoutButton(with: .top, imageTitleSpace: 6)
        option4.layoutButton(with: .top, imageTitleSpace: 0)
    }
    
    @IBAction func applyNextLevl(_ sender: Any) {
        
        if userModel!.level.level.count == 0 {
            setToast(str: "请先登录")
            return
        }
        let part = LNPartnerEquityViewController()
        if userModel == nil {
            return
        }
        part.model = userModel!
        viewContainingController()?.navigationController?.pushViewController(part, animated: true)
    }
    
    func setUpUserInfo(model:LNMemberModel,levels:[LNPartnerModel])  {
        
        userModel = model
        
        heHupMark.text = " "+model.level.name+" "
        //            return
        user_icon.sd_setImage(with: OCTools.getEfficientAddress(model.headimgurl), placeholderImage: UIImage.init(named: "goodImage_1"))
        if model.nickname.count != 0 {
            user_name.text = model.nickname
        }
        invate_code.text = "  "+model.hashid + " 我的邀请码  "
        
        user_balance.text = model.credit1
        express_label.text = "成长值 "+OCTools().getStrWithIntStr(model.credit3)
        group_value.text = "积分 "+OCTools().getStrWithIntStr(model.credit1)
        
        fans_label.text = "粉丝 "+model.friends_count
        
        let request = SKRequest.init()
        
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kChart) { (response) in
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async(execute: {
                let datas =  JSON((response?.data["data"])!)
                
                weakSelf?.today_money.text = datas["month"].stringValue//今日预估
                weakSelf?.total_money.text = datas["today"].stringValue//本月预估
                weakSelf?.today1_money.text = datas["lastMonthCommission"].stringValue//上月预估
                weakSelf?.today2_money.text = datas["lastMonth"].stringValue//上月结算
            })
        }
    }
    
    
    @IBAction func copyCodeAction(_ sender: UIButton) {
        if userModel != nil {
            let paste = UIPasteboard.general
            paste.string = userModel?.hashid
            setToast(str: "邀请码复制成功")
        }
    }
    
    
    @IBAction func showPartnerEquity(_ sender: UIButton) {
        if userModel!.level.level.count == 0 {
            setToast(str: "请先登录")
            return
        }
       let part = LNPartnerEquityViewController()
        if userModel == nil {
            return
        }
        part.model = userModel!
        viewContainingController()?.navigationController?.pushViewController(part, animated: true)
    }
    
    
    @IBAction func chooseOptionsAction(_ sender: UIButton) {
        
        let tabbar = LNMineInfoTabbarController()
        
        switch sender.tag {
        case 1001://收益
            tabbar.selectIndex = 0
            break
        case 1002://订单
            tabbar.selectIndex = 1
            break
        case 1003://邀请
            tabbar.selectIndex = 2
            break
        case 1004://粉丝
            tabbar.selectIndex = 3
            break
        default:
            break
        }
        
        if userModel != nil {
            tabbar.personalInfo = userModel!
        }
        
//        tabbar.transitioningDelegate = self
//        let animation = CATransition.init()
//        animation.duration = 0.50
//        animation.type = kCATransitionFromRight
////        animation.subtype = kCATransitionFromRight
//        let windowLayer = viewContainingController()?.view.window?.layer
//        windowLayer?.add(animation, forKey: nil)
//        tabbar.modalTransitionStyle = .coverVertical
        
//        viewContainingController()?.tabBarController?.present(tabbar, animated: false, completion: nil)
        viewContainingController()?.navigationController?.pushViewController(tabbar, animated: true)
    }
    
    
    @IBAction func chooseToolsAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 2001://新手指引
            let newUser = LNNewUserViewController()

            newUser.isNewUser = true
            viewContainingController()?.navigationController?.pushViewController(newUser, animated: true)
            break
        case 2002://我的收藏
            viewContainingController()?.navigationController?.pushViewController(LNShowCollectViewController(), animated: true)

            break
        case 2003://常见问题
            let newUser = LNNewUserViewController()
            
            newUser.isNewUser = false
            viewContainingController()?.navigationController?.pushViewController(newUser, animated: true)
            break
        case 2004://专属客服
            let group = LNCustomServiceViewController()
            
            if userModel == nil {
                return
            }
            
            if userModel?.group == nil || userModel?.group.type.count == 0 {
                isBanding = true
                let nav = LNNavigationController.init(rootViewController: LNBandingPhoneViewController())
                viewContainingController()?.tabBarController?.present(nav, animated: true, completion: nil)
                return
            }
            group.group = (userModel?.group)!
            viewContainingController()?.navigationController?.pushViewController(group, animated: true)
            break
        case 2005://官方公告
        viewContainingController()?.navigationController?.pushViewController(LNSystemNoticeViewController(), animated: true)
            break
        case 2006://意见反馈
            viewContainingController()?.navigationController?.pushViewController(LNSubmitSuggestViewController(), animated: true)
            break
        case 2007://关于我们
            viewContainingController()?.navigationController?.pushViewController(LNAboutUsViewController(), animated: true)

            break
        default:
            break
        }
        
    }
    
    
    @IBAction func gotoTaobaoCar(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
//            UIApplication.shared.statusBarStyle = .default

            self.viewContainingController()?.navigationController?.navigationBar.isTranslucent = false
            let showParam = AlibcTradeShowParams.init()
            showParam.openType = AlibcOpenType.H5
            showParam.backUrl="tbopen25316706"
            showParam.linkKey = "taobao"
            showParam.isNeedPush=true
            showParam.nativeFailMode = AlibcNativeFailMode.jumpH5
            
            let page = AlibcTradePageFactory.myCartsPage()
            
            AlibcTradeSDK.sharedInstance().tradeService().show(self.viewContainingController()!, page: page, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                
                
            }, tradeProcessFailedCallback: { (error) in
                
            })
        }
    }
    
    
    @IBAction func gotoTaobaoOrders(_ sender: UIButton) {
        DispatchQueue.main.async {
            
//            UIApplication.shared.statusBarStyle = .default

            self.viewContainingController()?.navigationController?.navigationBar.isTranslucent = false
            let showParam = AlibcTradeShowParams.init()
            showParam.openType = AlibcOpenType.H5
            showParam.backUrl="tbopen25316706"
            showParam.linkKey = "taobao"
            showParam.isNeedPush=true
            showParam.nativeFailMode = AlibcNativeFailMode.jumpH5
            
            let page = AlibcTradePageFactory.myOrdersPage(0, isAllOrder: true)
            AlibcTradeSDK.sharedInstance().tradeService().show(self.viewContainingController()!, page: page, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                
            }, tradeProcessFailedCallback: { (error) in
                
            })
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

extension LNMineInfoCell : UIViewControllerTransitioningDelegate {
        
}
