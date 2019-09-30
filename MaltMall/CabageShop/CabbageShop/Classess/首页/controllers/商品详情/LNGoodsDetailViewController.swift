//
//  LNGoodsDetailViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/3.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import JDKeplerSDK
import SwiftyUserDefaults
class LNGoodsDetailViewController: LNBaseViewController {

    @IBOutlet weak var collection_mark: UIButton!  //这个没使用
    @IBOutlet weak var collection_label: UIButton! //收藏bun
    
    @IBOutlet weak var bootomView: UIView! //底部View
    
    @IBOutlet weak var share_btn: UIButton! //分享按钮
    @IBOutlet weak var get_btn: UIButton! //购买按钮
    
    fileprivate var yhqModel : LNYHQDetailModel?
    
    var listModel = LNYHQListModel()

    
    var guessModels = [LNYHQListModel]()
    
    var isSuper_VIP = false
    var good_item_id = String()
    var coupone_type = String()

    let identyfierTable1  = "identyfierTable1"
    let identyfierTable2  = "identyfierTable2"

    let alpha:CGFloat = 0.8
    
    fileprivate var isWillDis:Bool = false

    var selectIndex = NSInteger()
    
    var storeData : JSON?
    
    var htmlStrs = [String]()

    //    顶部选择
    fileprivate var topView = LNTopSelectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collection_mark.setTitleColor(kGaryColor(num: 110), for: .normal)
//
////        之前怕悲剧，写了个时间判断
//        if !OCTools().judgeTimeByStartAndEnd() {
//            get_btn.setTitle("分享商品", for: .normal)
//        }else{
//            get_btn.setTitle("分享朋友", for: .normal)
//        }
//
////        切按钮圆角
//        let maskPath = UIBezierPath.init(roundedRect: get_btn.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topRight.rawValue)|UInt8(UIRectCorner.bottomRight.rawValue))), cornerRadii: CGSize(width: 3, height: 3))
//
//        let maskLayer = CAShapeLayer.init()
//        maskLayer.frame = get_btn.bounds
//        maskLayer.path = maskPath.cgPath
//        get_btn.layer.mask = maskLayer
//        get_btn.setBackgroundImage(getNavigationIMG(Int(share_btn.height), fromColor: kSetRGBColor(r: 252, g: 67, b: 67), toColor: kSetRGBColor(r: 255, g: 86, b: 86)), for: .normal)
//
//        let maskPath1 = UIBezierPath.init(roundedRect: share_btn.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.bottomLeft.rawValue)|UInt8(UIRectCorner.topLeft.rawValue))), cornerRadii: CGSize(width:3, height: 3))
//
//        let maskLayer1 = CAShapeLayer.init()
//        maskLayer1.frame = share_btn.bounds
//        maskLayer1.path = maskPath1.cgPath
//        share_btn.layer.mask = maskLayer1
//        share_btn.setBackgroundImage(getNavigationIMG(Int(share_btn.height), fromColor: kSetRGBColor(r: 235, g: 167, b: 90), toColor: kSetRGBColor(r: 235, g: 167, b: 90)), for: .normal)  //backBtn

//        collection_mark.layoutButton(with: .top, imageTitleSpace: 8)
        collection_label.layoutButton(with: .top, imageTitleSpace: 5)
        
        backBtn.backgroundColor = kSetRGBAColor(r: 255, g: 255, b: 255, a: alpha)
        
        if coupone_type != "3" {
            requestImageData(type: coupone_type)
        }
        if coupone_type == "1" || coupone_type == "10"{
            requestStoreData()
        }
        
        requestGuessLike()
        
        mainTableArr = NSMutableArray.init(array: ["宝贝", "详情", "推荐"])
        topView = LNTopSelectView.init(frame: CGRect(x: 80, y: navigaView.height-46, width: kSCREEN_WIDTH-160, height: 44))
        topView.theFont = kFont34
        topView.setTopView(titles: mainTableArr as! [String], selectIndex: 0)
        topView.setSelectColor(color: kUnderLineColor())
        weak var weakSelf = self
        topView.callBackBlock { (index) in
            DispatchQueue.main.async(execute: { () -> Void in
                weakSelf?.selectIndex = Int(index)!
                kDeBugPrint(item: index)
                weakSelf?.isDraging = false
                switch index {
                case "0":
                    weakSelf?.mainTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                case "1":
                    if (weakSelf?.mainTableView.numberOfSections)!>1{
                        weakSelf?.mainTableView.scrollToRow(at: IndexPath.init(row: 0, section: 1), at: .top, animated: true)
                    }
                default:
                    if (weakSelf?.mainTableView.numberOfSections)!>2{
                        weakSelf?.mainTableView.scrollToRow(at: IndexPath.init(row: 0, section: 2), at: UITableViewScrollPosition.top, animated: true)
                    }
                    break
                }
            })
        }
        navigaView.addSubview(topView)

//        接受APPdelegate里发送的通知
        NotificationCenter.default.addObserver(self, selector: #selector(LQLoadGoodDeailNification(nitofication:)), name: NSNotification.Name(rawValue: LQTools().LQLoadGoodDeailNification), object: nil)
        
    }
    
    @objc func LQLoadGoodDeailNification(nitofication:Notification) {
        let goodInfo = JSON(nitofication.userInfo!).dictionaryValue
        coupone_type = (goodInfo["coupone_type"]?.stringValue)!
        good_item_id = (goodInfo["good_item_id"]?.stringValue)!
        
        requestData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func configSubViews() {
        navigationBackGroundImage.backgroundColor = UIColor.clear
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-50), style: .grouped, vc: self)
//        优惠券详情显示
        mainTableView.register(UINib(nibName: "LNGoodDetailNoSuperVipCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
//        图片
        mainTableView.register(UINib.init(nibName: "LQGoodsImagesCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
//        猜你喜欢
        mainTableView.register(UINib.init(nibName: "LNDetailGuessLikeCell", bundle: nil), forCellReuseIdentifier: identyfierTable2)
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.separatorStyle = .none
        mainTableView.tag = 1021
        
        self.view.addSubview(mainTableView)
        mainTableView.backgroundColor = kBGColor()
        backBtn.setImage(UIImage.init(named: "nav_return_black"), for: .normal)
        backBtn.cornerRadius = 35/2
        
        backBtn.snp.updateConstraints { (ls) in
            ls.left.equalToSuperview().offset(16)
        }
//        rightBtn1.setImage(UIImage.init(named: "Group7"), for: .normal)
//        rightBtn1.addTarget(self, action: #selector(collectionList(sender:)), for: .touchUpInside)
        
        self.view.backgroundColor = kBGColor()
        mainTableView.backgroundColor = UIColor.white
        
        mainTableView.snp.makeConstraints { (ls) in
            ls.left.width.equalToSuperview()
            ls.bottom.equalTo(bootomView.snp.top)
            ls.top.equalToSuperview().offset(-kStatusBarH)
        }
    }
    @objc func collectionList(sender: UIButton) {
        kDeBugPrint(item: "收藏列表")
    }
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    
//     返回首页按钮
    @IBAction func goMainPage(_ sender: Any) {
        self.navigationController?.popToViewController((self.navigationController?.childViewControllers[0])!, animated: true)

        if self.tabBarController?.selectedIndex != 0 {
            let time: TimeInterval = 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                
                let tabbar = UIApplication.shared.keyWindow?.rootViewController as? LNMainTabBarController
                tabbar?.selectedIndex = 0
            }

        }
    }
    
//    请求猜你喜欢的数据
    func requestGuessLike() {
        let request = SKRequest.init()
        
        weak var weakSelf = self
        
        request.setParam(good_item_id as NSObject, forKey: "itemid")
        
        request.callGET(withUrl: LNUrls().kGuess_like) { (response) in
            DispatchQueue.main.async {
                
                if !(response?.success)! {
                    return
                }
                
                let datas =  JSON((response?.data["data"])!).arrayValue
                weakSelf?.guessModels.removeAll()
                
                for index in 0..<datas.count{
                    let json = datas[index]
                    let model = LNYHQListModel.setupValues(json: json)
                    weakSelf?.guessModels.append(model)
                }
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
//    请求优惠券的详情图片
    func requestImageData(type:String) {
        let request = SKRequest.init()
        weak var weakSelf = self
        
//        淘宝、天猫，之前为了区分他俩，就让淘宝=1m，天猫=10
        if type == "1" || type == "10"{
            let requestUrl = "http://h5api.m.taobao.com/h5/mtop.taobao.detail.getdesc/6.0/"
            request.setParam("{\"id\":\""+good_item_id+"\"}" as NSObject, forKey: "data")
            request.callGET(withUrl: requestUrl) { (response) in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if response?.data == nil {
                        return
                    }
                    
                    let data = JSON((response?.data)!["data"]!)["pcDescContent"].stringValue
                    
                    //截取图片地址
                    weakSelf?.htmlStrs = OCTools.filterImage(data, isJD: false)
                    kDeBugPrint(item: weakSelf?.htmlStrs)
                    weakSelf?.mainTableView.reloadData()
                })
            }
        }else{
//            京东拼多多
            let requestUrl1 = "http://api-gw.haojingke.com/index.php/api/index/myapi?type=detail&apikey=8baf004e74c0b239&skuid="+good_item_id
            request.callPOST(withUrl: requestUrl1) { (response) in
                if response?.data == nil {
                    return
                }
                let requestUrl2 = JSON((response?.data)!)["data"].stringValue
                if requestUrl2.count == 0 {
                    return
                }
                request.callGET(withUrl:  "http://"+requestUrl2, withCallBack: { (response2) in
                    if response2?.data == nil {
                        return
                    }
                    let data = JSON((response2?.data)!)["content"].stringValue
//                    截取图片地址
                    weakSelf?.htmlStrs = OCTools.filterImage(data, isJD: true)
                    
                    kDeBugPrint(item: weakSelf?.htmlStrs)
                    weakSelf?.mainTableView.reloadData()
                })
            }
            
            //http://cd.jd.com/description/channel?skuId="+good_item_id+"&mainSkuId=1309809763&cdn=2
        }
        
    }
    
    
//    分享 按钮
    @IBAction func shareAction(_ sender: UIButton) {
        
        if yhqModel == nil {
            setToast(str: "没有数据")
            return
        }

        weak var weakSelf = self
        let share = LNShareGoodsViewController()
        share.show_images = (weakSelf?.yhqModel?.small_images)!
        
        if weakSelf?.yhqModel?.coupon_link_url.count == 0 {
            weakSelf?.yhqModel?.coupon_link_url = "没有找到链接"
        }
        
        var string = (weakSelf?.yhqModel?.coupon_link_url)!
        if coupone_type == "1" || coupone_type == "10"{
            string = "复制这条信息，"+(self.yhqModel?.kouling)!+"，打开【手机淘宝】即可查看"
        }else if coupone_type == "3" {
            string = (weakSelf?.yhqModel?.coupon_link_shorturl)!
        }
        let title = (weakSelf?.yhqModel?.title)!
        let yuanjian = "\n【在售价】￥"+OCTools().getStrWithFloatStr2((weakSelf?.yhqModel?.price)!)
        let xianjia = "\n【券后价】￥"+OCTools().getStrWithFloatStr2((weakSelf?.yhqModel?.final_price)!)
        let youhuiquan = "\n【优惠券】￥"+(self.yhqModel?.coupon_price)!
        let address = "\n【下单地址】"+string
        share.good_title = title+yuanjian+xianjia+youhuiquan+address
        share.shareUrl = weakSelf?.yhqModel?.coupon_link_url
        share.model = (weakSelf?.yhqModel)!
        if coupone_type == "10" {
            share.type = "1"
        }else{
            share.type = (weakSelf?.coupone_type)!
        }
        self.navigationController?.pushViewController(share, animated: true)

    }
//    购买 按钮
    @IBAction func lingquanAction(_ sender: UIButton) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            
            if weakSelf?.yhqModel?.coupon_link_url.count == 0 {
                return
            }
            
            //        淘宝、天猫，之前为了区分他俩，就让淘宝=1m，天猫=10
            if weakSelf?.coupone_type == "1" || weakSelf?.coupone_type == "10" {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    let showParam = AlibcTradeShowParams.init()
                    showParam.openType = AlibcOpenType.native
                    
//                    如果要换了百川平台的应用，这里的要换成对应的appkey
                    showParam.backUrl="tbopen25316706"
                    showParam.linkKey = "taobao"
                    showParam.isNeedPush=false
                    showParam.nativeFailMode = AlibcNativeFailMode.jumpH5
                    if weakSelf?.yhqModel == nil {
                        return
                    }
//                    let page = AlibcTradePageFactory.page((weakSelf?.yhqModel?.coupon_link_url)!)
//                    AlibcTradeSDK.sharedInstance().tradeService().show(self, page: page, showParams: showParam, taoKeParams: weakSelf?.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//                        
//                    }, tradeProcessFailedCallback: { (error) in
//                        
//                    })
                })
            }else if weakSelf?.coupone_type == "2" {
//                跳京东
                DispatchQueue.main.async(execute: { () -> Void in
                    KeplerApiManager.sharedKPService().isOpenByH5 = false
                    //                KeplerApiManager.sharedKPService().jDappBackTagID = "sdkback8ad4ab6589f44cebba1c33816765fa9f"
                    KeplerApiManager.sharedKPService().jDappBackTagID = "NY2wDM6NFEKdhJvvYVpDhA"
                    //                KeplerApiManager.sharedKPService().actId
                    
                    KeplerApiManager.sharedKPService().openKeplerPage(withURL: (weakSelf?.yhqModel?.coupon_link_url)!, sourceController: self, jumpType: 2, customParams: nil)
                })
            }else{
//                拼多多，拼多多没有SDK，根据链接跳就行了
                DispatchQueue.main.async(execute: { () -> Void in
                    if UIApplication.shared.canOpenURL(NSURL.init(string: "pinduoduo://")! as URL) {
                        
                        var openUrl = (weakSelf?.yhqModel?.coupon_link_url)!
                        
                        let arr = openUrl.components(separatedBy: "https://mobile.yangkeduo.com/")
                        if arr.count == 2 {
                            openUrl = arr[1]
                        }else if arr.count == 21  {
                            openUrl = arr[0]
                        } else {
                            setToast(str: "地址错误")
                            return
                        }
                        
                        UIApplication.shared.openURL(NSURL.init(string: "pinduoduo://com.xunmeng.pinduoduo/"+openUrl)! as URL)
                    }else{
//                        如果没装拼多多，就用自己的web
                        let WebVC = LQWebViewController()
                        WebVC.webTitle = "粉丝福利购"
                        WebVC.webUrl = (weakSelf?.yhqModel?.coupon_link_url)!
                        weakSelf?.navigationController?.pushViewController(WebVC, animated: true)
                    }
                })
            }
        }
    }
    
    
//    配置跳转淘宝的参数
    override func getTaokeParam() -> AlibcTradeTaokeParams {
        
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

    
//    收藏/取消收藏
    @IBAction func collectAction(_ sender: UIButton) {
        if yhqModel == nil {
            return
        }
        LQLoadingView().SVPwillShowAndHideNoText()
        if collection_label.isSelected {
            
            let request = SKRequest.init()
            weak var weakSelf = self
            if self.coupone_type == "10" {
                request.setParam("1" as NSObject, forKey: "type")
            }else{
                request.setParam(coupone_type as NSObject, forKey: "type")
            }
            request.setParam((yhqModel?.favourite)! as NSObject, forKey: "id")
            
            request.callDELETE(withUrl: LNUrls().kFavourite_cancle+(yhqModel?.favourite)!) { (response) in
                LQLoadingView().SVPHide()
                if !(response?.success)! {
                    return
                }
                DispatchQueue.main.async {
                    weakSelf?.collection_label.isSelected = false
                }
            }

        }else{
            
            if yhqModel == nil {
                return
            }
            let request = SKRequest.init()
            request.setParam((yhqModel?.item_id)! as NSObject, forKey: "item_id")
            if self.coupone_type == "10" {
                request.setParam("1" as NSObject, forKey: "type")
            }else{
                request.setParam(coupone_type as NSObject, forKey: "type")
            }
            
            request.setParam((yhqModel?.title)! as NSObject, forKey: "title")
            request.setParam((yhqModel?.pic_url)! as NSObject, forKey: "pic_url")
            request.setParam((yhqModel?.volume)! as NSObject, forKey: "volume")
            request.setParam((yhqModel?.price)! as NSObject, forKey: "price")
            request.setParam((yhqModel?.coupon_price)! as NSObject, forKey: "coupon_price")
            request.setParam((yhqModel?.final_price)! as NSObject, forKey: "final_price")

            weak var weakSelf = self
            request.callPOST(withUrl: LNUrls().kFavourite_add) { (response) in
                LQLoadingView().SVPHide()
                DispatchQueue.main.async {
                    if !(response?.success)! {
                        setToast(str: "收藏失败")
                        return
                    }
                    weakSelf?.collection_label.isSelected = true
                    weakSelf?.requestData()
                }
            }
        }
    }
    
    override func refreshHeaderAction() {
        requestData()
    }
    
    override func requestData() {
//        获取优惠券数据
        if coupone_type.count == 0 || good_item_id.count == 0 {
            return
        }
        
        let request = SKRequest.init()
        if self.coupone_type == "10" {
            request.setParam("1" as NSObject, forKey: "type")
        }else{
            request.setParam(coupone_type as NSObject, forKey: "type")
        }

        request.setParam(good_item_id as NSObject, forKey: "itemid")
        weak var weakSelf = self
        DispatchQueue.init(label: "loading.show.tread").async {
            LQLoadingView().SVPwillShowAndHideNoText1()
        }
//
        request.callGET(withUrl: LNUrls().kShow_coupon_deltai) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                
                let time: TimeInterval = 1.2
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    
                    weakSelf?.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let datas =  JSON((response?.data["data"])!)
                weakSelf?.yhqModel = LNYHQDetailModel.setupValues(json: datas)
                //                看requestStoreData()里面的注释都是一样的道理
                if (weakSelf?.yhqModel?.imagesArr.count)!>0 {
                    weakSelf?.htmlStrs = (weakSelf?.yhqModel?.imagesArr)!
                }
                if weakSelf?.storeData != nil {
                    weakSelf?.yhqModel!.data = (weakSelf?.storeData)!
                }
                
                weakSelf?.mainTableView.reloadData()
                
                if weakSelf?.yhqModel?.favourite == "0" {
                    weakSelf?.collection_label.isSelected = false
                }else{
                    weakSelf?.collection_label.isSelected = true
                }
                
                weakSelf?.addHistory()
                weakSelf?.mainTableView.mj_header.endRefreshing()
            })
        }
    }
    
//    当优惠券类型是淘宝的时候，还需要显示店铺信息
    func requestStoreData() {
        let request = SKRequest.init()
        weak var weakSelf = self
        let requestUrl = "https://acs.m.taobao.com/h5/mtop.taobao.detail.getdetail/6.0/"
        request.setParam("{\"itemNumId\":\""+good_item_id+"\"}" as NSObject, forKey: "data")
        request.callGET(withUrl: requestUrl) { (response) in
            DispatchQueue.main.async(execute: { () -> Void in
                
//                下面的写法是因为不知道店铺数据和优惠券数据哪个先返回。如果店铺信息回来，优惠券还没回来的时候，就先用一个全局承载，等到优惠券信息回来，再把这些数据作为他的一个熟悉，当然也可以加一个线程，等到优惠券信息返回来之后再请求这个。
                weakSelf?.storeData = JSON((response?.data)!)
                if weakSelf?.yhqModel != nil {
                    
                    weakSelf?.yhqModel!.data = (weakSelf?.storeData)!
                    weakSelf?.mainTableView.reloadData()
                }
            })
        }
    }

    
    func addHistory()  {
        
        let request = SKRequest.init()
        request.setParam((yhqModel?.title)! as NSObject, forKey: "title")
        request.setParam((yhqModel?.pic_url)! as NSObject, forKey: "pic_url")
        request.setParam((yhqModel?.item_id)! as NSObject, forKey: "item_id")
        request.setParam((yhqModel?.volume)! as NSObject, forKey: "volume")
        request.setParam((yhqModel?.price)! as NSObject, forKey: "price")
        request.setParam((yhqModel?.coupon_price)! as NSObject, forKey: "coupon_price")
        request.setParam((yhqModel?.final_price)! as NSObject, forKey: "final_price")
        if self.coupone_type == "10" {
            request.setParam("1" as NSObject, forKey: "type")
        }else{
            request.setParam(coupone_type as NSObject, forKey: "type")
        }

        request.callPOST(withUrl: LNUrls().kHistory) { (response) in

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isWillDis = true
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isWillDis = false
    }

    
    var isDraging = true
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDraging = true
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.tag == 1021 {
            titleLabel.alpha = (scrollView.contentOffset.y+20)/navHeight/2*3
            navigaView.backgroundColor = kSetRGBAColor(r: 255, g: 255, b: 255, a: scrollView.contentOffset.y/navHeight/2*3)
            topView.alpha = (scrollView.contentOffset.y+20)/navHeight/2*3

            if !isDraging {
                return
            }
            if mainTableView.numberOfSections > 2 {
//                print(mainTableView.rectForHeader(inSection: 2).origin.y)
                if mainTableView.rectForHeader(inSection: 2).origin.y-scrollView.mj_offsetY < 100 {
                    if selectIndex == 2 {
                        return
                    }
                    selectIndex = 2
                }else{
//                    print(mainTableView.rectForHeader(inSection: 1).origin.y)
                    if mainTableView.rectForHeader(inSection: 1).origin.y-scrollView.mj_offsetY < 100 {
                        if selectIndex == 1 {
                            return
                        }
                        selectIndex = 1
                    }else{
                        if selectIndex == 0 {
                            return
                        }
                        selectIndex = 0
                    }
                }
                
                topView.setSelecIndex(index: selectIndex)
            }
        }
    }
}

extension LNGoodsDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if yhqModel == nil {
            return 0
        }
        if htmlStrs.count > 0 {
            if guessModels.count > 0 {
                return 3
            }else{
                return 2
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            if section == 1 {
                if htmlStrs.count>0 {
                    return htmlStrs.count
                }else{
                    return 1
                }
            }else{
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! LNGoodDetailNoSuperVipCell
            cell.selectionStyle = .none
            if yhqModel != nil {
                cell.model = yhqModel!
            }
            weak var weakSelf = self
            cell.callBackPhoneNum { (s) in
//                点击了领券
                weakSelf?.lingquanAction(UIButton())
            }
            cell.setmark(type: coupone_type)
            return cell
        }else if indexPath.section == 1{
            
            if htmlStrs.count>0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LQGoodsImagesCell
                //            cell.selectionStyle = .none
                cell.setupImage(imageUrl: htmlStrs[indexPath.row])
                
                weak var weakSelf = self
                cell.callReloadCell { (height) in
                    if (weakSelf?.isWillDis) != nil {
                        if !(weakSelf?.isWillDis)! {
                            UIView.performWithoutAnimation {
                                tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! LNDetailGuessLikeCell
//                cell.setGuessLikeData(models: guessModels)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! LNDetailGuessLikeCell
//            cell.setGuessLikeData(models: guessModels)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 40
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UIButton.init()
        if section == 1
        {
            titleLabel.setTitle("宝贝详情", for: .normal)
        } else if section == 2 {
            titleLabel.setTitle("猜你喜欢", for: .normal)
        }
        titleLabel.setTitleColor(kGaryColor(num: 69), for: .normal)
        titleLabel.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView.init()
        foot.backgroundColor = kBGColor()
        return foot
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 12
    }
}
