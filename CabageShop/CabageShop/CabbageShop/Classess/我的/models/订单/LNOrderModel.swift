//
//  LNOrderModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/6.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNOrderModel: NSObject {
    var id = String()
    var user_id = String()
    var member_id = String()   //v3 里面没有这个字段
    var group_id = String()
    var ordernum = String()
    var title = String()
    var itemid = String()
    var count = String()
    var price = String()
    var final_price = String()
    var commission_rate = String()
    var commission_amount = String()
    var pid = String()
    var status = String()
    var type = String()
    var created_at = String()
    var userIcon = String()
    
    var oldgroup_id = String()
    var app_id = String()
    var pic_url = String()
    var site_id = String()
    var relation_id = String()
    var special_id = String()
    var group_rate1 = String()
    var group_rate2 = String()
    var commission_rate1 = String()
    var commission_rate2 = String()
    var is_system = String()
    var is_privacy = String()
    var is_calculate = String()
    
    var num = String()
    var complete_at = String()
    var updated_at = String()
    
    var user = LNOrderUserModel()
    var total_commission_amount = String()
    var trade_parent_id = String()
    
    
    class func setupValues(json:JSON) -> LNOrderModel {
        let model = LNOrderModel()
        
        model.id = json["id"].stringValue
        model.user_id = json["user_id"].stringValue
        model.member_id = json["member_id"].stringValue
        model.group_id = json["group_id"].stringValue
        model.ordernum = json["ordernum"].stringValue
        model.title = json["title"].stringValue
        model.itemid = json["itemid"].stringValue
        model.count = json["count"].stringValue
        model.price = json["price"].stringValue
        model.final_price = json["final_price"].stringValue
        model.commission_rate = json["commission_rate"].stringValue
        model.commission_amount = json["commission_amount"].stringValue
        model.pid = json["pid"].stringValue
        model.status = json["status"].stringValue
        model.type = json["type"].stringValue
        model.created_at = json["created_at"].stringValue
        model.userIcon = json["pic_url"].stringValue
        
        model.oldgroup_id = json["oldgroup_id"].stringValue
        model.app_id = json["app_id"].stringValue
        model.pic_url = json["pic_url"].stringValue
        model.site_id = json["site_id"].stringValue
        
        model.relation_id = json["relation_id"].stringValue
        model.special_id = json["special_id"].stringValue
        model.group_rate1 = json["group_rate1"].stringValue
        model.group_rate2 = json["group_rate2"].stringValue
        
        model.commission_rate1 = json["commission_rate1"].stringValue
        model.commission_rate2 = json["commission_rate2"].stringValue
        model.is_system = json["is_system"].stringValue
        model.is_privacy = json["is_privacy"].stringValue
        
        model.is_calculate = json["is_calculate"].stringValue
        model.num = json["num"].stringValue
        model.complete_at = json["complete_at"].stringValue
        model.updated_at = json["updated_at"].stringValue
        
        model.user = LNOrderUserModel.setupValues(json: json["user"])
        model.total_commission_amount = json["total_commission_amount"].stringValue
        
        model.trade_parent_id = json["trade_parent_id"].stringValue
        return model
    }

}
class LNOrderUserModel: NSObject {
    
    var id = String()
    var app_id = String()
    var inviter_id = String()
    var group_id = String()
    
    var oldgroup_id = String()
    var nickname = String()
    var phone = String()
    var headimgurl = String()
    var is_default = String()
    
    
    var credit1 = String()
    var credit2 = String()
    var credit3 = String()
    var credit4 = String()
    
    var level_id = String()
    var realname = String()
    var alipay = String()
    var status = String()
    
    var invite_code = String()
    var remember_token = String()
    var expired_time = String()
    var signin_time = String()
    
    var max_signin = String()
    var created_at = String()
    var updated_at = String()
    var deleted_at = String()
    
    var credit5 = String()
    var sign_max = String()
    var sign_continuous = String()
    var sign_sum = String()
    var hmtk_sid = String()
    
    class func setupValues(json:JSON) -> LNOrderUserModel {
        let model = LNOrderUserModel()
        
        model.id = json["id"].stringValue
        model.app_id = json["app_id"].stringValue
        model.inviter_id = json["inviter_id"].stringValue
        model.group_id = json["group_id"].stringValue
        
        model.oldgroup_id = json["oldgroup_id"].stringValue
        model.nickname = json["nickname"].stringValue
        model.phone = json["phone"].stringValue
        model.headimgurl = json["headimgurl"].stringValue
        
        model.is_default = json["is_default"].stringValue
        model.credit1 = json["credit1"].stringValue
        model.credit2 = json["credit2"].stringValue
        model.credit3 = json["credit3"].stringValue
        
        model.credit4 = json["credit4"].stringValue
        model.level_id = json["level_id"].stringValue
        model.realname = json["realname"].stringValue
        model.alipay = json["alipay"].stringValue
        
        model.status = json["status"].stringValue
        model.invite_code = json["invite_code"].stringValue
        model.remember_token = json["remember_token"].stringValue
        model.expired_time = json["expired_time"].stringValue
        
        model.signin_time = json["signin_time"].stringValue
        model.max_signin = json["max_signin"].stringValue
        model.created_at = json["created_at"].stringValue
        model.updated_at = json["updated_at"].stringValue
        
        model.deleted_at = json["deleted_at"].stringValue
        model.credit5 = json["credit5"].stringValue
        model.sign_max = json["sign_max"].stringValue
        model.sign_continuous = json["sign_continuous"].stringValue
        
        model.sign_sum = json["sign_sum"].stringValue
        model.hmtk_sid = json["hmtk_sid"].stringValue
        
        return model
    }




}
