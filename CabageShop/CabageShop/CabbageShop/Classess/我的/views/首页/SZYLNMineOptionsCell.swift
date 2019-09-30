//
//  SZYLNMineOptionsCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/15.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYLNMineOptionsCell: UITableViewCell {

    @IBOutlet weak var bg_View: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var hengxianView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValuesWith(image:String, title:String, type:String) {
        icon.image = UIImage.init(named: image)
        nameTextLabel.text = title
        
//        if type == "0" {
//            let maskPath1 = UIBezierPath.init(roundedRect: bg_View.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topRight.rawValue)|UInt8(UIRectCorner.topLeft.rawValue))), cornerRadii: CGSize(width: 5, height: 5))
//            let maskLayer1 = CAShapeLayer.init()
//            maskLayer1.frame = bg_View.bounds
//            maskLayer1.path = maskPath1.cgPath
//            bg_View.layer.mask = maskLayer1
//        } else if type == "1" {
//            let maskPath1 = UIBezierPath.init(roundedRect: bg_View.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.bottomLeft.rawValue)|UInt8(UIRectCorner.bottomRight.rawValue))), cornerRadii: CGSize(width: 5, height: 5))
//            let maskLayer1 = CAShapeLayer.init()
//            maskLayer1.frame = bg_View.bounds
//            maskLayer1.path = maskPath1.cgPath
//            bg_View.layer.mask = maskLayer1
//        } else {
//            let maskPath1 = UIBezierPath.init(roundedRect: bg_View.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topRight.rawValue)|UInt8(UIRectCorner.topLeft.rawValue) | UInt8(UIRectCorner.bottomLeft.rawValue) | UInt8(UIRectCorner.bottomRight.rawValue))), cornerRadii: CGSize(width: 0, height: 0))
//            let maskLayer1 = CAShapeLayer.init()
//            maskLayer1.frame = bg_View.bounds
//            maskLayer1.path = maskPath1.cgPath
//            bg_View.layer.mask = maskLayer1
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
