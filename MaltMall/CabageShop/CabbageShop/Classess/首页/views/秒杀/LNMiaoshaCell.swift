//
//  LNMiaoshaCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/15.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LNMiaoshaCell: UITableViewCell {

    @IBOutlet weak var goodImage: UIImageView!
    
    @IBOutlet weak var goodTitle: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var theCount: UILabel!
    
    @IBOutlet weak var coupon_price: UILabel!
    
    @IBOutlet weak var realPrice: UILabel!
    
    @IBOutlet weak var goBuy: UIButton!
    @IBOutlet weak var old_price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goBuy.backgroundColor = kSetRGBColor(r: 140, g: 140, b: 245)
        goBuy.setTitleColor(UIColor.white, for: .normal)
        goBuy.cornerRadius = 2
        goBuy.clipsToBounds = true
        
        goodImage.cornerRadius = 2
        goodImage.clipsToBounds = true
        
//        goBuy.backgroundColor = kMainColor1()
//        theCount.textColor = kMainColor1()
    }
    
    
    public var model = LNMiaoshaModel() {
        didSet {
            goodImage.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
            goodTitle.text = model.title
            subTitle.text = model.short_title
            theCount.text = model.sales
            coupon_price.text = OCTools().getStrWithIntStr(model.coupon_price)+"元券"
            old_price.text = "￥"+OCTools().getStrWithFloatStr2(model.price)
            if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
                goBuy.setTitle(" 预计赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+" ", for: .normal)
                goBuy.isHidden = false
            }else{
                goBuy.isHidden = true
            }

            realPrice.text = model.final_price
        }
    }
    public var model1 = SZYGoodsInformationModel() {
        didSet {
            goodImage.sd_setImage(with: OCTools.getEfficientAddress(model1.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
            goodTitle.text = model1.title
            subTitle.text = model1.short_title
            theCount.text = model1.sales
            coupon_price.text = OCTools().getStrWithIntStr(model1.coupon_price)+"元券"
            old_price.text = "￥"+OCTools().getStrWithFloatStr2(model1.price)
//            if OCTools().getStrWithFloatStr2(model1.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model1.finalCommission) != "0.00"{
//                goBuy.setTitle(" 预计赚￥"+OCTools().getStrWithFloatStr2(model1.finalCommission)+" ", for: .normal)
//                goBuy.isHidden = false
//            }else{
//                goBuy.isHidden = true
//            }
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                goBuy.isHidden = true
            } else {
                goBuy.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                goBuy.setTitle(" 预计赚￥" + String.init(format:"%.2f",jieguo) + " ", for: .normal)
            }
            realPrice.text = model1.final_price
        }
    }
    public var model2 = SZYGoodsInformationModel() {
        didSet {
            goodImage.sd_setImage(with: OCTools.getEfficientAddress(model2.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
            goodTitle.text = model2.title
            subTitle.text = model2.short_title
            theCount.text = model2.volume
            coupon_price.text = OCTools().getStrWithIntStr(model2.coupon_price)+"元券"
            old_price.text = "￥"+OCTools().getStrWithFloatStr2(model2.price)
//            if OCTools().getStrWithFloatStr2(model2.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model2.finalCommission) != "0.00"{
//                goBuy.setTitle(" 预计赚￥"+OCTools().getStrWithFloatStr2(model2.finalCommission)+" ", for: .normal)
//                goBuy.isHidden = false
//            }else{
//                goBuy.isHidden = true
//            }
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                goBuy.isHidden = true
            } else {
                goBuy.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model2.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model2.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                goBuy.setTitle(" 预计赚￥" + String.init(format:"%.2f",jieguo) + " ", for: .normal)
            }
            
            
            realPrice.text = model2.final_price
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
