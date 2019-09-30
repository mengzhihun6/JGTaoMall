//
//  LQOrderListCellTB.swift
//  LingQuan
//
//  Created by 付耀辉 on 2018/5/16.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LQOrderListCellTB: UITableViewCell {

    @IBOutlet weak var goodImage: UIImageView!
    
    @IBOutlet weak var goodTitle: UILabel!
    @IBOutlet weak var createDate: UILabel!
    
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var profit: UILabel!
    
    @IBOutlet weak var logoLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        copyButton.layer.cornerRadius = 10
        copyButton.layer.borderWidth = 1
        copyButton.layer.borderColor = kGaryColor(num: 122).cgColor
    }

    @IBAction func copyAction(_ sender: UIButton) {
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = orderNum.text
        
        setToast(str: "复制成功")
        label.textColor = kMainColor1()
        profit.textColor = kMainColor1()
    }
    
    func setupValues(model:LNOrderModel,isUneffect:Bool) {
        
        goodImage.sd_setImage(with: OCTools.getEfficientAddress(model.userIcon), placeholderImage: UIImage.init(named: "goodImage_1"))
//
        goodTitle.text = model.title
        createDate.text = model.created_at
//
        orderNum.text = model.ordernum
        
        if model.status == "1"{
            logoLab.text = "已付款"
            logoLab.textColor = UIColor.green
        } else if model.status == "2" {
            logoLab.text = "已结算"
            logoLab.textColor = UIColor.red
        } else if model.status == "3" {
            logoLab.text = "已失效"
            logoLab.textColor = UIColor.gray
        }
        
        if isUneffect {
            profit.isHidden = true
            label.isHidden = true

        }else{
//            profit.isHidden = false
//            label.isHidden = false
            profit.text = "￥"+model.commission_amount
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
