//
//  LNYHQDetailModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/5.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNYHQDetailModel: NSObject {
    var commossion_rate = String()
    var cat_leaf_name = String()
    var coupon_link_url = String()
    var coupon_link_shorturl = String()
    var coupon_link_mobile_url = String()
    var coupon_link_mobile_short_url = String()
    var coupon_price = String()
    var coupon_remain_count = String()
    var coupon_total_count = String()
    var final_price = String()
    var introduce = String()
    var is_favourites = String()
    var kouling = String()
    var pic_url = String()
    var price = String()
    var title = String()
    var user_type = String()
    var item_id = String()
    var small_images = Array<String>()
    var volume = String()
    var coupon_end_time = String()
    var coupon_start_time = String()
    var finalCommission = String()
    var favourite = String()
    var images = String()
    var imagesArr = Array<String>()
    var data : JSON?

    class func setupValues(json:JSON) -> LNYHQDetailModel {
        let model = LNYHQDetailModel()
        model.commossion_rate = json["commossion_rate"].stringValue
        model.coupon_link_url = json["coupon_link"]["url"].stringValue
        model.coupon_link_shorturl = json["coupon_link"]["short_url"].stringValue
        model.coupon_link_mobile_url = json["coupon_link"]["mobile_url"].stringValue
        model.coupon_link_mobile_short_url = json["coupon_link"]["mobile_short_url"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.coupon_remain_count = json["coupon_remain_count"].stringValue
        model.coupon_total_count = json["coupon_total_count"].stringValue
        model.final_price = json["final_price"].stringValue
        model.introduce = json["introduce"].stringValue
        model.is_favourites = json["is_favourites"].stringValue
        model.kouling = json["kouling"].stringValue
        model.pic_url = json["pic_url"].stringValue
        model.price = json["price"].stringValue
        model.title = json["title"].stringValue
        model.user_type = json["user_type"].stringValue
        model.item_id = json["item_id"].stringValue
        model.small_images = LQImagesToolModel.getImages(json: json["small_images"])
        model.imagesArr = LQImagesToolModel.getImages(json: json["images"])
        model.volume = json["volume"].stringValue
        model.coupon_end_time = json["coupon_end_time"].stringValue
        model.coupon_start_time = json["coupon_start_time"].stringValue
        model.finalCommission = json["finalCommission"].stringValue
        model.favourite = json["favourite"].stringValue
        model.images = json["images"].stringValue

        return model
    }

}

class LNCouponModel: NSObject {
    var category_id = String()
    var coupon_click_url = String()
    var coupon_end_time = String()
    var coupon_info = String()
    var coupon_remain_count = String()
    var coupon_start_time = String()
    var coupon_total_count = String()
    var coupon_type = String()
    var item_id = String()
    var item_url = String()
    var max_commission_rate = String()

    class func setupValues(json:JSON) -> LNCouponModel {
        let model = LNCouponModel()
        
        model.category_id = json["category_id"].stringValue
        model.coupon_click_url = json["coupon_click_url"].stringValue
        model.coupon_end_time = json["coupon_end_time"].stringValue
        model.coupon_info = json["coupon_info"].stringValue
        model.coupon_remain_count = json["coupon_remain_count"].stringValue
        model.coupon_start_time = json["coupon_start_time"].stringValue
        model.coupon_total_count = json["coupon_total_count"].stringValue
        model.coupon_type = json["coupon_type"].stringValue
        model.item_id = json["item_id"].stringValue
        model.max_commission_rate = json["max_commission_rate"].stringValue
        model.item_url = json["item_url"].stringValue
        return model
    }
    
}


class LQImagesToolModel: NSObject {
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

