//
//  JGSuperKindOptionHeader.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/8/28.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit

class JGSuperKindOptionHeader: UICollectionReusableView {

    @IBOutlet weak var TitleLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TitleLbl.textColor = UIColor.hex("#999999")
        
    }
    
}
