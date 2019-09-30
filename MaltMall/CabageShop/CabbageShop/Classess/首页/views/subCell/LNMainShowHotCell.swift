//
//  LNMainShowHotCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMainShowHotCell: UICollectionViewCell {

    @IBOutlet weak var goodImage: UIImageView!
    
    @IBOutlet weak var goodTitle: UILabel!
    
    @IBOutlet weak var newPrice: UIButton!
    
    @IBOutlet weak var oldPrice: UILabel!
    
    @IBOutlet weak var theHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        goodImage.cornerRadius = 2
        goodImage.clipsToBounds = true
    }
    
    
    public var model = LNYHQListModel() {
        didSet {
            
            goodTitle.text = model.title
            
            oldPrice.text = "￥"+OCTools().getStrWithFloatStr1(model.price)
            newPrice.setTitle("券后￥"+OCTools().getStrWithFloatStr1(model.final_price), for: .normal)
            
            goodImage.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
    }
    
}
