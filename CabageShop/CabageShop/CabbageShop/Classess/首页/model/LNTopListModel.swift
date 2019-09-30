//
//  LNTopListModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/6.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNTopListModel: NSObject {
    var id = String()
    var user_id = String()
    var name = String()
    var logo = String()
    var taobao = String()
    var jingdong = String()
    var pinduoduo = String()
    var sort = String()
    var status = String()
    var cat = String()
    var parent_id = String()
    var type = String()
    var children = Array<LNSuperChildrenModel>()

    
    class func setupValues(json:JSON) -> LNTopListModel {
        let model = LNTopListModel()
        
        model.id = json["id"].stringValue
        model.user_id = json["user_id"].stringValue
        model.name = json["name"].stringValue
        model.logo = json["logo"].stringValue
        model.taobao = json["taobao"].stringValue
        model.jingdong = json["jingdong"].stringValue
        model.pinduoduo = json["pinduoduo"].stringValue
        model.sort = json["sort"].stringValue
        model.status = json["status"].stringValue
        model.cat = json["cat"].stringValue
        model.parent_id = json["parent_id"].stringValue
        model.type = json["type"].stringValue
        model.children = LNSuperChildrenModel.setValue(json: json["children"])
        return model
    }

}
