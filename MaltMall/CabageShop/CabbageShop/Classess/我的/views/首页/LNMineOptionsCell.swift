//
//  LNMineOptionsCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/21.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMineOptionsCell: UITableViewCell {

    
    @IBOutlet weak var option: UIButton!
    
    @IBOutlet weak var detailLabel: UILabel!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        option.layoutButton(with: .left, imageTitleSpace: 12)
        option.isUserInteractionEnabled = false
    }

    func setValuesWith(image:String, title:String, detail:String) {
        option.setTitle(title, for: .normal)
        option.setImage(UIImage.init(named: image), for: .normal)
        
        if detail.count>0 {
            detailLabel.isHidden = false
            detailLabel.text = detail
        }else{
            detailLabel.isHidden = true
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
