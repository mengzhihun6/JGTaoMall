//
//  JTHHomeDiyModel.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/28.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class JTHHomeDiyModel: NSObject {
    
    var home = homeDiyModel()
    var list = ""
    var detail = ""
    var user = ""
    var login = loginDiyModel()
    
    class func setUpModel(json: JSON) -> JTHHomeDiyModel {
        let model = JTHHomeDiyModel()
        
        model.home = homeDiyModel.setUpModel(json: json["home"])
        
        
        
        model.login = loginDiyModel.setUpModel(json: json["login"])
        
        return model
    }
    
}
class homeDiyModel: NSObject {
    
    var banner = bannerDiyModel()
    var entrance = entranceDiyModel()
    var goods = [goodsDiyModel]()
    
    class func setUpModel(json: JSON) -> homeDiyModel {
        let model = homeDiyModel()
        
        model.banner = bannerDiyModel.setUpModel(json: json["banner"])
        model.entrance = entranceDiyModel.setUpModel(json: json["entrance"])
        model.goods = goodsDiyModel.setUpModel(json: json["goods"])
        
        return model
    }
    
}
class bannerDiyModel: NSObject {
    
    var data = [dataDiyModel]()
    var theme = String()
    
    class func setUpModel(json: JSON) -> bannerDiyModel {
        let model = bannerDiyModel()
        
        model.data = dataDiyModel.setUpModel(json: json["data"])
        model.theme = json["theme"].stringValue
        
        return model
    }
    
}
class dataDiyModel: NSObject {
    
    var imageUrl = String()
    var url = String()
    
    class func setUpModel(json: JSON) -> [dataDiyModel] {
        let jsonArr = json.arrayValue
        var models = [dataDiyModel]()
        
        for index in 0..<jsonArr.count {
            let model = dataDiyModel()
            
            model.imageUrl = json[index]["imageUrl"].stringValue
            model.url = json[index]["url"].stringValue
            
            models.append(model)
        }
        
        return models
    }
    
}

class entranceDiyModel: NSObject {
    
    var data = [entranceDataDiyModel]()
    var theme = String()
    
    class func setUpModel(json: JSON) -> entranceDiyModel {
        let model = entranceDiyModel()
        
        model.data = entranceDataDiyModel.setUpModel(json: json["data"])
        model.theme = json["theme"].stringValue
        
        return model
    }
    
}
class entranceDataDiyModel: NSObject {
    
    var imageUrl = String()
    var url = String()
    var name = String()
    var desc = String()
    
    class func setUpModel(json: JSON) -> [entranceDataDiyModel] {
        let jsonArr = json.arrayValue
        var models = [entranceDataDiyModel]()
        
        for indes in 0..<jsonArr.count {
            let model = entranceDataDiyModel()
            
            model.imageUrl = jsonArr[indes]["imageUrl"].stringValue
            model.url = jsonArr[indes]["url"].stringValue
            model.name = jsonArr[indes]["name"].stringValue
            model.desc = jsonArr[indes]["desc"].stringValue
            
            models.append(model)
        }
        
        return models
    }
    
}

class goodsDiyModel: NSObject {
    
    var theme = String()
    var data = [dataDiyModel]()
    var type = String()
    var title = String()
    var list = [SZYGoodsInformationModel]()
    
    
    class func setUpModel(json: JSON) -> [goodsDiyModel] {
        let jsonArr = json.arrayValue
        var models = [goodsDiyModel]()
        
        for idnex in 0..<jsonArr.count {
            let model = goodsDiyModel()
            
            model.theme = json[idnex]["theme"].stringValue
            model.data = dataDiyModel.setUpModel(json: json[idnex]["data"])
            model.type = json[idnex]["type"].stringValue
            model.title = json[idnex]["title"].stringValue
            let goodJsonArr = json[idnex]["list"].arrayValue
            for goo in 0..<goodJsonArr.count {
                model.list.append(SZYGoodsInformationModel.setupValues(json: goodJsonArr[goo]))
            }
            
            models.append(model)
        }
        
        return models
    }
    
}














class loginDiyModel: NSObject {
    
    var theme = String()
    
    class func setUpModel(json: JSON) -> loginDiyModel {
        let model = loginDiyModel()
        
        model.theme = json["theme"].stringValue
        
        return model
    }
    
}
