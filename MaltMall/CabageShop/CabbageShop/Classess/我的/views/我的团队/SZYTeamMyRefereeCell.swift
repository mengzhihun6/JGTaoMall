//
//  SZYTeamMyRefereeCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/21.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYTeamMyRefereeCell: UITableViewCell {
    
    @IBOutlet weak var icon_imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var lnvite_codeLabel: UILabel!
    @IBOutlet weak var zongrenshuBun: UIButton!
    @IBOutlet weak var zhishuVipBun: UIButton!
    @IBOutlet weak var zongrenshuLabel: UILabel!
    @IBOutlet weak var zhishuVipLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        icon_imageView.clipsToBounds = true
        icon_imageView.cornerRadius = icon_imageView.height / 2.0
        
        zongrenshuBun.layoutButton(with: .left, imageTitleSpace: 5)
        zhishuVipBun.layoutButton(with: .left, imageTitleSpace: 5)
    }
    func setToValues(model: SZYTuanduiModel) {
        icon_imageView.sd_setImage(with: OCTools.getEfficientAddress(model.inviter.headimgurl), placeholderImage: UIImage(named: "goodImage_1"))
        nameLabel.text = model.inviter.nickname
        
        if model.inviter.phone.count > 9 {
            let startIndex = model.inviter.phone.index(model.inviter.phone.startIndex, offsetBy: 3)
            let endIndex = model.inviter.phone.index(model.inviter.phone.endIndex, offsetBy: -5)
            phoneLabel.text = model.inviter.phone.replacingCharacters(in: startIndex...endIndex, with: "****")
        } else {
            phoneLabel.text = model.inviter.phone
        }
        
        if model.inviter.invite_code != "" {
            lnvite_codeLabel.text = model.inviter.invite_code
        } else {
            lnvite_codeLabel.text = model.inviter.tag
        }
        zongrenshuLabel.text = model.groupSum
        zhishuVipLabel.text = model.member
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func fensiBunClick(_ sender: UIButton) {
        let vc = LNTeamDetailViewController()
        vc.inviter_id = ""
        vc.userName = ""
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
