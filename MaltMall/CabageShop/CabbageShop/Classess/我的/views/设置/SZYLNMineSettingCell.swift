//
//  SZYLNMineSettingCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/15.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYLNMineSettingCell: UITableViewCell {

    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var user_icon: UIImageView!
    
    @IBOutlet weak var vipIcon: UIImageView!
    
    @IBOutlet weak var nickLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        user_icon.clipsToBounds = true
        user_icon.cornerRadius = user_icon.height / 2.0
        
    }
    func setUpValues(image:String, text:String) {
        bg_view.backgroundColor = UIColor.black
        user_icon.sd_setImage(with: OCTools.getEfficientAddress(image), placeholderImage: UIImage.init(named: "goodImage_1"))
        nickLable.text = text;
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
