//
//  LQMainMessageModel.swift
//  LingQuan
//
//  Created by 付耀辉 on 2018/5/25.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LQMainMessageModel: NSObject {

    var sendno = String()
    var title = String()
    var message = String()
    var msgId = String()
    var logo = String()
    var createdAt = String()
    var sendAt = String()

    class func setupValues(json:JSON) -> LQMainMessageModel {
        let model = LQMainMessageModel()
        
        model.sendno = json["sendno"].stringValue
        model.title = json["title"].stringValue
        model.message = json["message"].stringValue
        model.msgId = json["msgId"].stringValue
        model.logo = json["logo"].stringValue
        model.createdAt = json["created_at"].stringValue
        model.sendAt = json["sendAt"].stringValue
        return model
    }

    
}
