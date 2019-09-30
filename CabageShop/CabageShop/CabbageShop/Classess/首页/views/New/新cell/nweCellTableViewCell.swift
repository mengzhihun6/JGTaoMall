//
//  nweCellTableViewCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/23.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class nweCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func ershisixiaoshi(_ sender: UIButton) {
        kDeBugPrint(item: "24小时热销")
        let nvc = SZYModuleViewController()
        nvc.titleString = "24小时热销"
        nvc.SZYTypeString = "1"
        let vc = viewContainingController() as? LNNewMainViewController
        vc?.superViewController?.navigationController?.pushViewController(nvc, animated: true)
    }
    @IBAction func jiudianjiubaoyou(_ sender: UIButton) {
        kDeBugPrint(item: "9.9包邮")
        let nvc = SZYModuleViewController()
        nvc.titleString = "9.9包邮"
        nvc.SZYTypeString = "2"
        let vc = viewContainingController() as? LNNewMainViewController
        vc?.superViewController?.navigationController?.pushViewController(nvc, animated: true)
    }
    
}
