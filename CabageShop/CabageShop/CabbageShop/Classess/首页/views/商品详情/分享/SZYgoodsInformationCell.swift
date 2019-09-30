//
//  SZYgoodsInformationCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/21.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SZYgoodsInformationCell: UITableViewCell {

    @IBOutlet weak var icon_imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var old_price: UILabel!
    @IBOutlet weak var youhuiquanBun: UIButton!
    @IBOutlet weak var zhuanBun: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupValuse(model: SZYGoodsInformationModel) {
        if model.type == "1" {
            icon_imageView.image = UIImage.init(named: "miaosha_mark")
        } else {
            icon_imageView.image = UIImage.init(named: "tianmao_icon")
        }
        nameLabel.text = model.title
        numLabel.text = model.volume
        price_label.text = model.final_price
        old_price.text = "¥"+model.price
        youhuiquanBun.setTitle("  "+model.coupon_price+"元券  ", for: .normal)
//        if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
//            zhuanBun.isHidden = false
//            zhuanBun.setTitle("  预估赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+"  ", for: .normal)
//        }else{
//            zhuanBun.isHidden = true
//        }
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            zhuanBun.isHidden = true
        } else {
            zhuanBun.isHidden = false
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            zhuanBun.setTitle("  预估赚￥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
