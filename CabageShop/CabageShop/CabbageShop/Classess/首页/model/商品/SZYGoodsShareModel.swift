//
//  SZYGoodsShareModel.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/21.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYGoodsShareModel: NSObject {
    
    var url = String()
    var content = String()
    var comment = String()
    
    class func setupValues(json:JSON) -> SZYGoodsShareModel {
        let model = SZYGoodsShareModel()
        
        model.url = json["url"].stringValue
        model.content = json["content"].stringValue
        model.comment = json["comment"].stringValue
        
        return model
    }
    
}
