////
////  SZYGoodsInformationModel.swift
////  CabbageShop
////
////  Created by 宋宗宇 on 2019/2/18.
////  Copyright © 2019 付耀辉. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//
//public class SZYGoodsInformationModel: NSObject {
//
//    var commission_rate = String()
//    var coupon_price = String()
//    var coupon_url = String()
//    var finalCommission = String()
//
//    var final_price = String()
//    var images = Array<String>()                                  //array
//    var item_id = String()
//    var pic_url = String()
//
//    var price = String()
//    var seller_id = String()
//    var shop_title = String()
//    var title = String()
//
//    var type = String()
//    var volume = String()
//    var activity_id = String()
//    var activity_type = String()
//
//    var cat = String()
//    var coupon_link = String()
//    var created_at = String()
//    var end_time = String()
//
//    var id = String()
//    var introduce = String()
//    var is_recommend = String()
//    var item_url = String()
//
//    var nick = String()
//    var receive_num = String()
//    var shop_type = String()
//    var sort = String()
//
//    var start_time = String()
//    var status = String()
//    var tag = String()
//    var threshold_coupon = String()
//
//    var total_num = String()
//    var updated_at = String()
//    var videoid = String()
//    var app_id = String()
//
//    var deleted_at = String()
//    var hour_type = String()
//    var itemid = String()
//    var sales = String()
//
//    var short_title = String()
//    var today_sale = String()
//    var video_id = String()
//    var video_url = String()
//
//    var favourite = String()
//    var coupon_start_time = String()
//    var coupon_end_time = String()
//
//    var isBindPhone = String()
//    var isBindInviter = String()
//    var isOauth = String()
//    var oauthUrl = String()
//
//    var short_type = String()
//    var share = shareModel()
//
//    class func setupValues(json:JSON) -> SZYGoodsInformationModel {
//        let model = SZYGoodsInformationModel()
//
//        model.commission_rate = json["commission_rate"].stringValue
//        model.coupon_price = json["coupon_price"].stringValue
//        model.coupon_url = json["coupon_url"].stringValue
//        model.finalCommission = json["finalCommission"].stringValue
//
//        model.final_price = json["final_price"].stringValue
//        model.images = SZYLQImagesToolModel.getImages(json: json["images"])
//        model.item_id = json["item_id"].stringValue
//        model.pic_url = json["pic_url"].stringValue
//
//        model.price = json["price"].stringValue
//        model.seller_id = json["seller_id"].stringValue
//        model.shop_title = json["shop_title"].stringValue
//        model.title = json["title"].stringValue
//
//        model.type = json["type"].stringValue
//        model.volume = json["volume"].stringValue
//        model.activity_id = json["activity_id"].stringValue
//        model.activity_type = json["activity_type"].stringValue
//
//        model.cat = json["cat"].stringValue
//        model.coupon_link = json["coupon_link"].stringValue
//        model.created_at = json["created_at"].stringValue
//        model.end_time = json["end_time"].stringValue
//
//        model.id = json["id"].stringValue
//        model.introduce = json["introduce"].stringValue
//        model.is_recommend = json["is_recommend"].stringValue
//        model.item_url = json["item_url"].stringValue
//
//        model.nick = json["nick"].stringValue
//        model.receive_num = json["receive_num"].stringValue
//        model.shop_type = json["shop_type"].stringValue
//        model.sort = json["sort"].stringValue
//
//        model.start_time = json["start_time"].stringValue
//        model.status = json["status"].stringValue
//        model.tag = json["tag"].stringValue
//        model.threshold_coupon = json["threshold_coupon"].stringValue
//
//        model.total_num = json["total_num"].stringValue
//        model.updated_at = json["updated_at"].stringValue
//        model.videoid = json["videoid"].stringValue
//        model.app_id = json["app_id"].stringValue
//
//        model.deleted_at = json["deleted_at"].stringValue
//        model.hour_type = json["hour_type"].stringValue
//        model.itemid = json["itemid"].stringValue
//        model.sales = json["sales"].stringValue
//
//        model.short_title = json["short_title"].stringValue
//        model.today_sale = json["today_sale"].stringValue
//        model.video_id = json["video_id"].stringValue
//        model.video_url = json["video_url"].stringValue
//
//        model.favourite = json["favourite"].stringValue
//        model.coupon_start_time = json["start_time"].stringValue
//        model.coupon_end_time = json["end_time"].stringValue
//
//        model.isBindPhone = json["isBindPhone"].stringValue
//        model.isBindInviter = json["isBindInviter"].stringValue
//        model.isOauth = json["isOauth"].stringValue
//        model.oauthUrl = json["oauthUrl"].stringValue
//
//        model.short_type = json["short_type"].stringValue
//        model.share = shareModel.setUpValues(json: json["share"])
//
//        return model
//    }
//}
//class SZYLQImagesToolModel: NSObject {
//    class func getImages(json: JSON) -> Array<String> {
//
//        let photoArr = json.arrayValue
//        var images = [String]()
//
//        for index in 0..<photoArr.count {
//            var str = photoArr[index].stringValue
//            if !str.contains("http") {
//                str = "https:"+str
//            }
//            images.append(str)
//        }
//        return images
//    }
//}
//class SZYStoreInformationModel: NSObject {
//    var allItemCount = String()
//    var creditLevel = String()
//    var creditLevelIcon = String()
//    var evaluates = Array<SZYevaluatesModel>()
//
//    var fans = String()
//    var fbt2User = String()
//    var goodRatePercentage = String()
//    var sellerNick = String()
//
//    var sellerType = String()
//    var shopCard = String()
//    var shopIcon = String()
//    var shopId = String()
//
//    var shopName = String()
//    var shopType = String()
//    var shopUrl = String()
//    var showShopLinkIcon = String()
//
//    var simpleShopDOStatus = String()
//    var starts = String()
//    var tagIcon = String()
//    var taoShopUrl = String()
//
//    var userId = String()
//
//    class func setupValues(json:JSON) -> SZYStoreInformationModel {
//        let model = SZYStoreInformationModel()
//
//        model.allItemCount = json["allItemCount"].stringValue
//        model.creditLevel = json["creditLevel"].stringValue
//        model.creditLevelIcon = json["creditLevelIcon"].stringValue
//        model.evaluates = SZYevaluatesModel.setupValues(json: json["evaluates"])
//
//        model.fans = json["fans"].stringValue
//        model.fbt2User = json["fbt2User"].stringValue
//        model.goodRatePercentage = json["goodRatePercentage"].stringValue
//        model.sellerNick = json["sellerNick"].stringValue
//
//        model.sellerType = json["sellerType"].stringValue
//        model.shopCard = json["shopCard"].stringValue
//        model.shopIcon = json["shopIcon"].stringValue
//        model.shopId = json["shopId"].stringValue
//
//        model.shopName = json["shopName"].stringValue
//        model.shopType = json["shopType"].stringValue
//        model.shopUrl = json["shopUrl"].stringValue
//        model.showShopLinkIcon = json["showShopLinkIcon"].stringValue
//
//        model.simpleShopDOStatus = json["simpleShopDOStatus"].stringValue
//        model.starts = json["starts"].stringValue
//        model.tagIcon = json["tagIcon"].stringValue
//        model.taoShopUrl = json["taoShopUrl"].stringValue
//
//        model.userId = json["userId"].stringValue
//
//        return model
//    }
//}
//class SZYevaluatesModel: NSObject {
//    var level = String()
//    var levelBackgroundColor = String()
//    var levelText = String()
//    var levelTextColor = String()
//
//    var score = String()
//    var title = String()
//    var tmallLevelBackgroundColor = String()
//    var tmallLevelTextColor = String()
//
//    var type = String()
//    class func setupValues(json: JSON) -> Array<SZYevaluatesModel> {
//        var models = Array<SZYevaluatesModel>()
//        let jsonArr = json.arrayValue
//
//        for index in 0..<jsonArr.count {
//            let model = SZYevaluatesModel()
//
//            model.level = jsonArr[index]["level"].stringValue
//            model.levelBackgroundColor = jsonArr[index]["levelBackgroundColor"].stringValue
//            model.levelText = jsonArr[index]["levelText"].stringValue
//            model.levelTextColor = jsonArr[index]["levelTextColor"].stringValue
//
//            model.score = jsonArr[index]["score"].stringValue
//            model.title = jsonArr[index]["title"].stringValue
//            model.tmallLevelBackgroundColor = jsonArr[index]["tmallLevelBackgroundColor"].stringValue
//            model.tmallLevelTextColor = jsonArr[index]["tmallLevelTextColor"].stringValue
//
//            model.type = jsonArr[index]["type"].stringValue
//            models.append(model)
//        }
//
//        return models
//    }
//}
//class WebModel: NSObject {
//
//    var good_item_id = String()
//    var userId = String()
//    var webViewHeight = CFloat()
//    var urlStr = String()
//
//
//}
//class shareModel: NSObject {
//
//    var comment = String()
//    var content = String()
//    var kouling = String()
//    var url = String()
//
//
//    class func setUpValues(json: JSON) -> shareModel {
//        let model = shareModel()
//
//        model.comment = json["comment"].stringValue
//        model.content = json["content"].stringValue
//        model.kouling = json["kouling"].stringValue
//        model.url = json["url"].stringValue
//
//        return model
//    }
//
//}


import UIKit
import SwiftyJSON

public class SZYGoodsInformationModel: NSObject {
    
    var commission_rate = String()
    var coupon_price = String()
    var coupon_url = String()
    var finalCommission = String()
    
    var final_price = String()
    var images = Array<String>()                                  //array
    var images_images = Array<String>()
    
    var is_gold = String()
    
    var item_id = String()
    var pic_url = String()
    
    var price = String()
    var seller_id = String()
    var shop_title = String()
    var title = String()
    
    var type = String()
    var volume = String()
    var activity_id = String()
    var activity_type = String()
    
    var cat = String()
    var coupon_link = JD_Coupon_linkModel()
    var created_at = String()
    var end_time = String()
    
    var id = String()
    var introduce = String()
    var is_recommend = String()
    var item_url = String()
    
    var thumb = String()
    var type_id = String()
    var nick = String()
    var receive_num = String()
    var shop_type = String()
    var sort = String()
    
    var start_time = String()
    var status = String()
    var tag = String()
    var threshold_coupon = String()
    
    var total_num = String()
    var updated_at = String()
    var videoid = String()
    var app_id = String()
    
    var deleted_at = String()
    var hour_type = String()
    var itemid = String()
    var sales = String()
    
    var short_title = String()
    var today_sale = String()
    var video_id = String()
    var video_url = String()
    
    var favourite = String()
    var coupon_start_time = String()
    var coupon_end_time = String()
    
    var isBindPhone = String()
    var isBindInviter = String()
    var isOauth = String()
    var oauthUrl = String()
    
    var short_type = String()
    var share = shareModel()
    
    class func setupValues(json:JSON) -> SZYGoodsInformationModel {
        let model = SZYGoodsInformationModel()
        
        model.commission_rate = json["commission_rate"].stringValue
        model.coupon_price = json["coupon_price"].stringValue
        model.coupon_url = json["coupon_url"].stringValue
        model.finalCommission = json["finalCommission"].stringValue
        
        model.final_price = json["final_price"].stringValue
        model.images = SZYLQImagesToolModel.getImages(json: json["images"])
        model.images_images = SZYLQImagesToolModel.getImages(json: json["images_images"])
        model.is_gold = json["is_gold"].stringValue
        model.item_id = json["item_id"].stringValue
        model.pic_url = json["pic_url"].stringValue
        
        model.price = json["price"].stringValue
        model.seller_id = json["seller_id"].stringValue
        model.shop_title = json["shop_title"].stringValue
        model.title = json["title"].stringValue
        
        model.type = json["type"].stringValue
        model.volume = json["volume"].stringValue
        model.activity_id = json["activity_id"].stringValue
        model.activity_type = json["activity_type"].stringValue
        
        model.cat = json["cat"].stringValue
        model.coupon_link = JD_Coupon_linkModel.setUpModel(json: json["coupon_link"]) //json["coupon_link"].stringValue
        model.created_at = json["created_at"].stringValue
        model.end_time = json["end_time"].stringValue
        
        model.id = json["id"].stringValue
        model.introduce = json["introduce"].stringValue
        model.is_recommend = json["is_recommend"].stringValue
        model.item_url = json["item_url"].stringValue
        
        model.thumb = json["thumb"].stringValue
        model.type_id = json["type_id"].stringValue
        model.nick = json["nick"].stringValue
        model.receive_num = json["receive_num"].stringValue
        model.shop_type = json["shop_type"].stringValue
        model.sort = json["sort"].stringValue
        
        model.start_time = json["start_time"].stringValue
        model.status = json["status"].stringValue
        model.tag = json["tag"].stringValue
        model.threshold_coupon = json["threshold_coupon"].stringValue
        
        model.total_num = json["total_num"].stringValue
        model.updated_at = json["updated_at"].stringValue
        model.videoid = json["videoid"].stringValue
        model.app_id = json["app_id"].stringValue
        
        model.deleted_at = json["deleted_at"].stringValue
        model.hour_type = json["hour_type"].stringValue
        model.itemid = json["itemid"].stringValue
        model.sales = json["sales"].stringValue
        
        model.short_title = json["short_title"].stringValue
        model.today_sale = json["today_sale"].stringValue
        model.video_id = json["video_id"].stringValue
        model.video_url = json["video_url"].stringValue
        
        model.favourite = json["favourite"].stringValue
        model.coupon_start_time = json["coupon_start_time"].stringValue
        model.coupon_end_time = json["coupon_end_time"].stringValue
        
        model.isBindPhone = json["isBindPhone"].stringValue
        model.isBindInviter = json["isBindInviter"].stringValue
        model.isOauth = json["isOauth"].stringValue
        model.oauthUrl = json["oauthUrl"].stringValue
        
        model.short_type = json["short_type"].stringValue
        model.share = shareModel.setUpValues(json: json["share"])
        
        return model
    }
}
class SZYLQImagesToolModel: NSObject {
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
class SZYStoreInformationModel: NSObject {
    var allItemCount = String()
    var creditLevel = String()
    var creditLevelIcon = String()
    var evaluates = Array<SZYevaluatesModel>()
    
    var fans = String()
    var fbt2User = String()
    var goodRatePercentage = String()
    var sellerNick = String()
    
    var sellerType = String()
    var shopCard = String()
    var shopIcon = String()
    var shopId = String()
    
    var shopName = String()
    var shopType = String()
    var shopUrl = String()
    var showShopLinkIcon = String()
    
    var simpleShopDOStatus = String()
    var starts = String()
    var tagIcon = String()
    var taoShopUrl = String()
    
    var userId = String()
    
    class func setupValues(json:JSON) -> SZYStoreInformationModel {
        let model = SZYStoreInformationModel()
        
        model.allItemCount = json["allItemCount"].stringValue
        model.creditLevel = json["creditLevel"].stringValue
        model.creditLevelIcon = json["creditLevelIcon"].stringValue
        model.evaluates = SZYevaluatesModel.setupValues(json: json["evaluates"])
        
        model.fans = json["fans"].stringValue
        model.fbt2User = json["fbt2User"].stringValue
        model.goodRatePercentage = json["goodRatePercentage"].stringValue
        model.sellerNick = json["sellerNick"].stringValue
        
        model.sellerType = json["sellerType"].stringValue
        model.shopCard = json["shopCard"].stringValue
        model.shopIcon = json["shopIcon"].stringValue
        model.shopId = json["shopId"].stringValue
        
        model.shopName = json["shopName"].stringValue
        model.shopType = json["shopType"].stringValue
        model.shopUrl = json["shopUrl"].stringValue
        model.showShopLinkIcon = json["showShopLinkIcon"].stringValue
        
        model.simpleShopDOStatus = json["simpleShopDOStatus"].stringValue
        model.starts = json["starts"].stringValue
        model.tagIcon = json["tagIcon"].stringValue
        model.taoShopUrl = json["taoShopUrl"].stringValue
        
        model.userId = json["userId"].stringValue
        
        return model
    }
}
class SZYevaluatesModel: NSObject {
    var level = String()
    var levelBackgroundColor = String()
    var levelText = String()
    var levelTextColor = String()
    
    var score = String()
    var title = String()
    var tmallLevelBackgroundColor = String()
    var tmallLevelTextColor = String()
    
    var type = String()
    class func setupValues(json: JSON) -> Array<SZYevaluatesModel> {
        var models = Array<SZYevaluatesModel>()
        let jsonArr = json.arrayValue
        
        for index in 0..<jsonArr.count {
            let model = SZYevaluatesModel()
            
            model.level = jsonArr[index]["level"].stringValue
            model.levelBackgroundColor = jsonArr[index]["levelBackgroundColor"].stringValue
            model.levelText = jsonArr[index]["levelText"].stringValue
            model.levelTextColor = jsonArr[index]["levelTextColor"].stringValue
            
            model.score = jsonArr[index]["score"].stringValue
            model.title = jsonArr[index]["title"].stringValue
            model.tmallLevelBackgroundColor = jsonArr[index]["tmallLevelBackgroundColor"].stringValue
            model.tmallLevelTextColor = jsonArr[index]["tmallLevelTextColor"].stringValue
            
            model.type = jsonArr[index]["type"].stringValue
            models.append(model)
        }
        
        return models
    }
}
class WebModel: NSObject {
    
    var good_item_id = String()
    var userId = String()
    var webViewHeight = CFloat()
    var urlStr = String()
    
    
}
class shareModel: NSObject {
    
    var comment = String()
    var content = String()
    var kouling = String()
    var url = String()
    
    
    class func setUpValues(json: JSON) -> shareModel {
        let model = shareModel()
        
        model.comment = json["comment"].stringValue
        model.content = json["content"].stringValue
        model.kouling = json["kouling"].stringValue
        model.url = json["url"].stringValue
        
        return model
    }
    
}
class JD_Coupon_linkModel: NSObject {
    
    var url = String()
    var mobile_url = String()
    var we_app_info = String()
    var mobile_short_url = String()
    var we_app_web_view_url = String()
    var goods_detail = String()
    var short_url = String()
    var we_app_web_view_short_url = String()
    
    class func setUpModel(json: JSON) -> JD_Coupon_linkModel {
        let model = JD_Coupon_linkModel()
        
        model.url = json["url"].stringValue
        model.mobile_url = json["mobile_url"].stringValue
        model.we_app_info = json["we_app_info"].stringValue
        model.mobile_short_url = json["mobile_short_url"].stringValue
        model.we_app_web_view_url = json["we_app_web_view_url"].stringValue
        model.goods_detail = json["goods_detail"].stringValue
        model.short_url = json["short_url"].stringValue
        model.we_app_web_view_short_url = json["we_app_web_view_short_url"].stringValue
        
        return model
    }
    
}
