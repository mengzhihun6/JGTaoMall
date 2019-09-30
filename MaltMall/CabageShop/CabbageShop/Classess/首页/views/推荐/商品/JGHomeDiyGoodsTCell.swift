//
//  JGHomeDiyGoodsTCell.swift
//  CabbageShop
//
//  Created by 郭军 on 2019/8/29.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class JGHomeDiyGoodsTCellContentView: UIView {
   
    //    一定要weak，防止循环引用
    weak var superViewController : LNPageViewController?
    
    
    var Icon :UIImageView? //图片
    var TitleLbl:UILabel? //标题
    var CPriceLbl:UILabel? //现价
    var OPriceLbl:UILabel? //原价
    var Logo :UIImageView? //logo
    var LogoLbl:UILabel? //logo说明
    var GetMoenyLbl:UILabel? //约赚
    var IndexModel:SZYGoodsInformationModel?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configUI() {
        
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        
        
        Icon = UIImageView()
        Icon?.backgroundColor = UIColor.hex("#F2F2F2")
        
        
        TitleLbl = UILabel()
        TitleLbl?.textColor = UIColor.hex("#5D5D5D")
        TitleLbl?.font = UIFont.font(12)
        TitleLbl?.numberOfLines = 2
//        TitleLbl?.text = "不好吃上传上传白蛇传说不擅长不是是才好深V缓存办事处近几年"
        
        CPriceLbl = UILabel()
        CPriceLbl?.textColor = UIColor.hex("#DCBF9E")
        CPriceLbl?.font = UIFont.boldFont(12)
//        CPriceLbl?.text = "¥3850"
        
        OPriceLbl = UILabel()
        OPriceLbl?.textColor = UIColor.hex("#DBDBDB")
        OPriceLbl?.font = UIFont.font(11)
//        OPriceLbl?.text = "6850"
        
        
        Logo = UIImageView()
        Logo?.backgroundColor = UIColor.random
        
        LogoLbl = UILabel()
        LogoLbl?.textColor = UIColor.hex("#D3D3D3")
        LogoLbl?.font = UIFont.font(11)
//        LogoLbl?.text = "淘票票"
        
        GetMoenyLbl = UILabel()
        GetMoenyLbl?.layer.cornerRadius = 5.0
        GetMoenyLbl?.clipsToBounds = true
        GetMoenyLbl?.textAlignment = .center
        GetMoenyLbl?.backgroundColor = UIColor.hex("#F3D6B5")
        GetMoenyLbl?.textColor = UIColor.white
        GetMoenyLbl?.font = UIFont.font(11)
//        GetMoenyLbl?.text = "约赚 ¥2.21元"
        
        
        
        
        addSubview(Icon!)
        addSubview(TitleLbl!)
        addSubview(CPriceLbl!)
        addSubview(OPriceLbl!)
        addSubview(Logo!)
        addSubview(LogoLbl!)
        addSubview(GetMoenyLbl!)
        
        
        
        Icon?.snp.makeConstraints({ (make) in
            make.left.top.right.equalToSuperview().inset(5)
            make.height.equalTo(kWidthScale(163))
        })
        
        TitleLbl?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalTo(Icon!.snp_bottom).offset(10)
//            make.height.equalTo(33)
        })
        
        CPriceLbl?.snp.makeConstraints({ (make) in
            make.left.equalTo(TitleLbl!.snp_left)
            make.top.equalTo(Icon!.snp_bottom).offset(48)
        })
        
        OPriceLbl?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().inset(5)
            make.centerY.equalTo(CPriceLbl!.snp_centerY)
        })
        
        Logo?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().inset(5)
            make.centerY.equalTo(GetMoenyLbl!.snp_centerY)
            make.width.height.equalTo(18)
        })
        
        LogoLbl?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(Logo!.snp_centerY)
            make.left.equalTo(Logo!.snp_right).offset(3)
        })
        
        GetMoenyLbl?.snp.makeConstraints({ (make) in
            make.right.bottom.equalToSuperview().inset(10)
            make.width.equalTo(kWidthScale(80))
            make.height.equalTo(20)
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        //通过numberOfTouchesRequired属性设置触摸点数，比如设置2表示必须两个手指触摸时才会触发
        tap.numberOfTapsRequired = 1
        //通过numberOfTapsRequired属性设置点击次数，单击设置为1，双击设置为2
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    //点击手势
    @objc func tapClick() {
        
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = IndexModel!.item_id
        detailVc.coupone_type = IndexModel!.type
        detailVc.goodsUrl = IndexModel!.pic_url
        detailVc.GoodsInformationModel = IndexModel!
        superViewController?.navigationController?.pushViewController(detailVc, animated: true)
        
    }
    
    func setUpModel(model: SZYGoodsInformationModel) {
        
        IndexModel = model
        
        Icon!.sd_setImage(with: OCTools.getEfficientAddress(model.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))

        TitleLbl!.text = model.title
        
        if model.type == "1" { //1淘宝 2京东 3拼多多
            if model.shop_type == "1" {  //1淘宝 2天猫
                Logo!.image = UIImage.init(named: "miaosha_mark")
            } else if model.shop_type == "2" {
                Logo!.image = UIImage.init(named: "tianmao_icon")
            }
        } else if model.type == "2" {
            Logo!.image = UIImage.init(named: "京东")
        } else if model.type == "3" {
            Logo!.image = UIImage.init(named: "拼多多")
        }
        
        LogoLbl!.text = model.nick
        CPriceLbl!.text = "¥" + OCTools().getStrWithFloatStr2(model.final_price)
        
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            GetMoenyLbl!.isHidden = true
        } else {
            GetMoenyLbl!.isHidden = false
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(model.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            
            GetMoenyLbl!.text = "  约赚\(String(format: "%.2f", jieguo))  "
        }
        OPriceLbl!.text = "¥" + OCTools().getStrWithFloatStr2(model.price)
//        salesLabel.text = "销量\(model.volume)"
    }
    
    
}






class JGHomeDiyGoodsTCell: UITableViewCell {

    var LV:JGHomeDiyGoodsTCellContentView?
    var RV:JGHomeDiyGoodsTCellContentView?

    //    一定要weak，防止循环引用
    weak var superViewController : LNPageViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        configUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configUI() {
        
        self.backgroundColor = UIColor.hex("#F2F2F2")
        
        
        LV = JGHomeDiyGoodsTCellContentView()
        
        
        RV = JGHomeDiyGoodsTCellContentView()
        
        
        self.contentView.addSubview(LV!)
        self.contentView.addSubview(RV!)

        
        let ViewWidth = (kDeviceWidth - 30) / 2.0
        
        
        LV?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(kWidthScale(163) + 110)
            make.width.equalTo(ViewWidth)
        })
        
        RV?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().inset(10)
            make.width.centerY.height.equalTo(LV!)
        })
        
        
    }
    
      func setUpArrM(arrM: NSMutableArray) {
     
        if arrM.count == 2 {
            let model1 = arrM.firstObject
            let model2 = arrM.lastObject

            RV?.isHidden = false

            LV?.setUpModel(model: model1 as! SZYGoodsInformationModel)
            RV?.setUpModel(model: model2 as! SZYGoodsInformationModel)

            
        }else {
            
            RV?.isHidden = true
            let model1 = arrM.firstObject
            LV?.setUpModel(model: model1 as! SZYGoodsInformationModel)
        }
        
        LV!.superViewController = superViewController
        RV!.superViewController = superViewController
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
