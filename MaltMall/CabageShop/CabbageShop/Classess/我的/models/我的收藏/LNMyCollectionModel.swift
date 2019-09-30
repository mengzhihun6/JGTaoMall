//
//  LNMyCollectionModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/5.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNMyCollectionModel: NSObject {
    var id = String()
    var member_id = String()
    var pic_url = String()
    var title = String()
    var item_id = String()
    var volume = String()
    var price = String()
    var coupon_price = String()
    var final_price = String()
    var type = String()
    var created_at = String()
    var updated_at = String()

    class func setupValues(json:JSON) -> LNMyCollectionModel {
        let model = LNMyCollectionModel()
        
        model.id = json["id"].stringValue
        model.member_id = json["member_id"].stringValue
        model.pic_url = json["pic_url"].stringValue
        model.title = json["title"].stringValue
        model.item_id = json["item_id"].stringValue
        model.volume = json["volume"].stringValue
        model.price = json["price"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.final_price = json["final_price"].stringValue
        model.type = json["type"].stringValue
        model.created_at = json["created_at"].stringValue
        model.updated_at = json["updated_at"].stringValue
        return model
    }

}
