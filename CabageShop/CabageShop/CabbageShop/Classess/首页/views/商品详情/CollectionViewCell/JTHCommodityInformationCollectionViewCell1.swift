//
//  JTHCommodityInformationCollectionViewCell1.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/1.
//  Copyright © 2019 HT. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class JTHCommodityInformationCollectionViewCell1: UICollectionViewCell {
    @IBOutlet weak var goods_ImageView: UIImageView!
    @IBOutlet weak var store_imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yujizhaunBun: UIButton!
    @IBOutlet weak var shengjizhuanBun: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var youhuiquanBun: UIButton!
    @IBOutlet weak var salesLabel: UILabel!
    
    @IBOutlet weak var goods_imageView_height: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code   sales
    }
    
    func setUpModel(model: SZYGoodsInformationModel) {
        goods_imageView_height.constant = (kSCREEN_WIDTH - 8 - 24) / 2
        
        goods_ImageView.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        titleLabel.text = model.title
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
        priceLabel.text = OCTools().getStrWithFloatStr2(model.final_price)
        oldPriceLabel.text = "¥" + OCTools().getStrWithFloatStr2(model.price)
        salesLabel.text = "销量" + OCTools().getStrWithIntStr(model.volume)
        youhuiquanBun.setTitle("  " + OCTools().getStrWithIntStr(model.coupon_price) + "元券  ", for: .normal)
        
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            yujizhaunBun.isHidden = true
            shengjizhuanBun.isHidden = true
        } else {
            yujizhaunBun.isHidden = false
            shengjizhuanBun.isHidden = false
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            
//            let shengjizhuan = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kNextCommissionRate]!) / 100
            
            yujizhaunBun.setTitle("  预计赚¥\(String(format: "%.2f", jieguo))  ", for: .normal)
//            shengjizhuanBun.setTitle("  升级赚¥\(String(format: "%.2f", shengjizhuan))  ", for: .normal)
        }
        
    }
    
}
