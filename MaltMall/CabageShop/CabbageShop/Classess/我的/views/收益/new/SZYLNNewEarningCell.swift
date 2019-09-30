//
//  SZYLNNewEarningCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/20.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYLNNewEarningCell: UITableViewCell {

    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var yugushouruLab: UILabel!
    @IBOutlet weak var dingdanNumLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValues(title: String, yuguStr: String, dindanStr: String) {
        titlelab.text = title
        yugushouruLab.text = yuguStr
        dingdanNumLab.text = dindanStr
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
