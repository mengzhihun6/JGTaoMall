//
//  LNGoodDetailNoSuperVipCell.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/3.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class LNGoodDetailNoSuperVipCell: UITableViewCell {
   
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var quanhou_price: UILabel!
    
    @IBOutlet weak var UpGradeLbl: UILabel!
    
    @IBOutlet weak var UpGradeBg: UIView!
    
    @IBOutlet weak var quanPriceBtn: UIButton!
    
    
    @IBOutlet weak var noew_price: UILabel!
//    @IBOutlet weak var old_price: UILabel!
    
    @IBOutlet weak var good_title: UILabel!
    
//    @IBOutlet weak var coupon_price: UILabel!
//
//    @IBOutlet weak var quan_date: UILabel!

    @IBOutlet weak var sale_count: UILabel!
    
    @IBOutlet weak var markIamge: UIButton!
    var banner = ADView()
    
//    @IBOutlet weak var quanhou: UILabel!
//
//
//    @IBOutlet weak var text11: UILabel!
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    
    @IBOutlet weak var storeDes1: UILabel!
//    @IBOutlet weak var storeDes: UILabel!
    @IBOutlet weak var storeService1: UILabel!
//    @IBOutlet weak var storeService: UILabel!
    @IBOutlet weak var storePost1: UILabel!
//    @IBOutlet weak var storePost: UILabel!

    @IBOutlet weak var botomView: UIView!
    @IBOutlet weak var shopLevel: UIButton! //进店逛逛
    
    @IBOutlet weak var downloadImage: UIButton!
    var coupon_Type = String()
    
    
//    @IBOutlet weak var getVipView: UIView!
//    @IBOutlet weak var disCountMoney: UILabel!
//    @IBOutlet weak var lingquBtn: UILabel!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    
//    @IBOutlet weak var VIPTopHeight: NSLayoutConstraint!
//    @IBOutlet weak var getVipViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var quanEBun: UIButton!
//    @IBOutlet weak var ButtonTopHeight: NSLayoutConstraint!
//    @IBOutlet weak var ButtonHeight: NSLayoutConstraint!
//    @IBOutlet weak var ButtonBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var yuGuZhuanBun: UIButton!
//    @IBOutlet weak var botomHeight: NSLayoutConstraint!
//    @IBOutlet weak var botomTopHeight: NSLayoutConstraint!
    
    var StoreModel = SZYStoreInformationModel()
    var GoodsModel = SZYGoodsInformationModel()
    //   领券 回调
    typealias swiftBlock = (_ phoneNum:String) -> Void
    var willClick : swiftBlock? = nil
    func callBackPhoneNum(block: @escaping ( _ phoneNum:String) -> Void ) {
        willClick = block
    }
    //   保存图片 回调
    typealias saveBlock = (_ phoneNum:String) -> Void
    var savewillClick : saveBlock? = nil
    func saveCallBackPhoneNum(block: @escaping ( _ phoneNum:String) -> Void ) {
        savewillClick = block
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        topViewHeight.constant = kSCREEN_WIDTH
        
        storeImage.cornerRadius = 3
        storeImage.clipsToBounds = true
        
        shopLevel.cornerRadius = shopLevel.height / 2.0
        shopLevel.clipsToBounds = true
        
        downloadImage.contentHorizontalAlignment = .right
        downloadImage.layoutButton(with: .left, imageTitleSpace: 3)
        
        
        
//        VIPTopHeight.constant = 0
//        getVipViewHeight.constant = 0
        
//        let maskPath1 = UIBezierPath.init(roundedRect: downloadImage.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.bottomLeft.rawValue)|UInt8(UIRectCorner.topLeft.rawValue))), cornerRadii: CGSize(width: downloadImage.height / 2.0, height: downloadImage.height / 2.0))
//
//        let maskLayer1 = CAShapeLayer.init()
//        maskLayer1.frame = downloadImage.bounds
//        maskLayer1.path = maskPath1.cgPath
//        downloadImage.layer.mask = maskLayer1
        
//        downloadImage.cornerRadius = downloadImage.height / 2.0
//        downloadImage.clipsToBounds = true
    }

//    没用到
    @IBAction func pushToMember(_ sender: Any) {
        viewContainingController()!.navigationController?.popToViewController((viewContainingController()?.navigationController?.childViewControllers[0])!, animated: true)
        
        if viewContainingController()!.tabBarController?.selectedIndex != 1 {
            let time: TimeInterval = 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                
                let tabbar = UIApplication.shared.keyWindow?.rootViewController as? LNMainTabBarController
                tabbar?.selectedIndex = 1
            }
        }
    }
    
    @IBAction func collectionList(_ sender: UIButton) {
        kDeBugPrint(item: "收藏列表")
    }
    func setUpUserInfo(GoodsInformationModel:SZYGoodsInformationModel, StoreInformationModel:SZYStoreInformationModel) {
        StoreModel = StoreInformationModel
        GoodsModel = GoodsInformationModel
        banner.removeFromSuperview()
        if GoodsInformationModel.images.count>0 {
            let imageUrls =  NSMutableArray.init(array: GoodsInformationModel.images)
            
            banner = ADView.init(
                frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_WIDTH),
                andImageURLArray: imageUrls,
                andIsRunning: false)
            bannerView.insertSubview(banner, at: 0)
            
            banner.snp.makeConstraints { (ls) in
                ls.left.right.top.bottom.equalToSuperview()
            }
        }
        
        quanPriceBtn.setTitle("  " + OCTools().getStrWithIntStr(GoodsInformationModel.coupon_price) + "元券  ", for: .normal)
        
        if Defaults[kCommissionRate] == "0" || Defaults[kCommissionRate] == nil {
            yuGuZhuanBun.isHidden = true
        } else {
            yuGuZhuanBun.isHidden = false
            
            kDeBugPrint(item: GoodsInformationModel.final_price)
            kDeBugPrint(item: GoodsInformationModel.commission_rate)
            
            let jieguo = (1 - StringToFloat(str: Defaults[kSystemDeduct]!) / 100) * StringToFloat(str: OCTools().getStrWithFloatStr2(GoodsInformationModel.final_price)) * StringToFloat(str: OCTools().getStrWithFloatStr2(GoodsInformationModel.commission_rate)) / 100 * StringToFloat(str: Defaults[kCommissionRate]!) / 100
            yuGuZhuanBun.setTitle("  预计赚￥" + String.init(format:"%.2f",jieguo) + "  ", for: .normal)
        }
        
        
//        if Defaults[kIsSuper_VIP] == "true" {
//
//            UpGradeBg.isHidden = true
//            UpGradeLbl.isHidden = true
//        }else {
//
//            UpGradeBg.isHidden = false
//            UpGradeLbl.isHidden = false
//        }
//
        
        UpGradeLbl.text = "升级赚\n￥" +  GoodsInformationModel.next_commission

        
        
        let attrStr1 = NSAttributedString(string: "  \(GoodsInformationModel.title)", attributes: [NSAttributedStringKey.foregroundColor : kSetRGBColor(r: 17, g: 17, b: 17)])
        // 图文混排
        let attacment = NSTextAttachment()
        if GoodsInformationModel.type == "1" {
            if GoodsInformationModel.shop_type == "1" {
                attacment.image = UIImage(named: "miaosha_mark")   // 设置要显示的图片
            } else if GoodsInformationModel.shop_type == "2" {
                attacment.image = UIImage(named: "tianmao_icon")   // 设置要显示的图片
            }
        } else if GoodsInformationModel.type == "2" {
            attacment.image = UIImage(named: "jd_mark")   // 设置要显示的图片
        } else if GoodsInformationModel.type == "3" {
            attacment.image = UIImage(named: "pdd_mark")   // 设置要显示的图片
        }
        attacment.bounds = CGRect(x: 0, y: -4, width: good_title.font.lineHeight, height: good_title.font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attacment)     // 设置图片显示的大小及位置
        // 拼接图文
        let attrMStr = NSMutableAttributedString()
        attrMStr.append(attrImageStr)
        attrMStr.append(attrStr1)
        // 显示属性字符串
        good_title.attributedText = attrMStr
        
        
        noew_price.text = "¥" + OCTools().getStrWithFloatStr2(GoodsInformationModel.final_price)
//        old_price.text =  "￥"+OCTools().getStrWithFloatStr2(GoodsInformationModel.price)
////        优惠券金额为0，优惠券显示相关的都隐藏
//        if OCTools().getStrWithIntStr(GoodsInformationModel.coupon_price) == "0" {
//            coupon_price.isHidden = true
//            quan_date.isHidden = true
//            text11.isHidden = true
//            lingquBtn.isHidden = true
//            ButtonHeight.constant = 0
//        }else{
//            coupon_price.isHidden = false
//            quan_date.isHidden = false
//            text11.isHidden = false
//            ButtonHeight.constant = 90
//            lingquBtn.isHidden = false
//            coupon_price.text = OCTools().getStrWithIntStr(GoodsInformationModel.coupon_price)+"元优惠券"
//            quan_date.text = "使用期限："+GoodsInformationModel.coupon_start_time.prefix(10)+" -- "+GoodsInformationModel.coupon_end_time.prefix(10)
//        }
        sale_count.text = OCTools().getStrWithIntStr(GoodsInformationModel.volume) + "人已买"
        kDeBugPrint(item: GoodsInformationModel.finalCommission)
        
//        店铺信息
        weak var weakSelf = self
        if StoreInformationModel.shopIcon.contains("http") {
            weakSelf?.storeImage.sd_setImage(with: OCTools.getEfficientAddress(StoreInformationModel.shopIcon), placeholderImage: UIImage.init(named: "goodImage_1"))
        } else {
            weakSelf?.storeImage.sd_setImage(with: OCTools.getEfficientAddress("https:"+StoreInformationModel.shopIcon), placeholderImage: UIImage.init(named: "goodImage_1"))
        }
        weakSelf?.storeName.text = StoreInformationModel.shopName
        
        let arr = StoreInformationModel.evaluates
        if arr.count>0 {
            weakSelf?.storeDes1.text = arr[0].title
//            weakSelf?.storeDes.text = arr[0].score+" "+arr[0].levelText
            
            kDeBugPrint(item: arr[0].title)
            kDeBugPrint(item: arr[0].score+" "+arr[0].levelText)
        }
        if arr.count>1 {
            weakSelf?.storeService1.text = arr[1].title
//            weakSelf?.storeService.text = arr[1].score+" "+arr[1].levelText
        }
        if arr.count>2 {
            weakSelf?.storePost1.text = arr[2].title
//            weakSelf?.storePost.text = arr[2].score+" "+arr[2].levelText
        }
    }
    
    public var model : LNYHQDetailModel = LNYHQDetailModel() {
        didSet {
            
            switch model.user_type {
            case "1":
                markIamge.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
            case "0":
                markIamge.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
            default:
                break
            }
            
            banner.removeFromSuperview()
            
            if model.small_images.count>0 {
                let imageUrls =  NSMutableArray.init(array: model.small_images)
                
                banner = ADView.init(
                    frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_WIDTH),
                    andImageURLArray: imageUrls,
                    andIsRunning: false)
                bannerView.insertSubview(banner, at: 0)
                
                banner.snp.makeConstraints { (ls) in
                    ls.left.right.top.bottom.equalToSuperview()
                }
            }
            quanPriceBtn.setTitle("  " + OCTools().getStrWithIntStr(model.coupon_price) + "元券  ", for: .normal)
            if OCTools().getStrWithFloatStr2(model.finalCommission) != "0" && OCTools().getStrWithFloatStr2(model.finalCommission) != "0.00"{
                yuGuZhuanBun.isHidden = false
                yuGuZhuanBun.setTitle("  预估赚￥"+OCTools().getStrWithFloatStr2(model.finalCommission)+"  ", for: .normal)
            }else{
                yuGuZhuanBun.isHidden = true
            }

            good_title.text =  model.title
            
            noew_price.text =  OCTools().getStrWithFloatStr2(model.final_price)
//            old_price.text =  "￥"+OCTools().getStrWithFloatStr2(model.price)
            
//            优惠券金额为0，优惠券显示相关的都隐藏
//            if OCTools().getStrWithIntStr(model.coupon_price) == "0" {
//                coupon_price.isHidden = true
//                quan_date.isHidden = true
//                text11.isHidden = true
//                lingquBtn.isHidden = true
//                ButtonHeight.constant = 0
//            }else{
//                coupon_price.isHidden = false
//                quan_date.isHidden = false
//                text11.isHidden = false
//                ButtonHeight.constant = 90
//                lingquBtn.isHidden = false
//
//                coupon_price.text = OCTools().getStrWithIntStr(model.coupon_price)+"元优惠券"
//                quan_date.text = "使用期限："+model.coupon_start_time+" -- "+model.coupon_end_time
//            }

            sale_count.text = OCTools().getStrWithIntStr(model.volume) + "人已买"
            
            if model.finalCommission.count == 0 {
                return
            }
            

//            店铺信息
            if model.data == nil {
                return
            }
            weak var weakSelf = self
            let data = model.data!["data"]["seller"]
            weakSelf?.storeImage.sd_setImage(with: OCTools.getEfficientAddress("https:"+data["shopIcon"].stringValue), placeholderImage: UIImage.init(named: "goodImage_1"))
            weakSelf?.storeName.text = data["shopName"].stringValue
            
            let arr = data["evaluates"].arrayValue
            if arr.count>0 {
                weakSelf?.storeDes1.text = arr[0]["title"].stringValue
//                weakSelf?.storeDes.text = arr[0]["score"].stringValue+" "+arr[0]["levelText"].stringValue
            }
            if arr.count>1 {
                weakSelf?.storeService1.text = arr[1]["title"].stringValue
//                weakSelf?.storeService.text = arr[1]["score"].stringValue+" "+arr[1]["levelText"].stringValue
            }
            if arr.count>2 {
                weakSelf?.storePost1.text = arr[2]["title"].stringValue
//                weakSelf?.storePost.text = arr[2]["score"].stringValue+" "+arr[2]["levelText"].stringValue
            }

        }
    }

    
    
    
    
    func setmark(type:String) {
        coupon_Type = type
        if type != "1" && type != "10"{
//            botomHeight.constant = 0
//            botomTopHeight.constant = 0
            botomView.isHidden = true
        }else{
//            botomHeight.constant = 110
//            botomTopHeight.constant = 20
            botomView.isHidden = false
        }
        weak var weakSelf = self
        if coupon_Type == "1" {
//            weakSelf?.shopLevel.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//            leadingSpace.constant = -50
        }else{
//            weakSelf?.shopLevel.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.5)
//            leadingSpace.constant = -68
        }

//        switch type {
//        case "10":
//            markIamge.setImage(UIImage.init(named: "tianmao_icon"), for: .normal)
//        case "1":
//            markIamge.setImage(UIImage.init(named: "miaosha_mark"), for: .normal)
//        case "2":
//            markIamge.setImage(UIImage.init(named: "jd_mark"), for: .normal)
//        default:
//            markIamge.setImage(UIImage.init(named: "pdd_mark"), for: .normal)
//        }
    }
        
//    领券
    @IBAction func lingquan(_ sender: Any) {
        if willClick != nil {
            willClick!("")
        }
    }
    
    
    @IBAction func get_supervipAction(_ sender: UIButton) {
        viewContainingController()?.navigationController?.pushViewController(LNPartnerEquityViewController(), animated: true)
    }
    
    
    @IBAction func saveImage(_ sender: Any) {
        if savewillClick != nil {
            savewillClick!("")
        }
        
        /*
        if GoodsModel.images.count == 0 {
            setToast(str: "对不起，暂无图片")
            return
        }
        
        for urlStr in GoodsModel.images {
            let data = try! Data.init(contentsOf: URL.init(string: urlStr)!)
            let image = UIImage.init(data: data as Data)
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        */
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            setToast(str: "已保存")
        }
    }

    @IBAction func shopInBunClick(_ sender: UIButton) { //进店逛逛
       /*   跳转自己写的web页面     */
        var pageUrl = "https://shop.m.taobao.com/shop/shop_index.htm?user_id="+StoreModel.userId
        if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
            if !pageUrl.contains(Defaults[kUserToken]!) {
                if !pageUrl.contains("?") {
                    pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
                } else {
                    pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
                }
            }
        }
        
        let page = AlibcTradePageFactory.page(pageUrl)
        let taoKeParams = AlibcTradeTaokeParams.init()
        taoKeParams.pid = nil
        let showParam = AlibcTradeShowParams.init()
        showParam.openType = .auto
        let myView = SZYwebViewViewController.init()
        myView.typeString = "1"
//        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//
//        }, tradeProcessFailedCallback: { (error) in
//
//        })
//        if (ret == 1) {
//            let nav = LNNavigationController.init(rootViewController: myView)
//            nav.isNavigationBarHidden = true
//            viewContainingController()?.present(nav, animated: true, completion: nil)
//        }
        
        let ret = AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
        }, tradeProcessFailedCallback: { (error) in
        })
        if (ret == 1) {
                        let nav = LNNavigationController.init(rootViewController: myView)
                        nav.isNavigationBarHidden = true
                        viewContainingController()?.present(nav, animated: true, completion: nil)
                    }
    }
    
    
    func getTaokeParam() -> AlibcTradeTaokeParams {
        if ALiTradeSDKShareParam.sharedInstance().isUseTaokeParam {
            let taoke = AlibcTradeTaokeParams.init()
            taoke.pid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "pid") as? String
            taoke.subPid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "subPid") as? String
            taoke.unionId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "unionId") as? String
            taoke.adzoneId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "adzoneId") as? String
            taoke.extParams = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "extParams") as? [AnyHashable : Any]
            return taoke
        }else{
            return AlibcTradeTaokeParams()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
