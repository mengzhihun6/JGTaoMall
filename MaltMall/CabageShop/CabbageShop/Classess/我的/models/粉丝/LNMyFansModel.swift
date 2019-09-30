//
//  LNMyFansModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/17.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNMyFansModel: NSObject {
    var id = String()
    var headimgurl = String()
    var inviter_id = String()
    var nickname = String()
    var phone = String()
    var created_at = String()
    var freinds_count = Int()
    var level_id = String()

    class func setupValues(json:JSON) -> LNMyFansModel {
        let model = LNMyFansModel()
        
        model.id = json["id"].stringValue
        model.headimgurl = json["headimgurl"].stringValue
        model.inviter_id = json["inviter_id"].stringValue
        model.nickname = json["nickname"].stringValue
        model.phone = json["phone"].stringValue
        model.created_at = json["created_at"].stringValue
        model.freinds_count = json["friends_count"].intValue
        model.level_id = json["level_id"].stringValue
        return model
    }

}
