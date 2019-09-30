//
//  LNCreditLogModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/7.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNCreditLogModel: NSObject {
    var id = String()
    var current_credit = String()
    var remark = String()
    var credit = String()
    var type = String()
    var created_at = String()

    class func setupValues(json:JSON) -> LNCreditLogModel {
        let model = LNCreditLogModel()
        
        model.id = json["id"].stringValue
        model.current_credit = json["current_credit"].stringValue
        model.remark = json["remark"].stringValue
        model.credit = json["credit"].stringValue
        model.type = json["type"].stringValue
        model.created_at = json["updated_at"].stringValue
        return model
    }

}

class WithdrawalRecordModel: NSObject {
    
    var id = String()
    var app_id = String()
    var money = String()
    var real_money = String()
    
    var realname = String()
    var alipay = String()
    var reason = String()
    var status = String()
    
    var pay_type = String()
    var credit_type = String()
    var created_at = String()
    var updated_at = String()
    
    
    
    class func setupValues(json: JSON) -> WithdrawalRecordModel {
        let model = WithdrawalRecordModel()
        
        model.id = json["id"].stringValue
        model.app_id = json["app_id"].stringValue
        model.money = json["money"].stringValue
        model.real_money = json["real_money"].stringValue
        
        model.realname = json["realname"].stringValue
        model.alipay = json["alipay"].stringValue
        model.reason = json["reason"].stringValue
        model.status = json["status"].stringValue
        
        model.pay_type = json["pay_type"].stringValue
        model.credit_type = json["credit_type"].stringValue
        model.created_at = json["created_at"].stringValue
        model.updated_at = json["updated_at"].stringValue
        
        return model
    }
    
    class func setupValues1(json: JSON) -> WithdrawalRecordModel {
        let model = WithdrawalRecordModel()
        
        model.id = json["id"].stringValue
        model.app_id = json["app_id"].stringValue
        model.money = json["system_commission"].stringValue
        model.real_money = json["real_money"].stringValue
        
        model.realname = json["realname"].stringValue
        model.alipay = json["alipay"].stringValue
        model.reason = json["reason"].stringValue
        model.status = json["status"].stringValue
        
        model.pay_type = json["pay_type"].stringValue
        model.credit_type = json["credit_type"].stringValue
        model.created_at = json["created_at"].stringValue
        model.updated_at = json["updated_at"].stringValue
        
        return model
    }
}
