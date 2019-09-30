//
//  SZYTeamDataReportCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/21.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYTeamDataReportCell: UITableViewCell {
    
    @IBOutlet weak var jinri1: UILabel!
    @IBOutlet weak var jinri2: UILabel!
    
    @IBOutlet weak var zuori1: UILabel!
    @IBOutlet weak var zuori2: UILabel!
    
    @IBOutlet weak var benyue1: UILabel!
    @IBOutlet weak var benyue2: UILabel!
    
    @IBOutlet weak var shangyue1: UILabel!
    @IBOutlet weak var shangyue2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setToValues(model: SZYTuanduiModel) {
        jinri1.text = "自推 " + model.inviterToday + "人" //自推 0人裂变 0人
        jinri2.text = "裂变 " + model.groupToday + "人"
        
        zuori1.text = "自推 " + model.inviterYesterday + "人"
        zuori2.text = "裂变 " + model.groupYesterday + "人"
        
        benyue1.text = "自推 " + model.inviterMonth + "人"
        benyue2.text = "裂变 " + model.groupMonth + "人"
        
        shangyue1.text = "自推 " + model.inviterLastMonth + "人"
        shangyue2.text = "裂变 " + model.groupLastMonth + "人"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func fansButton(_ sender: UIButton) {
//        LNTeamDetailViewController
        let vc = LNTeamDetailViewController()
        vc.inviter_id = ""
        vc.userName = ""
        viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
