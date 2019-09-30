//
//  LNSuperSectionHaderCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/13.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNSuperSectionHaderCell: UICollectionViewCell {
    @IBOutlet weak var headLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(model:LNSuperMainModel) {
        headLabel.text = model.title
    }

}
