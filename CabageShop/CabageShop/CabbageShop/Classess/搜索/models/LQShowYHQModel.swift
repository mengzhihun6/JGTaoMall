//
//  LQShowYHQModel.swift
//  LingQuan
//
//  Created by 付耀辉 on 2018/6/3.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LQShowYHQModel: NSObject {
    var introduce = String()
    var isTmall = String()
    var activityId = String()
    var volume = String()
    var type = String()
    var price = String()
    var itemId = String()
    var shortTitle = String()
    var cat = String()
    var updatedAt = String()
    var couponPrice = Int()
    var createdAt = String()
    var title = String()
    var endTime = String()
    var finalPrice = String()
    var startTime = String()
    var commissionRate = String()
    var picUrl = String()
    var shareUrl = String()

    
    class func setupValues(json:JSON) -> LQShowYHQModel {
        let model = LQShowYHQModel()
        model.introduce = json["introduce"].stringValue
        model.isTmall = json["isTmall"].stringValue
        model.activityId = json["activityId"].stringValue
        model.volume = json["volume"].stringValue
        model.type = json["type"].stringValue
        model.price = json["price"].stringValue
        model.itemId = json["itemId"].stringValue
        model.shortTitle = json["shortTitle"].stringValue
        model.cat = json["cat"].stringValue
        model.updatedAt = json["updatedAt"].stringValue
        model.couponPrice = json["couponPrice"].intValue
        model.createdAt = json["createdAt"].stringValue
        model.title = json["title"].stringValue
        model.endTime = json["endTime"].stringValue
        model.finalPrice = json["finalPrice"].stringValue
        model.startTime = json["startTime"].stringValue
        model.commissionRate = json["commissionRate"].stringValue
        model.picUrl = json["picUrl"].stringValue
        model.shareUrl = json["shareUrl"].stringValue
        return model
    }

}
