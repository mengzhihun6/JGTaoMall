//
//  BCTPasteSearchViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/8.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

@objc public protocol BCTPasteSearchViewControllerDelegate: NSObjectProtocol {
    @objc func delegateScroll(_ senderTag: Int,_ goods: SZYGoodsInformationModel)
    
    @objc func delegateScrollOrModel(_ senderTag: Int)
}

class BCTPasteSearchViewController: UIViewController {
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var bg_view1: UIView!
    @IBOutlet weak var quxiaoBun: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bg_iamgeView: UIImageView!
    @IBOutlet weak var goodsTitleLabel: UILabel!
    @IBOutlet weak var youhuiquanBun: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var chakanBun: UIButton!
    @IBOutlet weak var zhuanhuanBun: UIButton!
    @IBOutlet weak var fenxiangBun: UIButton!
    @IBOutlet weak var zhaoxiangsiBun: UIButton!
    @IBOutlet weak var zhidaoleBun: UIButton!
    @IBOutlet weak var zhidaoleBun1: UIButton!
    
    
    @IBOutlet weak var sousuo_View: UIView!
    @IBOutlet weak var sousuo_Neirong: UILabel!
    @IBOutlet weak var hulv_bun: UIButton!
    @IBOutlet weak var sousuoBiaoti_bun: UIButton!
    
    
    var Delegate : BCTPasteSearchViewControllerDelegate?
    
    var goods = SZYGoodsInformationModel()
    
    var typeString = ""    // 1,没有查询到商品信息  2,搜索商品
    var neirong = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if typeString == "1" {
            bg_view.isHidden = true
            quxiaoBun.isHidden = true
            sousuo_View.isHidden = true
            
            bg_view1.isHidden = false
        } else if typeString == "2" {
            bg_view.isHidden = true
            quxiaoBun.isHidden = true
            bg_view1.isHidden = true
            sousuo_Neirong.text = neirong
            
            sousuo_View.isHidden = false
        } else {
            bg_view.isHidden = false
            quxiaoBun.isHidden = false
            
            sousuo_View.isHidden = true
            bg_view1.isHidden = true
        }
        
        bg_view.clipsToBounds = true
        bg_view.cornerRadius = 8
        
        bg_view1.clipsToBounds = true
        bg_view1.cornerRadius = 8
        
        sousuo_View.clipsToBounds = true
        sousuo_View.cornerRadius = 8
        
        bg_iamgeView.sd_setImage(with: OCTools.getEfficientAddress(goods.pic_url), placeholderImage: UIImage.init(named: "goodImage_1"))
        goodsTitleLabel.text = goods.title
        youhuiquanBun.setTitle("  \(goods.coupon_price)元券  ", for: .normal)
        priceLabel.text = "¥\(goods.final_price)"
        oldPriceLabel.text = "¥\(goods.price)"
        
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            fenxiangBun.setTitle( "预计赚￥0.00", for: .normal)
        } else {
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(goods.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(goods.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            fenxiangBun.setTitle( "预计赚￥" + String.init(format:"%.2f",jieguo), for: .normal)
        }
        
        chakanBun.cornerRadius = chakanBun.height / 2.0
        chakanBun.clipsToBounds = true
        chakanBun.layer.borderColor = kSetRGBColor(r: 255, g: 68, b: 0).cgColor
        chakanBun.layer.borderWidth = 1.5
        chakanBun.backgroundColor = UIColor.clear
        chakanBun.setTitleColor(kSetRGBColor(r: 255, g: 68, b: 0), for: .normal)
        
        zhuanhuanBun.cornerRadius = zhuanhuanBun.height / 2.0
        zhuanhuanBun.clipsToBounds = true
        zhuanhuanBun.backgroundColor = kSetRGBColor(r: 255, g: 68, b: 0)
        zhuanhuanBun.setTitleColor(UIColor.white, for: .normal)
        
        fenxiangBun.cornerRadius = fenxiangBun.height / 2.0
        fenxiangBun.clipsToBounds = true
        fenxiangBun.layer.borderColor = kSetRGBColor(r: 255, g: 68, b: 0).cgColor
        fenxiangBun.layer.borderWidth = 1.5
        fenxiangBun.backgroundColor = UIColor.clear
        fenxiangBun.setTitleColor(kSetRGBColor(r: 255, g: 68, b: 0), for: .normal)
        
        zhaoxiangsiBun.cornerRadius = zhaoxiangsiBun.height / 2.0
        zhaoxiangsiBun.clipsToBounds = true
        zhaoxiangsiBun.layer.borderColor = kSetRGBColor(r: 255, g: 68, b: 0).cgColor
        zhaoxiangsiBun.layer.borderWidth = 1.5
        zhaoxiangsiBun.backgroundColor = UIColor.clear
        zhaoxiangsiBun.setTitleColor(kSetRGBColor(r: 255, g: 68, b: 0), for: .normal)
        
        zhidaoleBun.cornerRadius = zhidaoleBun.height / 2.0
        zhidaoleBun.clipsToBounds = true
        zhidaoleBun.backgroundColor = kSetRGBColor(r: 255, g: 68, b: 0)
        zhidaoleBun.setTitleColor(UIColor.white, for: .normal)
        
        zhidaoleBun1.cornerRadius = zhidaoleBun1.height / 2.0
        zhidaoleBun1.clipsToBounds = true
        zhidaoleBun1.backgroundColor = kSetRGBColor(r: 255, g: 68, b: 0)
        zhidaoleBun1.setTitleColor(UIColor.white, for: .normal)
        
        hulv_bun.cornerRadius = hulv_bun.height / 2.0
        hulv_bun.clipsToBounds = true
        hulv_bun.layer.borderColor = kSetRGBColor(r: 255, g: 68, b: 0).cgColor
        hulv_bun.layer.borderWidth = 1.5
        hulv_bun.backgroundColor = UIColor.clear
        hulv_bun.setTitleColor(kSetRGBColor(r: 255, g: 68, b: 0), for: .normal)
        
        sousuoBiaoti_bun.cornerRadius = sousuoBiaoti_bun.height / 2.0
        sousuoBiaoti_bun.clipsToBounds = true
        sousuoBiaoti_bun.backgroundColor = kSetRGBColor(r: 255, g: 68, b: 0)
        sousuoBiaoti_bun.setTitleColor(UIColor.white, for: .normal)
    }
    // 三个选择按钮点击事件
    @IBAction func bunClick(_ sender: UIButton) {
        kDeBugPrint(item: "按钮点击事件 tag 值 \(sender.tag)")
        self.dismiss(animated: false, completion: nil)
        if Delegate != nil {
            
            if sender.tag == 55 || sender.tag == 56 || sender.tag == 57 {
                Delegate?.delegateScrollOrModel(sender.tag)
            } else {
                Delegate?.delegateScroll(sender.tag, goods)
            }
        }
        
    }
    // 取消按钮点击事件
    @IBAction func quxiaoBunClick(_ sender: UIButton) {
        kDeBugPrint(item: "取消按钮")
        self.dismiss(animated: false, completion: nil)
    }
    // 标题搜索事件
    @IBAction func biaotiSousuo(_ sender: UIButton) {
//        200忽略 201搜索标题
        self.dismiss(animated: false, completion: nil)
        if Delegate != nil {
            if sender.tag == 201 {  //      setToast(str: "跳转搜索页面!")
                Delegate?.delegateScrollOrModel(sender.tag)
            } else {
                let pasteboard = UIPasteboard.general
                pasteboard.string = ""
            }
        }
        
    }
    
    
    
}
