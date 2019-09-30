//
//  SZYEarningsModel.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/20.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYEarningsModel: NSObject {
    
    var order = SZYorderModel()
    var commission = SZYCommissionModel()
    
    class func setupValues(json:JSON) -> SZYEarningsModel {
        let model = SZYEarningsModel()
        
        model.order = SZYorderModel.setupValues(json: json["order"])
        model.commission = SZYCommissionModel.setupValues(json: json["commission"])
        
        return model
    }
}
class SZYorderModel: NSObject {
    
    var commissionOrder1 = String()
    var commissionOrder2 = String()
    var commissionGroup1 = String()
    var commissionGroup2 = String()
    var money = String()
    var orderNum = String()
    
    var sum = String()
    
    class func setupValues(json:JSON) -> SZYorderModel {
        let model = SZYorderModel()
        
        model.commissionGroup1 = json["commissionGroup1"].stringValue
        model.commissionGroup2 = json["commissionGroup2"].stringValue
        model.commissionOrder1  = json["commissionOrder1"].stringValue
        model.commissionOrder2 = json["commissionOrder2"].stringValue
        model.money = json["money"].stringValue
        model.sum = json["sum"].stringValue
        model.orderNum = json["orderNum"].stringValue
        
        return model
    }
}
class SZYCommissionModel: NSObject {
    
    var commission1 = String()
    var commission2 = String()
    var groupCommission1 = String()
    var groupCommission2 = String()
    var userNum = String()
    
    
    class func setupValues(json:JSON) -> SZYCommissionModel {
        let model = SZYCommissionModel()
        
        model.commission1 = json["commission1"].stringValue
        model.commission2 = json["commission2"].stringValue
        model.groupCommission1 = json["groupCommission1"].stringValue
        model.groupCommission2 = json["groupCommission2"].stringValue
        model.userNum = json["userNum"].stringValue
        
        return model
    }
}
