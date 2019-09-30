//
//  LNNewMainLayoutModel.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/21.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
class LNNewMainLayoutModel: NSObject {
    var children = Array<LNMainChildreModel>()
    var bgimg = String()
    var id = String()
    var layout1 = String()
    var layout2 = String()
    var limit = String()
    var list_thumb = String()
    var name = String()
    var params = String()
    var pid = String()
    var show_category = String()
    var sort = String()
    var thumb = String()
    var status = String()
    var coupous = Array<LNYHQListModel>()
    
    
    class func setupValues(json:JSON) -> LNNewMainLayoutModel {
        let model = LNNewMainLayoutModel()
        
        model.children = LNMainChildreModel.setupValues(jsonData: json["children"])
        model.bgimg = json["bgimg"].stringValue
        model.id = json["id"].stringValue
        model.layout1 = json["layout1"].stringValue
        model.layout2 = json["layout2"].stringValue
        model.limit = json["limit"].stringValue
        model.list_thumb = json["list_thumb"].stringValue
        model.name = json["name"].stringValue
        model.params = json["params"].stringValue
        model.pid = json["pid"].stringValue
        model.show_category = json["show_category"].stringValue
        model.sort = json["sort"].stringValue
        model.thumb = json["thumb"].stringValue
        model.status = json["status"].stringValue
        return model
    }
}


class LNMainChildreModel: NSObject {
    var bgimg = String()
    var id = String()
    var layout1 = String()
    var layout2 = String()
    var limit = String()
    var list_thumb = String()
    var name = String()
    var params = String()
    var pid = String()
    var show_category = String()
    var sort = String()
    var thumb = String()
    var status = String()
    
    class func setupValues(jsonData:JSON) -> Array<LNMainChildreModel> {
        
        var models = Array<LNMainChildreModel>()
        
        let jsonArr = jsonData.arrayValue
        
        for index in 0..<jsonArr.count {
            let json = jsonArr[index]
            
            let model = LNMainChildreModel()
            
            model.bgimg = json["bgimg"].stringValue
            model.id = json["id"].stringValue
            model.layout1 = json["layout1"].stringValue
            model.layout2 = json["layout2"].stringValue
            model.limit = json["limit"].stringValue
            model.list_thumb = json["list_thumb"].stringValue
            model.name = json["name"].stringValue
            model.params = json["params"].stringValue
            model.pid = json["pid"].stringValue
            model.show_category = json["show_category"].stringValue
            model.sort = json["sort"].stringValue
            model.thumb = json["thumb"].stringValue
            model.status = json["status"].stringValue
            
            models.append(model)
        }
        
        
        return models
    }
}
