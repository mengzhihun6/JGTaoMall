//
//  SZYLQOrderListCellTB.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/20.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYLQOrderListCellTB: UITableViewCell {

    @IBOutlet weak var icon_imageView: UIImageView!
    @IBOutlet weak var bg_imageView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var fuzhiBun: UIButton!
    @IBOutlet weak var orderBun: UIButton!
    @IBOutlet weak var yongjinLab: UILabel!
    @IBOutlet weak var jiesuan_label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var dingdanrenBun: UIButton!
    var setModel : LNOrderModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        orderBun.clipsToBounds = true
//        orderBun.cornerRadius = orderBun.height / 2.0
        
        dingdanrenBun.clipsToBounds = true
        dingdanrenBun.cornerRadius = dingdanrenBun.height / 2.0
    }
    func setupValues(model:LNOrderModel) {
        setModel = model
        icon_imageView.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        
        jiesuan_label.isHidden = true
        
        if model.status == "1"{
            dingdanrenBun.setTitle("   订单付款   ", for: .normal)
            dingdanrenBun.backgroundColor = kSetRGBColor(r: 60, g: 120, b: 220)
        } else if model.status == "2" || model.status == "4" {
            dingdanrenBun.setTitle("   订单结算   ", for: .normal)
            dingdanrenBun.backgroundColor = kSetRGBColor(r: 240, g:  113, b: 28)
            
            jiesuan_label.isHidden = false
            jiesuan_label.text = "结算\(model.complete_at)"
        } else if model.status == "3" || model.status == "5" {
            dingdanrenBun.setTitle("   订单失效   ", for: .normal)
            dingdanrenBun.backgroundColor = kSetRGBColor(r: 157, g:  157, b: 157)
        }
        
        if model.type == "1" {
            bg_imageView.image = UIImage.init(named: "miaosha_mark")
        } else /*if model.type == "2"*/ {
            bg_imageView.image = UIImage.init(named: "tianmao_icon")
        }
        
        titleLab.text = model.title
        orderNumberLabel.text = "订单号："+model.trade_parent_id
        createTimeLabel.text = "创建于"+model.created_at
        yongjinLab.text = OCTools().getStrWithFloatStr2(model.commission_amount)
        
        priceLabel.text = "¥"+OCTools().getStrWithFloatStr2(model.final_price)
        if model.user.nickname == "" {
//            dingdanrenBun.isHidden = true
            orderBun.isHidden = true
        } else {
//            dingdanrenBun.isHidden = false
//            dingdanrenBun.setTitle("订单归属人: " + model.user.nickname, for: .normal)
            orderBun.isHidden = false
            orderBun.setTitle("订单归属人: " + model.user.nickname, for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func copyButtonClick(_ sender: UIButton) {
        let paste = UIPasteboard.general
        paste.string = setModel!.trade_parent_id
        setToast(str: "复制成功")
    }
}
