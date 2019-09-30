//
//  LNPartnerEquityHeadCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNPartnerEquityHeadCell: UITableViewCell {

    
    @IBOutlet weak var head_height: NSLayoutConstraint!
    @IBOutlet weak var head_bgImage: UIImageView!
    
    @IBOutlet weak var levelName: UILabel!

    
    @IBOutlet weak var center_bgImage: UIImageView!
    @IBOutlet weak var center_bgView: UIView!
    
    @IBOutlet weak var vip_level3: UILabel!
    
    @IBOutlet weak var levelView: UIScrollView!
    
    @IBOutlet weak var quayiView: UIView!
    @IBOutlet weak var quanyiHeight: NSLayoutConstraint!
    
    
    var mineButton = UIButton()
    var myModel = LNPartnerModel()
    var theModels = [LNPartnerModel]()
    var mineModel = LNMemberModel()
    var selectIndex = 0
    
    //    回调
    typealias swiftBlock = (_ aliNum:NSInteger, _ realName:String) -> Void
    var willClick : swiftBlock? = nil
    @objc func callKeywordBlock(block: @escaping (_ aliNum:NSInteger, _ realName:String) -> Void ) {
        willClick = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if kSCREEN_HEIGHT>800 {
            head_height.constant = 190
        }
        
        center_bgImage.layer.cornerRadius = 8
        center_bgImage.clipsToBounds = true
        
        center_bgView.layer.cornerRadius = 8
        center_bgView.clipsToBounds = true
        
        center_bgImage.image = getNavigationIMG(Int(center_bgImage.height), fromColor: kSetRGBColor(r: 194, g: 158, b: 96), toColor: kSetRGBColor(r: 229, g: 194, b: 130))
    }
    
    
    func setupValues(models:[LNPartnerModel],model:LNMemberModel,selet:NSInteger) {
        mineModel = model
        levelName.text = model.level.name
        vip_level3.text = "尊贵的"+model.level.name+".你享有以下权益"
        theModels = models
        _ = levelView.subviews.map {
            $0.removeFromSuperview()
        }
        
        let kWidth:CGFloat = 20
        
        let kSpace = (kSCREEN_WIDTH-56-3*kWidth)/3
        
        levelView.contentSize = CGSize(width: (kSpace+kWidth)*CGFloat(models.count)+kSpace, height: levelView.height)
        
        let cenertLine = UIView.init(frame: CGRect(x: 0, y: 0, width: levelView.contentSize.width , height: 4))
        cenertLine.backgroundColor = kSetRGBColor(r: 177, g: 144, b: 84)
        cenertLine.centerY = levelView.centerY
        levelView.addSubview(cenertLine)
        
        for index in 0..<models.count {
            
            if models[index].id == model.level.id {
                myModel = models[index]
                let headImage = UIButton.init(frame: CGRect(x: kSpace+(kWidth+kSpace)*CGFloat(index)-10, y: 0, width: 40, height: 40))
                headImage.sd_setBackgroundImage(with: OCTools.getEfficientAddress(model.headimgurl), for: .normal, completed: nil)
                headImage.cornerRadius = 20
                headImage.clipsToBounds = true
                headImage.centerY = levelView.centerY
                headImage.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
                levelView.addSubview(headImage)
                if selet == 10 {
                    mineButton = headImage
                }else{
                    if selet == index {
                        mineButton = headImage
                    }
                }
                let levelMark = UIButton.init(frame: CGRect(x: kSpace+(kWidth+kSpace)*CGFloat(index)+20, y: 10, width: kWidth, height: kWidth))
                levelMark.centerY = levelView.centerY+20
                levelMark.setImage(UIImage.init(named: "hehuo_v"+models[index].level+"_yes"), for: .normal)
                levelMark.setBackgroundImage(UIImage.init(named: "hehuo_vip_yes"), for: .normal)
//                levelMark.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
                headImage.tag = index+10
//                levelMark.tag = index+10
                levelView .addSubview(levelMark)
                
            }else{
                let levelMark = UIButton.init(frame: CGRect(x: kSpace+(kWidth+kSpace)*CGFloat(index), y: -10, width: kWidth, height: kWidth))
                var string = "_no"
                levelMark.setBackgroundImage(UIImage.init(named: "hehuo_vip_yes"), for: .normal)
                
                if model.level.level.count > 0 {
                    if Int(models[index].level)! < Int(model.level.level)! {
                        string = "_yes"
                        levelMark.setBackgroundImage(UIImage.init(named: "hehuo_vip_no"), for: .normal)
                    }
                }
                
                levelMark.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
                levelMark.setImage(UIImage.init(named: "hehuo_v"+models[index].level+string), for: .normal)
                levelMark.centerY = levelView.centerY
                levelMark.tag = index+10
                if selet != 10 && selet == index {
                    mineButton = levelMark
                }
                levelView.addSubview(levelMark)
            }
            
        }
        goodAtProject(sender: mineButton)
        
        if selet == 10 {
            layoutButtons(model: myModel)
        }else{
            layoutButtons(model: theModels[selet])
        }

    }
    
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        if selectIndex == sender.tag || sender.tag == 0{
            return
        }
        
        kDeBugPrint(item: sender.tag)
        
        let button = levelView.viewWithTag(sender.tag)!
        
        weak var weakSelf = self
        
        UIView.animate(withDuration: 0.3, animations: {
            if button.centerX > self.levelView.width/2 && (weakSelf?.levelView.contentSize.width)!-button.centerX > self.levelView.width/2{
                weakSelf?.levelView.contentOffset = CGPoint(x: button.centerX-self.levelView.width/2, y: 0)
            }else{
                if button.centerX < self.levelView.width/2 {
                    weakSelf?.levelView.contentOffset = CGPoint(x: 0, y: 0)
                }else{
                    weakSelf?.levelView.contentOffset = CGPoint(x: (weakSelf?.levelView.contentSize.width)!-self.levelView.width, y: 0)
                }
            }
        }) { (flag) in
//            if self.willClick != nil {
//                self.willClick!(sender.tag-10,"")
//            }
        }
        selectIndex = sender.tag
        layoutButtons(model: theModels[sender.tag-10])
    }
    
    func layoutButtons(model:LNPartnerModel) {
        
        _ = quayiView.subviews.map {
            $0.removeFromSuperview()
        }

        var items = ["会员价","会员日活动"]
        
        if model.is_commission == "0" {
            items.append("领券省钱")
        }else if model.is_commission == "1" {
            if model.is_group == "1"{
                items.append("团队提成"+OCTools().getStrWithIntStr(model.commission_rate1)+"%")
                items.append("补贴提成"+OCTools().getStrWithIntStr(model.commission_rate2)+"%")
            }else{
                items.append("自购提成"+OCTools().getStrWithIntStr(model.commission_rate1)+"%")
                items.append("下级提成"+OCTools().getStrWithIntStr(model.commission_rate2)+"%")
            }
        }
        
        let kSpace = CGFloat(0)
        var kWidth = CGFloat()
        kWidth = (kSCREEN_WIDTH-32)/4
        let kHeight = kWidth
        let lines = 4
        var height:CGFloat = 0
        
        //MARK: 根据图片的数量进行排列
        for index in 0..<items.count{
            let row =  CGFloat(index%lines)
            
            let quanyiBtn = UIButton.init(frame: CGRect(x:(kWidth + kSpace) * row, y:(kSpace+kHeight)*CGFloat(index/lines), width: kWidth, height: kHeight))
            quanyiBtn.setImage(UIImage.init(named: "hehuo_back_money"), for: .normal)
            quanyiBtn.setTitle(items[index], for: .normal)
            quanyiBtn.tag = 170 + index
            quanyiBtn.setTitleColor(kGaryColor(num: 50), for: .normal)
            quanyiBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            quanyiBtn.layoutButton(with: .top, imageTitleSpace: 5)
            quayiView.addSubview(quanyiBtn)
            if row == 0 {
                height = height+kSpace+kHeight
            }
        }
        quanyiHeight.constant = height
        mineModel.height = 256+height
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
