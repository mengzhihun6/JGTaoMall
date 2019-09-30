//
//  CardCell.swift
//  ScrollCard
//
//  Created by Tony on 2017/9/26.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class CourseCardCell: UICollectionViewCell {
    
    @IBOutlet weak var goodImage: UIImageView!
    
    @IBOutlet weak var goodTitle: UILabel!
    
    @IBOutlet weak var newPrice: UILabel!
    
    @IBOutlet weak var priceDan: UILabel!
    
    @IBOutlet weak var saleCount: UILabel!
    
    @IBOutlet weak var discount: UIButton!
    @IBOutlet weak var theHeight: NSLayoutConstraint!
    
    @IBOutlet weak var coverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        goodImage.cornerRadius = 2
        
        goodImage.clipsToBounds = true
        
        newPrice.textColor = kMainColor1()
        priceDan.textColor = kMainColor1()
        discount.backgroundColor = kMainColor1()
        
        discount.cornerRadius = discount.height/2
        discount.clipsToBounds = true
    }
    
    
    public var model = LNYHQListModel() {
        didSet {
            
            goodTitle.text = model.title
            
            newPrice.text = OCTools().getStrWithFloatStr1(model.final_price)
            
            goodImage.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
            saleCount.text = "已售"+model.volume
            discount.setTitle(OCTools().getStrWithIntStr(model.coupon_price)+"元券", for: .normal)
        }
    }

    
}
