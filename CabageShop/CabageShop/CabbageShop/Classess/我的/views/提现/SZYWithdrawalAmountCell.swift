//
//  SZYWithdrawalAmountCell.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/16.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit

class SZYWithdrawalAmountCell: UITableViewCell {

    @IBOutlet weak var tixianTextField: UITextField!
    @IBOutlet weak var shouxufeiLabel: UILabel!
    @IBOutlet weak var ketixianLabel: UILabel!
    @IBOutlet weak var qunbutixianBun: UIButton!
    @IBOutlet weak var lijitixianBun: UIButton!
    
    var userModel : SZYPersonalCenterModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tixianTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func quanbutixianBunClick(_ sender: UIButton) {
        kDeBugPrint(item: "全部提现")
        tixianTextField.text = userModel?.credit1
        lijitixianBun.backgroundColor = kSetRGBColor(r: 239, g: 6, b: 93)
    }
    var model = SZYPersonalCenterModel() {
        didSet {
//            alipay_account.text = model.alipay
//            user_name.text = model.realname
//            max_count.text = "可提现 "+model.credit1
        }
    }
    func setUpUserInfo(model:SZYPersonalCenterModel, chart:SZYChartModel) {
        userModel = model
        
        ketixianLabel.text = "可提现"+model.credit1
        
    }
    @IBAction func lijitixianBunClick(_ sender: UIButton) {
        kDeBugPrint(item: "立即提现")
    }
    
    
}
extension SZYWithdrawalAmountCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        kDeBugPrint(item: "666")
        kDeBugPrint(item: textField.text)
        if StringToFloat(str: OCTools().getStrWithFloatStr2(textField.text)) > 5.0 {
            lijitixianBun.backgroundColor = kSetRGBColor(r: 239, g: 6, b: 93)
        } else {
            lijitixianBun.backgroundColor = kSetRGBColor(r: 200, g: 200, b: 200)
        }
        
        return true
    }
    func StringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string) {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
        
    }
}
