//
//  JGBaseView.swift
//  FD_Rider_Swift
//
//  Created by 郭军 on 2019/6/17.
//  Copyright © 2019 JG. All rights reserved.
//

import UIKit

class JGBaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func configUI() {
        
        
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
