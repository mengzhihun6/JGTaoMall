//
//  LNMyTotalEarningCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMyTotalEarningCell: UITableViewCell {

    
    @IBOutlet weak var today_order_count: UILabel!
    
    @IBOutlet weak var yesterday_order_count: UILabel!
    
    @IBOutlet weak var month_order_count: UILabel!
    @IBOutlet weak var total_order_count: UILabel!
    
    @IBOutlet weak var month_order_money: UILabel!
    @IBOutlet weak var total_order_money: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = kBGColor()
    }
    
    
    func setValues(today_orders:String,yesterday_orders:String,month_orders:String,total_orders:String,month_order_moneys:String,total_order_moneys:String) {
        today_order_count.text = today_orders + "单"
        yesterday_order_count.text = yesterday_orders + "单"
        
        month_order_count.text = month_orders + "单"
        total_order_count.text = total_orders + "单"
        
        month_order_money.text = "￥"+month_order_moneys
        total_order_money.text = "￥"+total_order_moneys
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
