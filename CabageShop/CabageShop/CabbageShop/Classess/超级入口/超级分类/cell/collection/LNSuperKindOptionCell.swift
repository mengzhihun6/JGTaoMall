//
//  LNSuperKindOptionCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/14.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNSuperKindOptionCell: UICollectionViewCell {

    @IBOutlet weak var optionImage: UIImageView!
    
    @IBOutlet weak var optionTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setValues(model:LNSuperChildrenModel) {
        optionTitle.text = model.name
        optionImage.sd_setImage(with: OCTools.getEfficientAddress(model.logo), placeholderImage: UIImage.init(named: "goodImage_1"))
    }

}
