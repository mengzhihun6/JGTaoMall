//
//  SZYLNMineInfoCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/15.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyUserDefaults

class SZYLNMineInfoCell: UITableViewCell {

    @IBOutlet weak var user_icon: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var xinxiBun: UIButton!
    @IBOutlet weak var shezhiBun: UIButton!
    @IBOutlet weak var chaojihuiyuanHeight: NSLayoutConstraint!
    @IBOutlet weak var yaoqingmaLeading: NSLayoutConstraint!
    @IBOutlet weak var yaoqingmaLabel: UILabel!
    @IBOutlet weak var fuzhiBun: UIButton!
    
    @IBOutlet weak var yueLabel: UILabel!
    @IBOutlet weak var tixianBun: UIButton!
    @IBOutlet weak var jinrishouyiLabel: UILabel!
    @IBOutlet weak var zuorishouyiLabel: UILabel!
    @IBOutlet weak var benyueshouyiLabel: UILabel!
    @IBOutlet weak var shangyueshouyiLabel: UILabel!
    
    @IBOutlet weak var quanbudingdanBun: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    
    @IBOutlet weak var shouyiView: UIView!
    @IBOutlet weak var dingdanView: UIView!
    @IBOutlet weak var tuanduiView: UIView!
    @IBOutlet weak var user_icon_topHieht: NSLayoutConstraint!
    @IBOutlet weak var headImageView_height: NSLayoutConstraint!
    @IBOutlet weak var chaojiVipBun: UIButton!
    
    var userModel : SZYPersonalCenterModel?
    var ChartModel : SZYChartModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Device() == .iPhoneX {
            user_icon_topHieht.constant = 42 + 20
            headImageView_height.constant = 135 + 20
        }
        
        if kSCREEN_HEIGHT == 812 {
            user_icon_topHieht.constant = 42 + 20
            headImageView_height.constant = 135 + 20
        }
        
        shouyiView.clipsToBounds = true
        shouyiView.cornerRadius = 5
        
        dingdanView.clipsToBounds = true
        dingdanView.cornerRadius = 5
        
        tuanduiView.clipsToBounds = true
        tuanduiView.cornerRadius = 5
        
        user_icon.clipsToBounds = true
        user_icon.cornerRadius = user_icon.height / 2.0
        
        quanbudingdanBun.layoutButton(with: .right, imageTitleSpace: 3)
        chaojiVipBun.clipsToBounds = true
        chaojiVipBun.cornerRadius = chaojiVipBun.height / 2.0
        
        
        button1.layoutButton(with: .top, imageTitleSpace: 8)
        button2.layoutButton(with: .top, imageTitleSpace: 8)
        button3.layoutButton(with: .top, imageTitleSpace: 8)
        button4.layoutButton(with: .top, imageTitleSpace: 8)
        
        button5.layoutButton(with: .top, imageTitleSpace: 8)
        button6.layoutButton(with: .top, imageTitleSpace: 8)
        button7.layoutButton(with: .top, imageTitleSpace: 8)
        button8.layoutButton(with: .top, imageTitleSpace: 8)
        
        user_icon.sd_setImage(with: OCTools.getEfficientAddress(Defaults[kUserIcon]), placeholderImage: UIImage.init(named: "goodImage_1"))
        user_name.text = Defaults[kUsername]
        yaoqingmaLabel.text = Defaults[kHashid]
        chaojiVipBun.setImage(UIImage.init(named: "皇冠"), for: .normal)
        chaojiVipBun.setTitle(Defaults[kIsSuper_VIP], for: .normal)
        chaojiVipBun.layoutButton(with: .left, imageTitleSpace: 2)
    }
    
    func setUpUserInfo(model:SZYPersonalCenterModel, chart:SZYChartModel) {
        userModel = model
        ChartModel = chart
        user_icon.sd_setImage(with: OCTools.getEfficientAddress(model.headimgurl), placeholderImage: UIImage.init(named: "goodImage_1"))
        user_name.text = model.nickname
        if model.inviter_id.count != 0 {
            if model.invite_code != "" {
                yaoqingmaLabel.text = model.invite_code
            } else {
                yaoqingmaLabel.text = model.hashid
            }
            fuzhiBun.isHidden = false
        } else {
            yaoqingmaLabel.text = "无"
            fuzhiBun.isHidden = true
        }
        yueLabel.text = OCTools().getStrWithFloatStr2(model.credit1)
        
        jinrishouyiLabel.text       = OCTools().getStrWithFloatStr2(chart.today)
        zuorishouyiLabel.text       = OCTools().getStrWithFloatStr2(chart.yesterday)
        benyueshouyiLabel.text      = OCTools().getStrWithFloatStr2(chart.month)
        shangyueshouyiLabel.text    = OCTools().getStrWithFloatStr2(chart.lastMonthCommission)
        
        chaojiVipBun.setImage(UIImage.init(named: "皇冠"), for: .normal)
        chaojiVipBun.setTitle(userModel?.level.name, for: .normal)
        chaojiVipBun.layoutButton(with: .left, imageTitleSpace: 2)
        
        chaojihuiyuanHeight.constant = 90
        yaoqingmaLeading.constant     = 12
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func xinxiBunClick(_ sender: UIButton) {//信息点击事件
    }
    @IBAction func shezhiBunClick(_ sender: UIButton) {//设置点击事件
        if userModel == nil {
            return
        }
        let vc = LNSettingViewController()
        vc.model1 = userModel!
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func fuzhiBunClick(_ sender: UIButton) {//复制点击事件
        if userModel?.hashid == nil {
            return
        }
        let paste = UIPasteboard.general
        paste.string = userModel?.hashid
        setToast(str: "复制成功")
    }
    @IBAction func tixianBunClick(_ sender: UIButton) {//提现点击事件
        if userModel == nil {
            return
        }
        let vc = LNWithdrawViewController()
        vc.model1 = userModel!
        vc.model2 = ChartModel!
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func shouyiBunClick(_ sender: UIButton) {//收益点击事件
        //301 -- 304
        if userModel == nil {
            return
        }
        let vc = LNMyEarningViewController()
        vc.userModel = userModel
        kDeBugPrint(item: sender.tag)
        if sender.tag == 301 {
            vc.selectIndex = 1
        } else if sender.tag == 302 {
            vc.selectIndex = 2
        } else if sender.tag == 303 {
            vc.selectIndex = 4
        } else if sender.tag == 304 {
            vc.selectIndex = 5
        }
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func dingdanBunClick(_ sender: UIButton) {//订单点击事件
        if userModel == nil {
            return
        }
        kDeBugPrint(item: "订单"+String(sender.tag))
        let vc = LNOrderViewController()
        if sender.tag == 100 {
            vc.select_sort = ""
        } else {
            vc.select_sort = String(sender.tag - 100)
        }
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tuanduiBunClick(_ sender: UIButton) {//团队点击事件
        if userModel == nil {
            return
        }
        kDeBugPrint(item: "团队"+String(sender.tag))
        switch sender.tag {
        case 200:
            kDeBugPrint(item: userModel?.level.name)
            
            if userModel?.level.is_group == "1" {
                let vc = LNOrderViewController()
                vc.select_sort = ""
                vc.classify = "3"
                viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
            } else {
                OCTools().presnetShareVc3(self.viewContainingController()?.tabBarController, controller: viewContainingController()?.navigationController, vip:userModel?.level.name)  //弹出
            }
            
            break
        case 201:
//            OCTools().presnetShareVc3(self.viewContainingController()?.tabBarController, controller: viewContainingController()?.navigationController)  //弹出
            viewContainingController()?.navigationController?.pushViewController(LNNewTeamDetailViewController(), animated: true)
            break
        case 202:
            let vc = LNMyEarningViewController()
            vc.userModel = userModel
            viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
            break
        case 203: // 提交订单
            let vc = SZYSubmitOrdersViewController()
            viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    @IBAction func wodeshouyiBunClick(_ sender: UIButton) {//我的收益点击事件
        if userModel == nil {
            return
        }
        let vc = LNMyEarningViewController()
        vc.userModel = userModel
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func wodedingdanBunClick(_ sender: UIButton) {//我的更多订单
        if userModel == nil {
            return
        }
        let vc = LNOrderViewController()
        vc.select_sort = ""
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
