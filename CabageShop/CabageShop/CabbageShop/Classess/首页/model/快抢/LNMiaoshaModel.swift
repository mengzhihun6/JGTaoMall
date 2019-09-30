//
//  LNMiaoshaModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/19.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNMiaoshaModel: NSObject {
    var id = String()
    var title = String()
    var itemid = String()
    var short_title = String()
    var introduce = String()
    var final_price = String()
    var price = String()
    var sales = String()
    var today_sale = String()
    var pic_url = String()
    var gain_price = String()
    var coupon_price = String()
    var finalCommission = String()
    

    class func setupValues(json:JSON) -> LNMiaoshaModel {
        let model = LNMiaoshaModel()
        
        model.id = json["id"].stringValue
        model.title = json["title"].stringValue
        model.itemid = json["itemid"].stringValue
        model.short_title = json["short_title"].stringValue
        model.introduce = json["introduce"].stringValue
        model.final_price = json["final_price"].stringValue
        model.price = json["price"].stringValue
        model.sales = json["sales"].stringValue
        model.today_sale = json["today_sale"].stringValue
        model.pic_url = json["pic_url"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.finalCommission = json["finalCommission"].stringValue
        return model
    }

}
