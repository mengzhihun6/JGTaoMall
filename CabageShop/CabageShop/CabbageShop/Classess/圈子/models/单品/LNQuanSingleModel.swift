//
//  LNQuanSingleModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/6.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNQuanSingleModel: NSObject {
    var id = String()
    var itemid = String()
    var title = String()
    var pic_url : Array<String>!
    var content = String()
    var price = String()
    var final_price = String()
    var coupon_price = String()
    var commission_rate = String()
    var shares = String()
    var comment1 = String()
    var comment2 = String()
    var show_at = String()
    var type = String()
    var finalCommission = String()

    class func setupValues(json:JSON) -> LNQuanSingleModel {
        let model = LNQuanSingleModel()
        model.id = json["id"].stringValue
        model.itemid = json["itemid"].stringValue
        model.title = json["title"].stringValue
        model.pic_url = LQImagesToolModel.getImages(json: json["pic_url"])
        model.content = json["content"].stringValue
        model.price = json["price"].stringValue
        model.final_price = json["final_price"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.commission_rate = json["commission_rate"].stringValue
        model.shares = json["shares"].stringValue
        model.comment1 = json["comment1"].stringValue
        model.comment2 = json["comment2"].stringValue
        model.show_at = json["show_at"].stringValue
        model.type = json["type"].stringValue
        model.finalCommission = json["finalCommission"].stringValue
        return model
    }

}
