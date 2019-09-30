//
//  LNShowNoticeCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNShowNoticeCell: UITableViewCell {

    @IBOutlet weak var notice_title: UILabel!
    
    @IBOutlet weak var notice_time: UILabel!
    
    @IBOutlet weak var notice_content: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var cell_height: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let str = "某猫把双十一光棍节变成了全世界热爱购物事业的人民的狂欢节。某狗就把自家的店庆日搞成了全国性电商大促日。从这方面讲猫狗大战还真是难分输赢。这样的电商盛宴消费者得实惠，商家赚销量，平台涨人气，看似是一团和气、大家受益。然而在这一团和气、锣鼓喧天、鞭炮齐鸣的繁华景象下，总有那么一些商家喜欢玩套路。"
        
        cell_height.constant = 56+KGetLabHeight(labelStr: str, font: UIFont.systemFont(ofSize: 13), width: kSCREEN_WIDTH-8*6)
        
        bgView.clipsToBounds = true
        bgView.cornerRadius = 5
    }

    
    
    public var model : LQMainMessageModel = LQMainMessageModel() {
        didSet {
            
            cell_height.constant = 56+KGetLabHeight(labelStr: model.message, font: UIFont.systemFont(ofSize: 13), width: kSCREEN_WIDTH-8*6)
            notice_title.text = model.title
            notice_content.text = model.message
            notice_time.text = model.createdAt
        }
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
