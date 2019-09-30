//
//  LNLayout1SubCellCollectionViewCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNLayout1SubCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var goodImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        goodImage.cornerRadius = 4
        goodImage.clipsToBounds = true
    }

    func setImageValue(imageUrl:String) {
        goodImage.sd_setImage(with: OCTools.getEfficientAddress(imageUrl), placeholderImage: UIImage.init(named: "goodImage_1"))
    }
    
    
}
