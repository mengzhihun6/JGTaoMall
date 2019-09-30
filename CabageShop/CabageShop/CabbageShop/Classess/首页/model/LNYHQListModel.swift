//
//  LNYHQListModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/5.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNYHQListModel: NSObject {
    var id = String()
    var title = String()
    var cat = String()
    var shop_type = String()
    var pic_url = String()
    var item_id = String()
    var item_url = String()
    var volume = String()
    var price = String()
    var final_price = String()
    var coupon_price = String()
    var coupon_link = String()
    var activity_id = String()
    var commission_rate = String()
    var introduce = String()
    var total_num = String()
    var end_time = String()
    var receive_num = String()
    var tag = String()
    var is_recommend = String()
    var sort = String()
    var videoid = String()
    var activity_type = String()
    var type = String()
    var status = String()
    var gain_price = String()
    var finalCommission = String()
    var start_time = String()

    class func setupValues(json:JSON) -> LNYHQListModel {
        let model = LNYHQListModel()
        
        model.id = json["id"].stringValue
        model.title = json["title"].stringValue
        model.cat = json["cat"].stringValue
        model.shop_type = json["shop_type"].stringValue
        model.pic_url = json["pic_url"].stringValue
        model.item_id = json["item_id"].stringValue
        model.item_url = json["item_url"].stringValue
        model.volume = json["volume"].stringValue
        model.price = json["price"].stringValue
        model.final_price = json["final_price"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.coupon_link = json["coupon_link"].stringValue
        model.activity_id = json["activity_id"].stringValue
        model.commission_rate = json["commission_rate"].stringValue
        model.introduce = json["end_tiintroduceme"].stringValue
        model.total_num = json["total_num"].stringValue
        model.receive_num = json["receive_num"].stringValue
        model.tag = json["tag"].stringValue
        model.is_recommend = json["is_recommend"].stringValue
        model.sort = json["sort"].stringValue
        model.videoid = json["videoid"].stringValue
        model.activity_type = json["activity_type"].stringValue
        model.type = json["type"].stringValue
        model.status = json["status"].stringValue
        model.gain_price = json["finalCommission"].stringValue
        model.start_time = json["start_time"].stringValue
        model.end_time = json["end_time"].stringValue
        model.finalCommission = json["finalCommission"].stringValue
        return model
    }
}
