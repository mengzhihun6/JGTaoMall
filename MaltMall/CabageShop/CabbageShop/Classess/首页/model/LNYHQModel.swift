//
//  LNYHQModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/5.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNYHQModel: NSObject {
    var id = String()
    var pic_url = String()
    var title = String()
    var item_id = String()
    var volume = String()
    var price = String()
    var coupon_price = String()
    var coupon_link = String()
    var final_price = String()
    var type = String()
    var cat = String()
    var activity_id = String()
    var commission_rate = String()
    var introduce = String()
    var start_time = String()
    var end_time = String()
    var gain_price = String()
    var shop_type = String()
    var finalCommission = String()
    var isSearching = false

    class func setupValues(json:JSON) -> LNYHQModel {
        let model = LNYHQModel()
        
        model.id = json["id"].stringValue
        model.pic_url = json["pic_url"].stringValue
        model.shop_type = json["shop_type"].stringValue
        model.title = json["title"].stringValue
        model.item_id = json["item_id"].stringValue
        model.volume = json["volume"].stringValue
        model.price = json["price"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.coupon_link = json["coupon_link"].stringValue
        model.final_price = json["final_price"].stringValue
        model.type = json["type"].stringValue
        model.cat = json["cat"].stringValue
        model.activity_id = json["activity_id"].stringValue
        model.commission_rate = json["commission_rate"].stringValue
        model.introduce = json["introduce"].stringValue
        model.start_time = json["start_time"].stringValue
        model.end_time = json["end_time"].stringValue
        model.gain_price = json["finalCommission"].stringValue
        model.finalCommission = json["finalCommission"].stringValue
        return model
    }
}
