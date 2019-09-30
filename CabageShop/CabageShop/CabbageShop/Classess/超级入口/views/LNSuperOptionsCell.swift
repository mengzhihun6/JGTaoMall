//
//  LNSuperOptionsCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/13.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNSuperOptionsCell: UICollectionViewCell {

    
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var optionTitle: UILabel!
    @IBOutlet weak var detailTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionImage.clipsToBounds = true
        optionImage.layer.cornerRadius = optionImage.height/2
    }

    func setValues(model:LNSuperDetailModel) {
        optionTitle.text = model.title
        optionImage.sd_setImage(with: OCTools.getEfficientAddress(model.logo), placeholderImage: UIImage.init(named: "goodImage_1"))
        detailTitle.text = model.descrtptionStr1
    }
    

    func setValues2(model:LNSuperChildrenEntranceModel) {
        optionTitle.text = model.title
        optionImage.sd_setImage(with: OCTools.getEfficientAddress(model.logo), placeholderImage: UIImage.init(named: "goodImage_1"))
        detailTitle.text = model.descriptionStr
    }

    func setUpValues3(model: entranceDataDiyModel) {
        
        optionTitle.text = model.name
        optionImage.sd_setImage(with: OCTools.getEfficientAddress(model.imageUrl), placeholderImage: UIImage.init(named: "goodImage_1"))
        detailTitle.text = model.desc
        
    }
}
