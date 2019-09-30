//
//  SZYLNShowDealLogCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/20.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYLNShowDealLogCell: UITableViewCell {
    @IBOutlet weak var time_Label: UILabel!
    @IBOutlet weak var money_Label: UILabel!
    @IBOutlet weak var payment_Bun: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        payment_Bun.clipsToBounds = true
        payment_Bun.cornerRadius = payment_Bun.height / 2.0
        
    }
    
    func setToValues(model: WithdrawalRecordModel, typeString: String) {
        let result = model.created_at.components(separatedBy:" ")
        time_Label.text = result[0]
        money_Label.text = OCTools().getStrWithFloatStr2(model.money)
        
        if typeString == "1" {
            switch model.status {
            case "1":
                payment_Bun.setTitle("待打款", for: .normal) //审核中
                payment_Bun.backgroundColor = kSetRGBColor(r: 244, g: 87, b: 120)
                break
            case "2":
                payment_Bun.setTitle("被拒绝", for: .normal)
                payment_Bun.backgroundColor = kSetRGBColor(r: 255, g: 206, b: 84)
                break
            case "3":
                payment_Bun.setTitle("已打款", for: .normal) //已完成
                payment_Bun.backgroundColor = kSetRGBColor(r: 125, g: 201, b: 122)
                break
            default:
                break
            }
        } else if typeString == "2" {
            payment_Bun.setTitle("佣金结算", for: .normal) //已完成
            payment_Bun.backgroundColor = kSetRGBColor(r: 125, g: 201, b: 122)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
