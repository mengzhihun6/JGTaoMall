//
//  SZYTuanduiModel.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/23.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYTuanduiModel: NSObject {
    
    var inviter = SZYTuanDuiinviterModel()
    var groupSum = String()
    var member = String()
    var inviterToday = String()
    
    var groupToday = String()
    var inviterYesterday = String()
    var groupYesterday = String()
    var inviterMonth = String()
    
    var groupMonth = String()
    var inviterLastMonth = String()
    var groupLastMonth = String()
    class func setupValues(json:JSON) -> SZYTuanduiModel {
        let model = SZYTuanduiModel()
        
        model.inviter = SZYTuanDuiinviterModel.setupValues(json: json["inviter"])
        model.groupSum = json["groupSum"].stringValue
        model.member = json["member"].stringValue
        model.inviterToday = json["inviterToday"].stringValue
        
        model.groupToday = json["groupToday"].stringValue
        model.inviterYesterday = json["inviterYesterday"].stringValue
        model.groupYesterday = json["groupYesterday"].stringValue
        model.inviterMonth = json["inviterMonth"].stringValue
        
        model.groupMonth = json["groupMonth"].stringValue
        model.inviterLastMonth = json["inviterLastMonth"].stringValue
        model.groupLastMonth = json["groupLastMonth"].stringValue
        
        return model
    }
}
class SZYTuanDuiinviterModel: NSObject {
    
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
    var tag = String()
    
    class func setupValues(json:JSON) -> SZYTuanDuiinviterModel {
        let model = SZYTuanDuiinviterModel()
        
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
        model.tag = json["tag"].stringValue
        return model
    }
}
