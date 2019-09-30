//
//  SZYgoodsShareCopyCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/21.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYgoodsShareCopyCell: UITableViewCell {

    @IBOutlet weak var copyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupValuse(model: SZYGoodsShareModel) {
        
        copyLabel.text = "\n    "+model.comment+"\n"
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
