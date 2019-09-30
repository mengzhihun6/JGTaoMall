//
//  LNSuperKindListCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/14.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNSuperKindListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectMark: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = kGaryColor(num: 69)
        selectMark.backgroundColor = kMainColor1()
    }
    
    func setValue(title:String,isSelect:Bool) {
        if isSelect {
            titleLabel.textColor = kMainColor1()
            self.backgroundColor = UIColor.white
        }else{
            titleLabel.textColor = kGaryColor(num: 69)
            self.backgroundColor = kGaryColor(num: 245)
        }
        selectMark.isHidden = !isSelect
        titleLabel.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
