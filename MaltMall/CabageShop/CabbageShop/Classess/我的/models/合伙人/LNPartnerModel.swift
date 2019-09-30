//
//  LNPartnerModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/21.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
class LNPartnerModel: NSObject {
    var id = String()
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
    var price5 = String()

    var duration = String()
    var description1 = String()
    var is_commission = String()
    var is_group = String()
    var is_pid = String()
    var default1 = String()
    var status = String()
    var privileges = Array<LNPrivileges>()

    var memberModel = LNMemberModel()
    
    class func setupValues(json:JSON) -> LNPartnerModel {
        let model = LNPartnerModel()
        
        model.id = json["id"].stringValue
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
        model.price5 = json["price5"].stringValue
        model.duration = json["duration"].stringValue
        model.description1 = json["description"].stringValue
        model.is_commission = json["is_commission"].stringValue
        model.is_group = json["is_group"].stringValue
        model.is_pid = json["is_pid"].stringValue
        model.default1 = json["default"].stringValue
        model.status = json["status"].stringValue
        model.privileges = LNPrivileges.setValue(json: json["privileges"])
        return model
    }

}
class LNPrivileges: NSObject {
    
    var id = String()
    var logo = String()
    var name = String()
  
    
    class func setValue(json: JSON) -> Array<LNPrivileges> {
        
        var models = Array<LNPrivileges>()
        
        let jsonArr = json.arrayValue
        
        for index in 0..<jsonArr.count {
            
            let model = LNPrivileges()
            model.id = jsonArr[index]["id"].stringValue
            model.logo = jsonArr[index]["logo"].stringValue
            model.name = jsonArr[index]["name"].stringValue
            models.append(model)
        }
        return models
    }
    
}
