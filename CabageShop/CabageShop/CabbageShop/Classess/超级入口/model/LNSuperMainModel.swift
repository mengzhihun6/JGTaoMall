//
//  LNSuperMainModel.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/14.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNSuperMainModel: NSObject {
    var id = String()
    var parent_id = String()
    var title = String()
    var sort = String()
    var status = String()
    var entrance = Array<LNSuperDetailModel>()
    var children = Array<LNSuperChildrenModel>()

    class func setupValues(json:JSON) -> LNSuperMainModel {
        let model = LNSuperMainModel()
        model.id = json["id"].stringValue
        model.parent_id = json["parent_id"].stringValue
        model.title = json["title"].stringValue
        model.status = json["status"].stringValue
        model.entrance = LNSuperDetailModel.setValue(json: json["entrance"])
        model.children = LNSuperChildrenModel.setValue(json: json["children"])
        return model
    }
}

class LNSuperDetailModel: NSObject {
    
    var id = String()
    var category_id = String()
    var title = String()
    var logo = String()
    var descrtptionStr = String()
    var descrtptionStr1 = String()
    var url = String()
    var is_home = String()
    var params = String()
    var sort = String()
    var status = String()
    var type = String()
    var app_id = String()

    class func setValue(json: JSON) -> Array<LNSuperDetailModel> {
        
        var models = Array<LNSuperDetailModel>()
        
        let jsonArr = json.arrayValue
        
        for index in 0..<jsonArr.count {
            
            let model = LNSuperDetailModel()
            
            model.id = jsonArr[index]["id"].stringValue
            model.category_id = jsonArr[index]["category_id"].stringValue
            model.title = jsonArr[index]["title"].stringValue
            model.logo = jsonArr[index]["logo"].stringValue
            model.descrtptionStr = jsonArr[index]["descrtption"].stringValue
            model.descrtptionStr1 = jsonArr[index]["description"].stringValue
            model.url = jsonArr[index]["url"].stringValue
            model.is_home = jsonArr[index]["is_home"].stringValue
            model.params = jsonArr[index]["params"].stringValue
            model.sort = jsonArr[index]["sort"].stringValue
            model.status = jsonArr[index]["status"].stringValue
            model.type = jsonArr[index]["type"].stringValue
            model.app_id = jsonArr[index]["app_id"].stringValue

            models.append(model)
        }
        return models
    }
    
}



class LNSuperChildrenModel: NSObject {
    
    var id = String()
    var parent_id = String()
    var title = String()
    var sort = String()
    var status = String()
    var type = String()
    var logo = String()
    var name = String()
    var entrance = Array<LNSuperChildrenEntranceModel>()

    class func setValue(json: JSON) -> Array<LNSuperChildrenModel> {
        
        var models = Array<LNSuperChildrenModel>()
        
        let jsonArr = json.arrayValue
        
        for index in 0..<jsonArr.count {
            
            let model = LNSuperChildrenModel()
            
            model.id = jsonArr[index]["id"].stringValue
            model.parent_id = jsonArr[index]["parent_id"].stringValue
            model.title = jsonArr[index]["title"].stringValue
            model.sort = jsonArr[index]["sort"].stringValue
            model.status = jsonArr[index]["status"].stringValue
            model.type = jsonArr[index]["type"].stringValue
            model.logo = jsonArr[index]["logo"].stringValue
            model.name = jsonArr[index]["name"].stringValue
            model.entrance = LNSuperChildrenEntranceModel.setValue(json: jsonArr[index]["entrance"])

            models.append(model)
        }
        
        
        return models
    }
    
}


class LNSuperChildrenEntranceModel: NSObject {
    
    var is_home = String()
    var category_id = String()
    var title = String()
    var logo = String()
    var descriptionStr = String()
    var url = String()
    var params = String()
    var entrance = Array<LNSuperChildrenEntranceModel>()
    
    class func setValue(json: JSON) -> Array<LNSuperChildrenEntranceModel> {
        
        var models = Array<LNSuperChildrenEntranceModel>()
        
        let jsonArr = json.arrayValue
        
        for index in 0..<jsonArr.count {
            
            let model = LNSuperChildrenEntranceModel()
            
            model.is_home = jsonArr[index]["is_home"].stringValue
            model.category_id = jsonArr[index]["category_id"].stringValue
            model.title = jsonArr[index]["title"].stringValue
            model.logo = jsonArr[index]["logo"].stringValue
            model.descriptionStr = jsonArr[index]["description"].stringValue
            model.url = jsonArr[index]["url"].stringValue
            model.params = jsonArr[index]["params"].stringValue
            
            models.append(model)
        }
        
        
        return models
    }
    
}
