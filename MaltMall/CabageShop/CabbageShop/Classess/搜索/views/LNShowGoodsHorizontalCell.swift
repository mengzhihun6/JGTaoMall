//
//  LNShowGoodsHorizontalCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LNShowGoodsHorizontalCell: UICollectionViewCell {

    
    @IBOutlet weak var earnMoneyBg: UIImageView!

    @IBOutlet weak var earn_money: UILabel!
    
    @IBOutlet weak var good_icon: UIImageView!
    
    @IBOutlet weak var good_Store: UILabel!
    
    @IBOutlet weak var good_title: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var sale_count: UILabel!
    @IBOutlet weak var sold_count: UILabel! //已售
    
    @IBOutlet weak var quanLabel: UILabel!
    @IBOutlet weak var now_price: UILabel!
    @IBOutlet weak var old_price: UILabel!

    @IBOutlet weak var goodImage: UIButton!
    
    @IBOutlet weak var paiming: UIButton!
    
    @IBOutlet weak var underLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        earn_money.backgroundColor = kSetRGBAColor(r: 255, g: 233, b: 233, a: 1)
//        earn_money.backgroundColor = kSetRGBColor(r: 140, g: 140, b: 245)
//        earn_money.setTitleColor(UIColor.white, for: .normal)
//        earn_money.cornerRadius = 2
//        earn_money.clipsToBounds = true
//
//        good_icon.cornerRadius = 5
//        good_icon.clipsToBounds = true
//
//        quanLabel.textColor = kMainColor1()
//        now_price.textColor = kMainColor1()
//
//        discount.textColor = kMainColor1()
//        discountLabel.textColor = kMainColor1()


        paiming.isHidden = true
        sale_count.isHidden = true
        sale_count.backgroundColor = kSetRGBAColor(r: 25, g: 25, b: 25, a: 0.6)
    }
    
    
    func setValues(model:LNYHQModel,type:String) {
        good_title.text = model.title
        
        switch type {
        case "1":
            goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
        case "2":
            goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
        case "3":
            goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
        default:
            goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
        }
        
        if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
            
            earn_money.text = "预计赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)
//            earn_money.setTitle(" 奖￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+" ", for: .normal)
        }else{
            earn_money.isHidden = true
        }
        
        discount.text = " "+OCTools().getStrWithIntStr(model.coupon_price)+"元 "
        sale_count.text = "已售 "+(model.volume)
        now_price.text = OCTools().getStrWithFloatStr2(model.final_price)
        old_price.text = OCTools().getStrWithFloatStr2(model.price)
        good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
    }   

    
    public var model : LNYHQModel = LNYHQModel() {
        didSet {
            goodImage.isHidden = true
            good_Store.isHidden = true
//            let price = OCTools().getStrWithFloatStr2(model.gain_price)
//            if price != nil {
//                earn_money.setTitle("赚"+price!, for: .normal)
//            }
            good_title.text = model.title
            sale_count.text = "销量"+model.volume+"件"
            
            switch model.type {
            case "1":
                if model.shop_type == "2" {
                    goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
                }else{
                    goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
                }
            case "2":
                goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
            default:
                goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
            }

            if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
                
                earnMoneyBg.isHidden = false
                earn_money.isHidden = false
                earn_money.text = "预计赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)
//                earn_money.setTitle("  预计赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+"  ", for: .normal)
            }else{
                earnMoneyBg.isHidden = true
                earn_money.isHidden = true
            }

            old_price.text = OCTools().getStrWithFloatStr2(model.price)
            discount.text = OCTools().getStrWithIntStr(model.coupon_price) + "元券"
            sold_count.text = "已售 " + model.volume
            now_price.text = OCTools().getStrWithFloatStr2(model.final_price)

            good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }
    
    public var model1 : SZYGoodsInformationModel = SZYGoodsInformationModel() {
        didSet {
            goodImage.isHidden = true
//            good_Store.isHidden = true
//            let price = OCTools().getStrWithFloatStr2(model.gain_price)
//            if price != nil {
//                earn_money.setTitle("赚"+price!, for: .normal)
//            }
            good_title.text = model1.title
            sale_count.text = "销量"+model1.volume+"件"
            
            switch model1.type {
            case "1":
                if model1.shop_type == "2" {
                    goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
                }else{
                    goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
                }
            case "2":
                goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
            default:
                goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
            }
            good_Store.text = model1.nick
//            if OCTools().getStrWithFloatStr2(model1.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model1.finalCommission) != "0.00"{
//                earn_money.setTitle("  预计赚￥"+OCTools().getStrWithFloatStr2(model1.finalCommission)+"  ", for: .normal)
//            }else{
//                earn_money.isHidden = true
//            }
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                earn_money.isHidden = true
            } else {
                earn_money.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                
                earn_money.text = "预计赚￥" + String.init(format:"%.2f",jieguo)

//                earn_money.setTitle("  预计赚￥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
            }
            
            
            old_price.text = OCTools().getStrWithFloatStr2(model1.price)
            discount.text = OCTools().getStrWithIntStr(model1.coupon_price) + "元券"
            sold_count.text = "已售 " + model1.volume
            now_price.text = OCTools().getStrWithFloatStr2(model1.final_price)
            
            good_icon.sd_setImage(with: OCTools.getEfficientAddress(model1.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }
    
    
    func setModel(model:LNYHQModel,index:NSInteger) {
        good_title.text = model.title
        sale_count.text = "月售 "+model.volume
        
        underLine.isHidden = false

        sale_count.isHidden = false
        paiming.isHidden = false
        
        paiming.setTitle(String(index+1), for: .normal)
        switch model.type {
        case "1":
            if model.shop_type == "2" {
                goodImage.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
            }else{
                goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
            }
        case "2":
            goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
        default:
            goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
        }
        
        if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
//            earn_money.setTitle(" 奖￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+" ", for: .normal)
            earn_money.text = "预计赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)

        }else{
            earn_money.isHidden = true
        }

        old_price.text = OCTools().getStrWithFloatStr2(model.price)
        discount.text = "￥"+OCTools().getStrWithIntStr(model.coupon_price)
        sale_count.text = "月销 "+(model.volume)
        now_price.text = OCTools().getStrWithFloatStr2(model.final_price)
        
        good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
    }

    
}
