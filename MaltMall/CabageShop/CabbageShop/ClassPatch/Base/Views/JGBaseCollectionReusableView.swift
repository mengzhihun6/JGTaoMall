//
//  JGBaseCollectionReusableView.swift
//  FD_Rider_Swift
//
//  Created by 郭军 on 2019/6/12.
//  Copyright © 2019 JG. All rights reserved.
//

import UIKit
import Reusable

class JGBaseCollectionReusableView: UICollectionReusableView, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func configUI(){}

    
}
