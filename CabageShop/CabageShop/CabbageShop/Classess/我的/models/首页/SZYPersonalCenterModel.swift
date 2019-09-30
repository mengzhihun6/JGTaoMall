//
//  SZYPersonalCenterModel.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/16.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYPersonalCenterModel: NSObject {
    
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
    var friends_count = String()
    var level = SZYLevelModel()
    var inviter = SZYInviterModel()
    
    var group = SZYGroupModel()
    var hashid = String()
    
    class func setupValues(json:JSON) -> SZYPersonalCenterModel {
        let model = SZYPersonalCenterModel()
        
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
        model.friends_count = json["friends_count"].stringValue
        model.level = SZYLevelModel.setupValues(json: json["level"])
        model.inviter = SZYInviterModel.setupValues(json: json["inviter"])
        
        model.group = SZYGroupModel.setupValues(json: json["group"])
        model.hashid = json["hashid"].stringValue
        return model
    }
}
class SZYLevelModel: NSObject {
    var id = String()
    var app_id = String()
    var level = String()
    var name = String()
    
    var logo = String()
    var group_rate1 = String()
    var group_rate2 = String()
    var commission_rate1 = String()
    
    var commission_rate2 = String()
    var credit = String()
    var price1 = String()
    var price2 = String()
    
    var price3 = String()
    var price4 = String()
    var is_commission = String()
    var is_group = String()
    
    var is_pid = String()
    var default1 = String()
    var status = String()
    var is_show = String()
    
    var created_at = String()
    var updated_at = String()
    var deleted_at = String()
    
    class func setupValues(json:JSON) -> SZYLevelModel {
        let model = SZYLevelModel()
        
        model.id = json["id"].stringValue
        model.app_id = json["app_id"].stringValue
        model.level = json["level"].stringValue
        model.name = json["name"].stringValue
        
        model.logo = json["logo"].stringValue
        model.group_rate1 = json["group_rate1"].stringValue
        model.group_rate2 = json["group_rate2"].stringValue
        model.commission_rate1 = json["commission_rate1"].stringValue
        
        model.commission_rate2 = json["commission_rate2"].stringValue
        model.credit = json["credit"].stringValue
        model.price1 = json["price1"].stringValue
        model.price2 = json["price2"].stringValue
        
        model.price3 = json["price3"].stringValue
        model.price4 = json["price4"].stringValue
        model.is_commission = json["is_commission"].stringValue
        model.is_group = json["is_group"].stringValue
        
        model.is_pid = json["is_pid"].stringValue
        model.default1 = json["default"].stringValue
        model.status = json["status"].stringValue
        model.is_show = json["is_show"].stringValue
        
        model.created_at = json["created_at"].stringValue
        model.updated_at = json["updated_at"].stringValue
        model.deleted_at = json["deleted_at"].stringValue
        return model
    }
}
class SZYInviterModel: NSObject {
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
    class func setupValues(json:JSON) -> SZYInviterModel {
        let model = SZYInviterModel()
        
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
        return model
    }
}
class SZYGroupModel: NSObject {
    var id = String()
    var app_id = String()
    var name = String()
    var qrcode = String()
    
    var qq = String()
    var wechat = String()
    var description1 = String()
    var status = String()
    
    var created_at = String()
    var updated_at = String()
    var deleted_at = String()
    
    class func setupValues(json:JSON) -> SZYGroupModel {
        let model = SZYGroupModel()
        
        model.id = json["id"].stringValue
        model.app_id = json["app_id"].stringValue
        model.name = json["name"].stringValue
        model.qrcode = json["qrcode"].stringValue
        
        model.qq = json["qq"].stringValue
        model.wechat = json["wechat"].stringValue
        model.description1 = json["description"].stringValue
        model.status = json["status"].stringValue
        
        model.created_at = json["created_at"].stringValue
        model.updated_at = json["updated_at"].stringValue
        model.deleted_at = json["deleted_at"].stringValue
        return model
    }
}
class SZYChartModel: NSObject {
    var lastMonth = String()
    var lastMonthCommission = String()
    var month = String()
    var yesterday = String()
    
    var today = String()
    var money = String()
    var income = String()
    
    
    class func setupValues(json:JSON) -> SZYChartModel {
        let model = SZYChartModel()
        
        model.lastMonth = json["lastMonth"].stringValue
        model.lastMonthCommission = json["lastMonthCommission"].stringValue
        model.month = json["month"].stringValue
        model.yesterday = json["yesterday"].stringValue
        
        model.today = json["today"].stringValue
        model.money = json["money"].stringValue
        model.income = json["income"].stringValue
        
        return model
    }
}
