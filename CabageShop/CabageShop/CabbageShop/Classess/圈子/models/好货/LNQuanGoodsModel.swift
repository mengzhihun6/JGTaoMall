//
//  LNQuanGoodsModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/6.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
class LNQuanGoodsModel: NSObject {
    var id = String()
    var title = String()
    var app_hot_image = String()
    var text = String()
    var shares = String()
    var start_time = String()
    var items = Array<LNQuanGoodsItems>()

    class func setupValues(json:JSON) -> LNQuanGoodsModel {
        let model = LNQuanGoodsModel()
        model.id = json["id"].stringValue
        model.title = json["title"].stringValue
        model.app_hot_image = json["app_hot_image"].stringValue
        model.text = json["text"].stringValue
        model.shares = json["shares"].stringValue
        model.start_time = json["start_time"].stringValue
        model.items = LNQuanGoodsItems.setValue(json: json["items"])
        return model
    }

}

class LNQuanGoodsItems: NSObject {
    var itemid = String()
    var title = String()
    var price = String()
    var pic_url = String()
    var final_price = String()
    var type = String()
    
    class func setValue(json: JSON) -> Array<LNQuanGoodsItems> {
        
        var models = Array<LNQuanGoodsItems>()
        
        let jsonDic = json.dictionaryValue
        
        if jsonDic.keys.count>0 {
            for key in jsonDic.keys {
                
                let model = LNQuanGoodsItems()
                
                model.itemid = jsonDic[key]!["itemid"].stringValue
                model.title = jsonDic[key]!["title"].stringValue
                model.price = jsonDic[key]!["price"].stringValue
                model.final_price = jsonDic[key]!["final_price"].stringValue
                model.pic_url = jsonDic[key]!["pic_url"].stringValue
                model.type = jsonDic[key]!["type"].stringValue
                
                models.append(model)
            }
        }else{
            let jsonArr = json.arrayValue

            for key in 0..<jsonArr.count {
                
                let model = LNQuanGoodsItems()
                
                model.itemid = jsonArr[key]["itemid"].stringValue
                model.title = jsonArr[key]["title"].stringValue
                model.price = jsonArr[key]["price"].stringValue
                model.final_price = jsonArr[key]["final_price"].stringValue
                model.pic_url = jsonArr[key]["pic_url"].stringValue
                model.type = jsonArr[key]["type"].stringValue
                
                models.append(model)
            }
        }
        
        
        return models
    }

}
