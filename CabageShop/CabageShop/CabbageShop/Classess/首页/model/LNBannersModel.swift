//
//  LNBannersModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/5.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNBannersModel: NSObject {
    var id = String()
    var image = String()
    var url = String()
    var sort = String()
    var tag = String()
    var status = String()
    var color = String()

    class func setupValues(json:JSON) -> LNBannersModel {
        let model = LNBannersModel()
        
        model.id = json["id"].stringValue
        model.image = json["image"].stringValue
        model.url = json["url"].stringValue
        model.sort = json["sort"].stringValue
        model.tag = json["tag"].stringValue
        model.status = json["status"].stringValue
        model.color = json["color"].stringValue
        return model
    }

}

class LNMainAdsModel1: NSObject {
    var id = String()
    var sort = String()
    var status = String()
    var thumb = String()
    var title = String()
    var type = String()
    var url = String()
    
    class func setupValues(json:JSON) -> LNMainAdsModel1 {
        let model = LNMainAdsModel1()
        
        model.id = json["id"].stringValue
        model.sort = json["sort"].stringValue
        model.status = json["status"].stringValue
        model.thumb = json["thumb"].stringValue
        model.title = json["title"].stringValue
        model.type = json["type"].stringValue
        model.url = json["url"].stringValue
        return model
    }

}
