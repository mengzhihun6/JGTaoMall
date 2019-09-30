//
//  JTHtaobaoCollectionViewCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/3.
//  Copyright © 2019 HT. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class JTHtaobaoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var xiaoliangLabel: UILabel!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var store_titleLabel: UILabel!
    @IBOutlet weak var youhuiquanBun: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var fenxiangzhuanBun: UIButton!
    @IBOutlet weak var shengjizhuanBun: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpModel(model: SZYGoodsInformationModel) {
        goodsImageView.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        
        titleLabel.text = ".    \(model.title)"//文字前边有个小图片，用”.   “占位，这块可以做图文混排（时间紧任务重，你懂得）
        if model.type == "1" { //1淘宝 2京东 3拼多多
            if model.shop_type == "1" {  //1淘宝 2天猫
                storeImageView.image = UIImage.init(named: "miaosha_mark")
            } else if model.shop_type == "2" {
                storeImageView.image = UIImage.init(named: "tianmao_icon")
            }
        } else if model.type == "2" {
            storeImageView.image = UIImage.init(named: "京东")
        } else if model.type == "3" {
            storeImageView.image = UIImage.init(named: "拼多多")
        }
        priceLabel.text = OCTools().getStrWithFloatStr2(model.final_price)
        oldPriceLabel.text = "¥" + OCTools().getStrWithFloatStr2(model.price)
        xiaoliangLabel.text = OCTools().getStrWithIntStr(model.volume)
        
        youhuiquanBun.setTitle("  " + OCTools().getStrWithIntStr(model.coupon_price) + "元券  ", for: .normal)
        
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            fenxiangzhuanBun.isHidden = true
            shengjizhuanBun.isHidden = true
        } else {
            fenxiangzhuanBun.isHidden = false
            shengjizhuanBun.isHidden = false
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            
//            let shengjizhuan = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kNextCommissionRate]!) / 100
            
            fenxiangzhuanBun.setTitle("  预计赚¥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
//            shengjizhuanBun.setTitle("  升级赚¥" + String.init(format:"%.2f",shengjizhuan) + "  ", for: .normal)
        }
        
    }
    
}
