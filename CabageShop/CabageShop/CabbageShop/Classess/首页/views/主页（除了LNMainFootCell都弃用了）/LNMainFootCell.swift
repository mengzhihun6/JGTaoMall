//
//  LNMainFootCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LNMainFootCell: UICollectionViewCell {

    
    @IBOutlet weak var good_icon: UIImageView!
    
    @IBOutlet weak var earn_money: UIButton!
    
    @IBOutlet weak var good_title: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var discountLabel: UILabel!

    @IBOutlet weak var sale_count: UILabel!
    
    @IBOutlet weak var quanLabel: UILabel!
    @IBOutlet weak var now_price: UILabel!
    @IBOutlet weak var old_price: UILabel!

    @IBOutlet weak var goodMark: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        earn_money.clipsToBounds = true
        earn_money.layer.cornerRadius = 4
        
//        good_icon.cornerRadius = 5
        good_icon.clipsToBounds = true
        
        earn_money.backgroundColor = kSetRGBColor(r: 140, g: 140, b: 245)
//        earn_money.setTitleColor(kMainColor1(), for: .normal)
        earn_money.setTitleColor(UIColor.white, for: .normal)
        earn_money.cornerRadius = 2
        earn_money.clipsToBounds = true
    }
    
    
    public var model : LNYHQModel? {
        didSet {
            if model == nil {
                return
            }
            good_title.text = model?.title
            
            switch model?.type {
            case "1":
                if model!.shop_type == "2" {
                    goodMark.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
                }else{
                    goodMark.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
                }
            case "2":
                goodMark.setImage(UIImage.init(named: "jd_mark"), for: .normal)
            default:
                goodMark.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
            }
            kDeBugPrint(item: model?.finalCommission)

            if OCTools().getStrWithFloatStr2(model?.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model?.finalCommission) != "0.00"{
                earn_money.setTitle(" 预计赚￥"+OCTools().getStrWithFloatStr2(model?.finalCommission)+" ", for: .normal)
                earn_money.isHidden = false
            }else{
                earn_money.isHidden = true
            }

//            discount.text = "￥"+OCTools().getStrWithIntStr(model!.coupon_price)
            discount.text = OCTools().getStrWithIntStr(model!.coupon_price) + "元券"
            sale_count.text = "已售 "+(model!.volume)
            now_price.text = OCTools().getStrWithFloatStr2(model?.final_price)
            old_price.text = "￥"+OCTools().getStrWithFloatStr2(model?.price)

            good_icon.sd_setImage(with: OCTools.getEfficientAddress(model?.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }
    public var model1 : SZYGoodsInformationModel? {
        didSet {
            if model1 == nil {
                return
            }
            good_title.text = model1?.title
            
            switch model1?.type {
            case "1":
                if model1!.shop_type == "2" {
                    goodMark.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
                }else{
                    goodMark.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
                }
            case "2":
                goodMark.setImage(UIImage.init(named: "jd_mark"), for: .normal)
            default:
                goodMark.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
            }
            kDeBugPrint(item: model1?.finalCommission)
            
//            if OCTools().getStrWithFloatStr2(model1?.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model1?.finalCommission) != "0.00"{
//                earn_money.setTitle(" 预计赚￥"+OCTools().getStrWithFloatStr2(model1?.finalCommission)+" ", for: .normal)
//                earn_money.isHidden = false
//            }else{
//                earn_money.isHidden = true
//            }
            
            if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
                earn_money.isHidden = true
            } else {
                earn_money.isHidden = false
                let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1?.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model1?.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
                earn_money.setTitle("  预计赚￥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
            }
            
            
            
            discount.text = OCTools().getStrWithIntStr(model1!.coupon_price) + "元券"
            sale_count.text = "已售 "+(model1!.volume)
            now_price.text = OCTools().getStrWithFloatStr2(model1?.final_price)
            old_price.text = "￥"+OCTools().getStrWithFloatStr2(model1?.price)
            
            good_icon.sd_setImage(with: OCTools.getEfficientAddress(model1?.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }
    
    public var model2 : LNYHQListModel? {
        didSet {
            if model2 == nil {
                return
            }
            
            switch model2?.type {
            case "1":
                if model2!.shop_type == "2" {
                    goodMark.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
                }else{
                    goodMark.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
                }
            case "2":
                goodMark.setImage(UIImage.init(named: "jd_mark"), for: .normal)
            default:
                goodMark.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
            }

            if OCTools().getStrWithFloatStr2(model2?.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model2?.finalCommission) != "0.00"{
                earn_money.setTitle(" 预计赚￥"+OCTools().getStrWithFloatStr2(model2?.finalCommission)+" ", for: .normal)
                earn_money.isHidden = false
            }else{
                earn_money.isHidden = true
            }

//            discount.text = "￥"+OCTools().getStrWithIntStr(model2?.coupon_price)
            discount.text = OCTools().getStrWithIntStr(model2!.coupon_price) + "元券"
            good_title.text = (model2?.title)!
            
            sale_count.text = "已售 "+(model2?.volume)!
            now_price.text = OCTools().getStrWithFloatStr2(model2?.final_price)
            old_price.text = "￥"+OCTools().getStrWithFloatStr2(model2?.price)

            good_icon.sd_setImage(with: OCTools.getEfficientAddress(model2?.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }

    func setValues(model:LNYHQModel,type:String) {
        good_title.text = model.title
        
        switch model.type {
        case "1":
            if model.shop_type == "2" {
                goodMark.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
            }else{
                goodMark.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
            }
        case "2":
            goodMark.setImage(UIImage.init(named: "jd_mark"), for: .normal)
        default:
            goodMark.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
        }

        if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
            
            earn_money.setTitle(" 奖￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+" ", for: .normal)
            earn_money.isHidden = false
        }else{
            earn_money.isHidden = true
        }

        discount.text = " "+OCTools().getStrWithIntStr(model.coupon_price)+"元 "
        sale_count.text = "销量"+(model.volume)+"件"
        now_price.text = OCTools().getStrWithFloatStr2(model.final_price)
        
        good_icon.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
    }
    
    
}
