//
//  LNPartnerEquityCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNPartnerEquityCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskNum: UILabel!
    @IBOutlet weak var taskDetail: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model = LNTaskModel() {
        didSet {
            taskNum.text = "￥"+model.credit
            taskName.text = model.title
            taskDetail.text = model.describe
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
