//
//  SZYGoogdObject.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/6.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYGoogdObject: NSObject {
    
    var category_id                     = String()
    var category_name                   = String()
    var commission_rate                 = String()
    var commission_type                 = String()
    
    var coupon_amount                   = String()
    var coupon_end_time                 = String()
    var coupon_id                       = String()
    var coupon_info                     = String()
    
    var coupon_remain_count             = String()
    var coupon_share_url                = String() //领券地址
    var coupon_start_fee                = String()
    var coupon_start_time               = String()
    
    var coupon_total_count              = String()
    var include_dxjh                    = String()
    var include_mkt                     = String()
    var info_dxjh                       = String()
    
    var item_description                = String()
    var item_id                         = String()
    var item_url                        = String()
    var level_one_category_id           = String()
    
    var level_one_category_name         = String()
    var nick                            = String()
    var num_iid                         = String()
    var pict_url                        = String()
    
    var provcity                        = String()
    var reserve_price                   = String()
    var seller_id                       = String()
    var shop_dsr                        = String()
    
    var shop_title                      = String()
    var short_title                     = String()
    var small_images                    = [String]() // 字典 存储图片数组
    var title                           = String()
    
    var tk_total_commi                  = String()
    var tk_total_sales                  = String()
    var url                             = String() //淘宝链接地址(淘宝商品)
    var user_type                       = String()
    
    var volume                          = String()
    var white_image                     = String()
    var x_id                            = String()
    var zk_final_price                  = String()
    
    var final_price                     = String()
    var coupon_price                    = String()
    var favourite                       = String()
    
    class func setupValues(json: JSON) -> SZYGoogdObject {
        let model = SZYGoogdObject()
        
        model.category_id                       = json["category_id"].stringValue
        model.category_name                     = json["category_name"].stringValue
        model.commission_rate                   = json["commission_rate"].stringValue
        model.commission_type                   = json["commission_type"].stringValue
        
        model.coupon_amount                     = json["coupon_amount"].stringValue
        model.coupon_end_time                   = json["coupon_end_time"].stringValue
        model.coupon_id                         = json["coupon_id"].stringValue
        model.coupon_info                       = json["coupon_info"].stringValue
        
        model.coupon_remain_count             = json["coupon_remain_count"].stringValue
        model.coupon_share_url                 = json["coupon_share_url"].stringValue
        model.coupon_start_fee                 = json["coupon_start_fee"].stringValue
        model.coupon_start_time                = json["coupon_start_time"].stringValue
        
        model.coupon_total_count    = json["coupon_total_count"].stringValue
        model.include_dxjh           = json["include_dxjh"].stringValue
        model.include_mkt            = json["include_mkt"].stringValue
        model.info_dxjh              = json["info_dxjh"].stringValue
        
        model.item_description       = json["item_description"].stringValue
        model.item_id                  = json["item_id"].stringValue
        model.item_url                 = json["item_url"].stringValue
        model.level_one_category_id = json["level_one_category_id"].stringValue
        
        model.level_one_category_name   = json["level_one_category_name"].stringValue
        model.nick                          = json["nick"].stringValue
        model.num_iid                       = json["num_iid"].stringValue
        model.pict_url                      = json["pict_url"].stringValue
        
        model.provcity           = json["provcity"].stringValue
        model.reserve_price     = json["reserve_price"].stringValue
        model.seller_id          = json["seller_id"].stringValue
        model.shop_dsr           = json["shop_dsr"].stringValue
        
        model.shop_title    = json["shop_title"].stringValue
        model.short_title   = json["short_title"].stringValue
        model.small_images  = SZYSmall_imagesModel.getImages(json: json["small_images"])
        model.title           = json["title"].stringValue
        
        model.tk_total_commi    = json["tk_total_commi"].stringValue
        model.tk_total_sales    = json["tk_total_sales"].stringValue
        model.url                 = json["url"].stringValue
        model.user_type          = json["user_type"].stringValue
        
        model.volume              = json["volume"].stringValue
        model.white_image        = json["white_image"].stringValue
        model.x_id                = json["x_id"].stringValue
        model.zk_final_price    = json["zk_final_price"].stringValue
        
        model.final_price        = json["final_price"].stringValue
        model.coupon_price       = json["coupon_price"].stringValue
        model.favourite          = json["favourite"].stringValue
        
        return model
    }
    
}
class SZYSmall_imagesModel: NSObject {
    class func getImages(json: JSON) -> Array<String> {
        
        let photoArr = json["string"].arrayValue
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
