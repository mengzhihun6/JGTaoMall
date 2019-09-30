//
//  LNNewPartnerCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/23.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNNewPartnerCell: UITableViewCell {

    
    @IBOutlet weak var quanyiView: UIView!
    @IBOutlet weak var quanyiHeight: NSLayoutConstraint!
    
    @IBOutlet weak var quanHeight: NSLayoutConstraint!
    
    @IBOutlet weak var groupValue: UIButton!
    @IBOutlet weak var nowMoney: UIButton!
    
    @IBOutlet weak var theValue: UILabel!
    @IBOutlet weak var theMoney: UILabel!
    
    
    @IBOutlet weak var backView1: UIView!
    
    @IBOutlet weak var backView2: UIView!

    @IBOutlet weak var goBtn: UIButton!
    
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var valueCenter: NSLayoutConstraint!
    
    @IBOutlet weak var nowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupValue.titleLabel?.numberOfLines = 2
        nowMoney.titleLabel?.numberOfLines = 2

        groupValue.titleLabel?.textAlignment = .center
        nowMoney.titleLabel?.textAlignment = .center
        
        groupValue.setTitle("100\n成长值", for: .normal)
        nowMoney.setTitle("10\n元", for: .normal)
        
        goBtn.cornerRadius = goBtn.height/2
        goBtn.clipsToBounds = true
        goBtn.backgroundColor = kGaryColor(num: 58)
        
        backView1.clipsToBounds = true
        backView1.cornerRadius = 15
        
        backView2.clipsToBounds = true
        backView2.cornerRadius = 15
        backView2.borderColor = kSetRGBColor(r: 241, g: 159, b: 70)
        backView2.borderWidth = 5
        endTime.textColor = kMainColor1()
        theValue.textColor = kMainColor1()
        theMoney.textColor = kMainColor1()
        /*
*/
    }
    
    
    var model = LNPartnerModel() {
        didSet {
            
            if model.price1 == "0.00" {
                nowMoney.isHidden = true
                valueCenter.constant = (kSCREEN_WIDTH-46)/4
                nowLabel.isHidden = true
                theMoney.isHidden = true
            }else{
                nowMoney.isHidden = false
                valueCenter.constant = 0
                nowLabel.isHidden = false
                nowLabel.isHidden = false
            }
            
            groupValue.setTitle(OCTools().getStrWithIntStr(model.credit)+"\n成长值", for: .normal)
            nowMoney.setTitle(model.price1+"\n元每月", for: .normal)
            
            var time = model.memberModel.expired_time
            if time.count == 0 {
                time = "永不过期"
            }
            
            endTime.text = "当前等级过期时间："+time
            
            theValue.text = OCTools().getStrWithIntStr(model.memberModel.credit3)
            theMoney.text = model.memberModel.credit1
            
            if Int(model.level)! > Int(model.memberModel.level.level)! {
                goBtn.isHidden = false
            }else{
                goBtn.isHidden = true
            }
            
            var items = ["购物免费领券省钱"]
            var values = [""]
            
            if model.is_commission == "1" {
                items.append("享受直推会员或者自购返佣的 "+OCTools().getStrWithIntStr(model.commission_rate1)+"%")
                items.append("享受直推超级会员返佣的 "+OCTools().getStrWithIntStr(model.commission_rate2)+"%")
                
                values.append(OCTools().getStrWithIntStr(model.commission_rate1)+"%")
                values.append(OCTools().getStrWithIntStr(model.commission_rate2)+"%")

                if model.is_group == "1"{
                    items.append("享受直属团队每笔订单返佣的 "+OCTools().getStrWithIntStr(model.group_rate1)+"%")
                    items.append("享受补贴团队每笔订单返佣的 "+OCTools().getStrWithIntStr(model.group_rate2)+"%")
                    
                    values.append(OCTools().getStrWithIntStr(model.group_rate1)+"%")
                    values.append(OCTools().getStrWithIntStr(model.group_rate2)+"%")
                }
            }
            if model.is_pid == "1" && model.is_group == "1" {
                items.append("可配置联盟独立推广位")
                values.append("")
            }
            setUpQuanyi(items: items, values: values)
        }
    }
    
    
    func setUpQuanyi(items:[String],values:[String]) {
        
        _ = quanyiView.subviews.map {
            $0.removeFromSuperview()
        }

        let kWidth = quanyiView.width-24
        let kHeight:CGFloat = 20
        for index in 0..<items.count {
            let label = UILabel.init(frame: CGRect.init(x: 12, y: kHeight*CGFloat(index), width: kWidth, height: kHeight))
            let text =  "\(index+1). "+items[index]
            let attributeText = NSMutableAttributedString.init(string:text)
            attributeText.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 188)], range: NSMakeRange(0, text.count))
            if values[index].count>0 {
                attributeText.addAttributes([NSAttributedStringKey.foregroundColor: kMainColor1()], range: NSMakeRange(text.count-values[index].count,values[index].count))
            }
            attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], range: NSMakeRange(0, text.count))
            label.attributedText = attributeText
            quanyiView.addSubview(label)
        }
        
        quanyiHeight.constant = 30+kHeight*CGFloat(items.count)+10
    }
    

    @IBAction func riseLevelAction(_ sender: UIButton) {
        if Int(OCTools().getStrWithIntStr(model.memberModel.credit3))! >= Int(OCTools().getStrWithIntStr(model.credit))! {
            
            let request = SKRequest.init()
            weak var weakSelf = self
            request.setParam(model.id as NSObject, forKey: "level_id")
            request.callGET(withUrl: LNUrls().kCheckUpgrade) { (response) in
                if !(response?.success)! {
                    return
                }
                setToast(str: "升级成功")
                NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LNChangePersonalInfo), object: self, userInfo: nil)
                weakSelf?.goBtn.isHidden = true
            }
            
        }else{
            
            if OCTools().getStrWithIntStr(model.price1) == "0" && OCTools().getStrWithIntStr(model.price2) == "0" {
                setToast(str: "您当前成长值不足")
            }else{
                let payVc = LNPayVipViewController()
                payVc.selectModel  = model
                viewContainingController()?.navigationController?.pushViewController(payVc, animated: true)
            }
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
