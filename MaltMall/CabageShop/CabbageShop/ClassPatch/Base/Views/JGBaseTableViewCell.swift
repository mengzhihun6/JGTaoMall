//
//  JGBaseTableViewCell.swift
//  FD_Rider_Swift
//
//  Created by 郭军 on 2019/6/12.
//  Copyright © 2019 JG. All rights reserved.
//

import UIKit
import Reusable

class JGBaseTableViewCell: UITableViewCell ,Reusable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func configUI() { }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
