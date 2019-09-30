//
//  SZYShareGoodsModel.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/9.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYShareGoodsModel: NSObject {
    
    var final_price = String()
    var coupon_price = String()
    var commission_rate = String()
    var short_type = String()
    
    var start_time = String()
    var end_time = String()
    var title = String()
    var pic_url = String()
    
    var item_id = String()
    var price = String()
    var type = String()
    var images = [String]()
    
    var seller_id = String()
    var shop_title = String()
    var volume = String()
    var coupon_url = String()
    
    var favourite = String()
    var content = String()
    var comment = String()
    var kouling = String()
    
    var url = String()
    
    class func setupValues(json: JSON) -> SZYShareGoodsModel {
        let model = SZYShareGoodsModel()
        
        model.final_price = json["final_price"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.commission_rate = json["commission_rate"].stringValue
        model.short_type = json["short_type"].stringValue
        
        model.start_time = json["start_time"].stringValue
        model.end_time = json["end_time"].stringValue
        model.title = json["title"].stringValue
        model.pic_url = json["pic_url"].stringValue
        
        model.item_id = json["item_id"].stringValue
        model.price = json["price"].stringValue
        model.type = json["type"].stringValue
        model.images = SZYShareGoods_imagesModel.getImages(json: json["images"])
        
        model.seller_id = json["seller_id"].stringValue
        model.shop_title = json["shop_title"].stringValue
        model.volume = json["volume"].stringValue
        model.coupon_url = json["coupon_url"].stringValue
        
        model.favourite = json["favourite"].stringValue
        model.content = json["content"].stringValue
        model.comment = json["comment"].stringValue
        model.kouling = json["kouling"].stringValue
        
        model.url = json["url"].stringValue
        
        return model
    }
    
}
class SZYShareGoods_imagesModel: NSObject {
    class func getImages(json: JSON) -> Array<String> {
        
        let photoArr = json.arrayValue
        var images = [String]()
        
        for index in 0..<photoArr.count {
            var str = photoArr[index].stringValue
            if !str.contains("http") {
                str = "https:"+str
            }
            images.append(str)
        }
        return images
    }
}
