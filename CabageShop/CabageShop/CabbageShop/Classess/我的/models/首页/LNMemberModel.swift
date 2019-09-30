//
//  LNMemberModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/6.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNMemberModel: NSObject {
    var id = String()
    var inviter_id = String()
    var group_id = String()
    var oldgroup_id = String()
    var wx_unionid = String()
    var wx_openid1 = String()
    var wx_openid2 = String()
    var ali_unionid = String()
    var ali_openid1 = String()
    var ali_openid2 = String()
    var nickname = String()
    var phone = String()
    var headimgurl = String()
    var credit1 = String()
    var credit2 = String()
    var credit3 = String()
    var level_id = String()
    var realname = String()
    var alipay = String()
    var status = String()
    var expired_time = String()
    var created_at = String()
    var inviter = String()
    var hashid = String()
    var friends_count = String()
    var level = LNMemberLevelModel()
    var group = LNMemberGroupModel()
    var height:CGFloat = 365

    class func setupValues(json:JSON) -> LNMemberModel {
        let model = LNMemberModel()
        
        model.id = json["id"].stringValue
        model.inviter_id = json["inviter_id"].stringValue
        model.group_id = json["group_id"].stringValue
        model.oldgroup_id = json["oldgroup_id"].stringValue
        model.wx_unionid = json["wx_unionid"].stringValue
        model.wx_openid1 = json["wx_openid1"].stringValue
        model.wx_openid2 = json["wx_openid2"].stringValue
        model.ali_openid2 = json["ali_openid2"].stringValue
        model.ali_openid1 = json["ali_openid1"].stringValue
        model.nickname = json["nickname"].stringValue
        model.phone = json["phone"].stringValue
        model.headimgurl = json["headimgurl"].stringValue
        model.credit1 = json["credit1"].stringValue
        model.credit2 = json["credit2"].stringValue
        model.credit3 = json["credit3"].stringValue
        model.level_id = json["level_id"].stringValue
        model.realname = json["realname"].stringValue
        model.alipay = json["alipay"].stringValue
        model.status = json["status"].stringValue
        model.expired_time = json["expired_time"].stringValue
        model.created_at = json["created_at"].stringValue
        model.inviter = json["inviter"]["nickname"].stringValue
        model.hashid = json["hashid"].stringValue
        model.friends_count = json["friends_count"].stringValue

        model.level = LNMemberLevelModel.setupValues(json: json["level"])
        model.group = LNMemberGroupModel.setupValues(json: json["group"])
        return model
    }

}


class LNMemberLevelModel: NSObject {
    var id = String()
    var level = String()
    var name = String()
    var logo = String()
    var group_rate1 = String()
    var group_rate2 = String()
    var commission_rate1 = String()
    var commission_rate2 = String()
    var credit = String()
    var price = String()
    var duration = String()
    var description1 = String()
    var is_group = String()
    var default1 = String()
    var status = String()
    var is_commission = String()

    
    class func setupValues(json:JSON) -> LNMemberLevelModel {
        let model = LNMemberLevelModel()
        model.id = json["id"].stringValue
        model.level = json["level"].stringValue
        model.name = json["name"].stringValue
        model.logo = json["logo"].stringValue
        model.group_rate1 = json["group_rate1"].stringValue
        model.group_rate2 = json["group_rate2"].stringValue
        model.commission_rate1 = json["commission_rate1"].stringValue
        model.commission_rate2 = json["commission_rate2"].stringValue
        model.credit = json["credit"].stringValue
        model.price = json["price"].stringValue
        model.duration = json["duration"].stringValue
        model.description1 = json["description"].stringValue
        model.is_group = json["is_group"].stringValue
        model.default1 = json["default"].stringValue
        model.status = json["status"].stringValue
        model.is_commission = json["is_commission"].stringValue
        return model

    }
}

class LNMemberGroupModel: NSObject {
    var id = String()
    var member_id = String()
    var pid = String()
    var qrcode = String()
    var qq = String()
    var wechat = String()
    var name = String()
    var logo = String()
    var description1 = String()
    var status = String()
    var default1 = String()
    var type = String()

    class func setupValues(json:JSON) -> LNMemberGroupModel {
        let model = LNMemberGroupModel()
        model.id = json["id"].stringValue
        model.member_id = json["member_id"].stringValue
        model.pid = json["pid"].stringValue
        model.qrcode = json["qrcode"].stringValue
        model.qq = json["qq"].stringValue
        model.wechat = json["wechat"].stringValue
        model.name = json["name"].stringValue
        model.logo = json["logo"].stringValue
        model.description1 = json["description"].stringValue
        model.status = json["status"].stringValue
        model.default1 = json["default"].stringValue
        model.type = json["type"].stringValue
        return model
        
    }
}

