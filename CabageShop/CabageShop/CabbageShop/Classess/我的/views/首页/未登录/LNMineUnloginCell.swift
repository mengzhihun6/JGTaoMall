//
//  LNMineUnloginCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/21.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMineUnloginCell: UITableViewCell {

    @IBOutlet weak var goIcon: UIButton!
    @IBOutlet weak var head_height: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        if kSCREEN_HEIGHT>800 {
            head_height.constant = 176+24
        }

        goIcon.transform = CGAffineTransform.init(rotationAngle: .pi)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
