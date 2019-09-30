//
//  LNTaskModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/21.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
class LNTaskModel: NSObject {
    var title = String()
    var describe = String()
    var credit = String()
    
    class func setupValues(json:JSON) -> LNTaskModel {
        let model = LNTaskModel()
        
        model.describe = json["describe"].stringValue
        model.title = json["title"].stringValue
        model.credit = json["credit"].stringValue
        return model
    }

}
