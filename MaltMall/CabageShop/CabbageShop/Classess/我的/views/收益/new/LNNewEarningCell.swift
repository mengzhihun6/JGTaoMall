//
//  LNNewEarningCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNNewEarningCell: UITableViewCell {

    
    @IBOutlet weak var balance: UILabel! //余额
    
    @IBOutlet weak var withDraw: UIButton!
    
    @IBOutlet weak var yueJieSuan: UILabel!  //本月结算预收入
    @IBOutlet weak var lastYueJieSuan: UILabel! //上月结算预收入

    @IBOutlet weak var preIncom: UILabel! //今日预估收入
    @IBOutlet weak var lastPreIncom: UILabel!//今日总成交量

    @IBOutlet weak var centerView1: UIView!
    @IBOutlet weak var centerView2: UIView!

    @IBOutlet weak var bottomLabel1: UILabel!
    @IBOutlet weak var bottomLabel2: UILabel!
    @IBOutlet weak var bottomLabel3: UILabel!
    @IBOutlet weak var bottomLabel4: UILabel!
    @IBOutlet weak var bottomLabel5: UILabel!
    @IBOutlet weak var bottomLabel6: UILabel!
    @IBOutlet weak var bottomLabel7: UILabel!
    @IBOutlet weak var bottomLabel8: UILabel!
    
    @IBOutlet weak var bottmView1: UIView!
    @IBOutlet weak var bottmView2: UIView!

    @IBOutlet weak var selectBtn1: UIButton!
    @IBOutlet weak var selectBtn2: UIButton!
    @IBOutlet weak var selectBtn3: UIButton!
    @IBOutlet weak var selectBtn4: UIButton!
    @IBOutlet weak var selectBtn5: UIButton!

    @IBOutlet weak var underLine: UIView!
    
    fileprivate var selectIndex = NSInteger()
    fileprivate var lastButton : UIButton?

    var userModel : LNMemberModel?

    override func awakeFromNib() {//1
        super.awakeFromNib()

        withDraw.clipsToBounds = true
        withDraw.cornerRadius = 4
        withDraw.borderWidth = 2
        withDraw.borderColor = UIColor.white

        centerView1.cornerRadius = 8
        centerView1.layer.shadowColor = kGaryColor(num: 0).cgColor
        centerView1.layer.shadowOffset = CGSize.zero
        centerView1.layer.shadowOpacity = 0.2//阴影透明度，默认0
        centerView1.layer.shadowRadius = 2//阴影半径，默认3

        centerView2.cornerRadius = 8
        centerView2.layer.shadowColor = kGaryColor(num: 0).cgColor
        centerView2.layer.shadowOffset = CGSize.zero
        centerView2.layer.shadowOpacity = 0.2//阴影透明度，默认0
        centerView2.layer.shadowRadius = 2//阴影半径，默认3
        
        bottmView1.cornerRadius = 9

        bottmView2.cornerRadius = 10
        bottmView2.layer.shadowColor = kGaryColor(num: 0).cgColor
        bottmView2.layer.shadowOffset = CGSize.zero
        bottmView2.layer.shadowOpacity = 0.2//阴影透明度，默认0
        bottmView2.layer.shadowRadius = 3//阴影半径，默认3

        underLine.clipsToBounds = true
        underLine.cornerRadius = underLine.height/2

        self.backgroundColor = kGaryColor(num: 245)
    }

    @IBAction func withDrawAction(_ sender: Any) {
        let withDraw = LNWithdrawViewController()
        if userModel == nil {
            return
        }
        withDraw.model = userModel!
        viewContainingController()?.navigationController?.pushViewController(withDraw, animated: true)
        requestData(date_type: "today")

    }
    
    func setValues(model:LNMemberModel,benyue:String,lastMonth:String,todayIncome:String,todayCount:String) {//2
        
        userModel = model
        
        balance.text = model.credit1
        yueJieSuan.text = benyue
        if lastMonth.count == 0 {
            lastYueJieSuan.text = "0.00"
        }else{
            lastYueJieSuan.text = lastMonth
        }
        
        preIncom.text = todayIncome
        lastPreIncom.text = todayCount
        
        bottmView1.isUserInteractionEnabled = true
        requestData(date_type: "today")
    }
    
    
    @IBAction func selectAction(_ sender: UIButton) {
        
        if lastButton == nil {
            lastButton = selectBtn1
        }
        
        if sender == lastButton {
            return
        }
        sender.isSelected = true

        lastButton!.isSelected = false

        var date_type = ""
        
        switch sender.tag {
        case 101:
            date_type = "today"
            break
        case 102:
            date_type = "yesterday"
            break
        case 103:
            date_type = "week"
            break
        case 104:
            date_type = "month"
            break
        case 105:
            date_type = "lastMonth"
            break
        default:
            break
        }
        requestData(date_type: date_type)
        UIView.animate(withDuration: 0.3) {
            self.underLine.centerX = sender.centerX
        }
        selectIndex = sender.tag - 100
        lastButton = sender
    }
    
    func requestData(date_type:String)  {
        let request = SKRequest()
        request.setParam(date_type as NSObject, forKey: "date_type")
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        
        bottmView1.isUserInteractionEnabled = false
        request.callGET(withUrl: LNUrls().kShouyi) { (response) in
            
            DispatchQueue.main.async {
                 weakSelf?.bottmView1.isUserInteractionEnabled = true

                LQLoadingView().SVPHide()
                
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!)
                weakSelf?.bottomLabel1.text = datas["commission"]["commission1"].stringValue
                weakSelf?.bottomLabel3.text = datas["commission"]["commission2"].stringValue
                weakSelf?.bottomLabel5.text = datas["commission"]["groupCommission1"].stringValue
                weakSelf?.bottomLabel7.text = datas["commission"]["groupCommission2"].stringValue
                
                weakSelf?.bottomLabel2.text = datas["order"]["commissionOrder1"].stringValue
                weakSelf?.bottomLabel4.text = datas["order"]["commissionOrder2"].stringValue
                weakSelf?.bottomLabel6.text = datas["order"]["commissionGroup1"].stringValue
                weakSelf?.bottomLabel8.text = datas["order"]["commissionGroup2"].stringValue
            }
        }
        

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {//3
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
