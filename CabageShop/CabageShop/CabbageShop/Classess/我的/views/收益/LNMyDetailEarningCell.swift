//
//  LNMyDetailEarningCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMyDetailEarningCell: UITableViewCell {

    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var order_count: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    
    @IBOutlet weak var order_money: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = kBGColor()

    }

    func setUpValuse(index:Int,ordercount:String,orderaomot:String) {
        
        order_count.text = ordercount+"单"
        order_money.text = "￥"+orderaomot

        switch index-1 {
        case 1:
            title_label.text = "今日数据统计"
            titleLabel2.text = "今日订单数量"
            titleLabel3.text = "今日收入金额"
        case 2:
            title_label.text = "本月数据统计"
            titleLabel2.text = "本月订单数量"
            titleLabel3.text = "本月收入金额"
        case 3:
            title_label.text = "上月数据统计"
            titleLabel2.text = "上月订单数量"
            titleLabel3.text = "上月收入金额"
        default:
            break
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
