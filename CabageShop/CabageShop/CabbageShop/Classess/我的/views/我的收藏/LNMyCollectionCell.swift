//
//  LNMyCollectionCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMyCollectionCell: UITableViewCell {
    @IBOutlet weak var earn_money: UIButton!
    
    @IBOutlet weak var good_icon: UIImageView!
    
    
    @IBOutlet weak var good_title: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var discountLabel: UILabel!

    @IBOutlet weak var sale_count: UILabel!
    
    @IBOutlet weak var quanLabel: UILabel!
    @IBOutlet weak var now_price: UILabel!
    @IBOutlet weak var old_price: UILabel!

    @IBOutlet weak var goodImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        earn_money.clipsToBounds = true
        earn_money.layer.cornerRadius = 4
        
        good_icon.cornerRadius = 5
        good_icon.clipsToBounds = true

        quanLabel.textColor = kMainColor1()
        now_price.textColor = kMainColor1()
//        good_title.textColor = kMainColor1()
        
        discount.textColor = kMainColor1()
        discountLabel.textColor = kMainColor1()

    }
    
    
    public var model : LNMyCollectionModel? {
        didSet {
            
            if model == nil{
                return
            }
            switch model!.type {
            case "1":
                goodImage.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
            case "2":
                goodImage.setImage(UIImage.init(named: "jd_mark"), for: .normal)
            default:
                goodImage.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
            }

            earn_money.setTitle(model?.coupon_price, for: .normal)
            discount.text = "￥"+OCTools().getStrWithIntStr(model!.coupon_price)
            good_title.text = model?.title
            sale_count.text = "销量"+(model?.volume)!+"件"
            now_price.text = "￥"+(model?.final_price)!
            old_price.text = "原价￥"+(model?.price)!
            good_icon.sd_setImage(with: OCTools.getEfficientAddress(model?.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
