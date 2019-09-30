//
//  JTHCommodityInformationCollectionViewCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/1.
//  Copyright © 2019 HT. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class JTHCommodityInformationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var goods_imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var store_imageView: UIImageView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var couponsButton: UIButton!
    @IBOutlet weak var shareMakeButton: UIButton!
    @IBOutlet weak var upgradeMakeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpModel(model: SZYGoodsInformationModel) {
        
        goods_imageView.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        
        titleLabel.text = ".    \(model.title)"//文字前边有个小图片，用”.   “占位，这块可以做图文混排（时间紧任务重，你懂得）

        if model.type == "1" { //1淘宝 2京东 3拼多多
            if model.shop_type == "1" {  //1淘宝 2天猫
                store_imageView.image = UIImage.init(named: "miaosha_mark")
            } else if model.shop_type == "2" {
                store_imageView.image = UIImage.init(named: "tianmao_icon")
            }
        } else if model.type == "2" {
            store_imageView.image = UIImage.init(named: "京东")
        } else if model.type == "3" {
            store_imageView.image = UIImage.init(named: "拼多多")
        }
        storeLabel.text = model.nick
        priceLabel.text = "¥" + OCTools().getStrWithFloatStr2(model.final_price)
        oldPriceLabel.text = "¥" + OCTools().getStrWithFloatStr2(model.price)
        
        couponsButton.setTitle("  " + OCTools().getStrWithIntStr(model.coupon_price) + "元券  ", for: .normal)
        salesLabel.text = OCTools().getStrWithIntStr(model.volume) + "人购买"
        
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            shareMakeButton.isHidden = true
            upgradeMakeButton.isHidden = true
        } else {
            shareMakeButton.isHidden = false
            upgradeMakeButton.isHidden = false
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            
//            let shengjizhuan = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kNextCommissionRate]!) / 100
            shareMakeButton.setTitle("  分享赚¥\(String(format: "%.2f", jieguo))  ", for: .normal)
//            upgradeMakeButton.setTitle("  升级赚¥\(String(format: "%.2f", shengjizhuan))  ", for: .normal)
        }
        
    }
    
}
