//
//  LNOtherSelectCell.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNOtherSelectCell: UITableViewCell {

    @IBOutlet weak var theTitle: UILabel!
    
    @IBOutlet weak var selectMark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setValues(title:String,isSelect:Bool) {
        theTitle.text = title
        if isSelect {
            theTitle.textColor = kGaryColor(num: 42)
        }else{
            theTitle.textColor = kGaryColor(num: 149)
        }
        selectMark.isHidden = !isSelect
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
