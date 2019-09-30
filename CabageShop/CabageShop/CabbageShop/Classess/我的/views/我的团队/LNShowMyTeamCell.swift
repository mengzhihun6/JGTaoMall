//
//  LNShowMyTeamCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNShowMyTeamCell: UITableViewCell {

    
    @IBOutlet weak var user_icon: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var phone_number: UILabel!
    
    @IBOutlet weak var the_date: UILabel!
    
    @IBOutlet weak var down_count: UILabel!
    
    @IBOutlet weak var vipLevel: UIButton!
    
    @IBOutlet weak var vipMark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        user_icon.cornerRadius = user_icon.height/2
        user_icon.clipsToBounds = true
        
        down_count.isHidden = true
        down_count.textColor = kMainColor1()
        
        vipLevel.cornerRadius = vipLevel.height/2
        vipLevel.clipsToBounds = true
        vipLevel.borderColor = kGaryColor(num: 230)
        vipLevel.borderWidth = 1
        vipLevel.setTitleColor(kGaryColor(num: 139), for: .normal)
        vipLevel.layoutButton(with: .left, imageTitleSpace: 4)
        
        user_name.textColor = kGaryColor(num: 80)
        vipMark.cornerRadius = vipMark.height/2
        vipMark.clipsToBounds = true
    }

    var model = LNMyFansModel() {
        didSet {
            user_icon.sd_setImage(with: OCTools.getEfficientAddress(model.headimgurl), placeholderImage: UIImage(named: "goodImage_1"))
            user_name.text = model.nickname
            
            if model.phone.count > 9 {
                let startIndex = model.phone.index(model.phone.startIndex, offsetBy: 3)
                let endIndex = model.phone.index(model.phone.endIndex, offsetBy: -5)
                phone_number.text = model.phone.replacingCharacters(in: startIndex...endIndex, with: "****")
            } else {
                phone_number.text = model.phone
            }
            the_date.text = model.created_at
            
            vipLevel.setTitle("v"+model.level_id+"会员", for: .normal)
            if model.freinds_count > 0{
                down_count.isHidden = false
                down_count.text = "推荐 "+String(model.freinds_count)  + " 人"
            }else{
                down_count.isHidden = true
            }
            
            vipMark.text = "v"+model.level_id+"会员"            
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
