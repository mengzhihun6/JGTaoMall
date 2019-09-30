//
//  LNNewUserTeachCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNNewUserTeachCell: UITableViewCell {

    @IBOutlet weak var teach_image: UIImageView!
    
    @IBOutlet weak var teach_title: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.cornerRadius = 8
        bgView.clipsToBounds = true
        
//        self.backgroundColor = kMainColor1()
    }
    
    func setUpValues(model:LNArticlesModel) {
        teach_image.sd_setImage(with: OCTools.getEfficientAddress(model.thumb), placeholderImage: UIImage.init(named: "goodImage_1"))
        teach_title.text = model.title
    }
        

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
