//
//  LNShowDealLogCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit




class LNShowDealLogCell: UITableViewCell {

    @IBOutlet weak var thType: UILabel!
    
    @IBOutlet weak var blance: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model = LNCreditLogModel() {
        didSet {
            thType.text = model.remark
            dateLabel.text = model.created_at
            blance.text = model.current_credit
            dateLabel.text = model.created_at
            if model.type == "1" {
                amount.text = "-"+model.credit
                amount.textColor = kMainColor1()
            }else{
                amount.text = "+"+model.credit
                amount.textColor = kSetRGBColor(r: 9, g: 180, b: 9)
            }
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
