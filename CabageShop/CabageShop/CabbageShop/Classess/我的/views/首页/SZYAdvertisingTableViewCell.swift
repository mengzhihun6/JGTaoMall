//
//  SZYAdvertisingTableViewCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/15.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYAdvertisingTableViewCell: UITableViewCell {

    @IBOutlet weak var BG_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BG_icon.clipsToBounds = true
        BG_icon.cornerRadius = 5
    }
    
    func setImageUrl(urlStr:String) {
        BG_icon.sd_setImage(with: OCTools.getEfficientAddress(urlStr), placeholderImage: UIImage.init(named: "白菜淘_01"))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
