//
//  JGBaseTableViewHeaderFooterView.swift
//  FD_Rider_Swift
//
//  Created by 郭军 on 2019/6/12.
//  Copyright © 2019 JG. All rights reserved.
//

import UIKit
import Reusable

class JGBaseTableViewHeaderFooterView: UITableViewHeaderFooterView,Reusable {

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
          configUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() { }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
