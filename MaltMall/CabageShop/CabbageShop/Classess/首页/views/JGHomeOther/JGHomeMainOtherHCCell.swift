//
//  JGHomeMainOtherHCCell.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/8/30.
//  Copyright © 2019 宋. All rights reserved.
//  横向排布 一行一列

import UIKit
import SwiftyUserDefaults

class JGHomeMainOtherHCCell: JGBaseCollectionViewCell {
    
    var Icon :UIImageView? //图片
    var TitleLbl:UILabel? //标题
    var CPriceLbl:UILabel? //现价
    var Logo :UIImageView? //logo
    var LogoLbl:UILabel? //logo说明
    var GetMoenyBtn:UIButton? //约赚
    var MoenyBtn:UIButton? //约赚
    
    
    
    override func configUI() {
        
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        
        Icon = UIImageView()
        //        Icon?.backgroundColor = UIColor.random
        
        TitleLbl = UILabel()
        TitleLbl?.textColor = UIColor.hex("#5D5D5D")
        TitleLbl?.font = UIFont.font(12)
        TitleLbl?.numberOfLines = 2
        //        TitleLbl?.text = "不好吃上传上传白蛇传说不擅长不是是才好深V缓存办事处近几年"
        
        CPriceLbl = UILabel()
        CPriceLbl?.textColor = UIColor.hex("#DCBF9E")
        CPriceLbl?.font = UIFont.boldFont(16)
        //        CPriceLbl?.text = "¥3850"
        
        
        
        Logo = UIImageView()
        Logo?.backgroundColor = UIColor.random
        
        LogoLbl = UILabel()
        LogoLbl?.textColor = UIColor.hex("#D3D3D3")
        LogoLbl?.font = UIFont.font(11)
        //        LogoLbl?.text = "淘票票"
        
        GetMoenyBtn = UIButton()
        GetMoenyBtn?.isUserInteractionEnabled = false
        GetMoenyBtn?.titleLabel?.font = UIFont.font(11)
        GetMoenyBtn?.setTitle("预约赚 ¥0.00", for: .normal)
        GetMoenyBtn?.setBackgroundImage(UIImage(named: "jg_bg_copy"), for: .normal)
        
        MoenyBtn = UIButton()
        MoenyBtn?.isUserInteractionEnabled = false
        MoenyBtn?.titleLabel?.font = UIFont.font(11)
        MoenyBtn?.setTitle("预约赚 ¥0.00", for: .normal)
        MoenyBtn?.setBackgroundImage(UIImage(named: "jg_bg_cou_bg"), for: .normal)
        
        
        addSubview(Icon!)
        addSubview(TitleLbl!)
        addSubview(CPriceLbl!)
        addSubview(Logo!)
        addSubview(LogoLbl!)
        addSubview(GetMoenyBtn!)
        addSubview(MoenyBtn!)
        
        
        Icon?.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(kWidthScale(130))
        })
        
        TitleLbl?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(Icon!.snp_right).offset(10)
            make.top.equalTo(Icon!.snp_top)
        })
        
        CPriceLbl?.snp.makeConstraints({ (make) in
            make.left.equalTo(TitleLbl!.snp_left)
            make.top.equalTo(Icon!.snp_top).offset(43)
        })
        
        
        Logo?.snp.makeConstraints({ (make) in
            make.right.equalTo(LogoLbl!.snp_left).offset(-5)
            make.centerY.equalTo(CPriceLbl!.snp_centerY)
        })
        
        LogoLbl?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(CPriceLbl!.snp_centerY)
            make.right.equalToSuperview().inset(10)
        })
        
        
        GetMoenyBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(TitleLbl!.snp_left)
            make.bottom.equalToSuperview().inset(26)
            make.width.equalTo(kWidthScale(80))
            make.height.equalTo(20)
        })
        
        MoenyBtn?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(26)
            make.width.equalTo(kWidthScale(80))
            make.height.equalTo(20)
        })
    }
    
    public var model1 : SZYGoodsInformationModel? {
        didSet {
            if model1 == nil {
                return
            }
            TitleLbl!.text = model1?.title
            
            switch model1?.type {
            case "1":
                if model1!.shop_type == "2" {
                    Logo?.image = UIImage(named: "tianmao_icon")
                    LogoLbl?.text = "天猫"
                }else{
                    Logo?.image = UIImage(named: "miaosha_mark")
                     LogoLbl?.text = "淘宝"
                }
            case "2":
                Logo?.image = UIImage(named: "jd_mark")
                LogoLbl?.text = "京东"
            default:
                Logo?.image = UIImage(named: "pdd_mark")
                LogoLbl?.text = "拼多多"
            }
            
            //            kDeBugPrint(item: model1?.finalCommission)
            
            
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                MoenyBtn!.isHidden = true
            } else {
                MoenyBtn!.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1?.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1?.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                MoenyBtn!.setTitle("  预计赚￥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
            }
            
            let cou : String = OCTools().getStrWithIntStr(model1!.coupon_price) + "元券"
            GetMoenyBtn?.setTitle(cou, for: .normal)
            //            sale_count.text = "已售 "+(model1!.volume)
            CPriceLbl!.text = "￥" + OCTools().getStrWithFloatStr2(model1?.final_price)
            //            old_price.text = "￥"+OCTools().getStrWithFloatStr2(model1?.price)
            
            Icon!.sd_setImage(with: OCTools.getEfficientAddress(model1?.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }
    
    
}
