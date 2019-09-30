//
//  LNArticlesModel.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/15.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNArticlesModel: NSObject {
    var id = String()
    var title = String()
    var thumb = String()
    var keywords = String()
    var description1 = String()
    var content = String()
    var views = String()
    var created_at = String()

    class func setupValues(json:JSON) -> LNArticlesModel {
        let model = LNArticlesModel()
        
        model.id = json["id"].stringValue
        model.title = json["title"].stringValue
        model.thumb = json["thumb"].stringValue
        model.keywords = json["keywords"].stringValue
        model.description1 = json["description"].stringValue
        model.content = json["content"].stringValue
        model.views = json["views"].stringValue
        model.created_at = json["created_at"].stringValue
        return model
    }

}
