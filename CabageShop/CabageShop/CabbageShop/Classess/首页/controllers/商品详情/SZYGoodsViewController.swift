//
//  SZYGoodsViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/1.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import JDKeplerSDK
import SwiftyUserDefaults


class SZYGoodsViewController: LNBaseViewController, UIWebViewDelegate{
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shoucangBun: UIButton!
    @IBOutlet weak var fenxiangBun: UIButton!
    @IBOutlet weak var goumaiBun: UIButton!
    
    let identyfierTable1  = "identyfierTable1"
    let identyfierTable2  = "identyfierTable2"
    let identyfierTable3  = "identyfierTable3"
    
    let alpha:CGFloat = 0.8
    var good_item_id = String()
    var coupone_type = String()
    
    var selectIndex = NSInteger()   // 顶部选中按钮
    var GoodsInformationModel = SZYGoodsInformationModel() //商品信息
    var StoreInformationModel = SZYStoreInformationModel() //商店信息
    var newGuessModels = [SZYGoodsInformationModel]() //猜你喜欢数据
    
    var goodsUrl = ""
//    fileprivate var topView = LNTopSelectView() //    顶部选择
    var isDraging = true
    var codeString = ""
    
    
    fileprivate var FooterWebView : UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle = "宝贝详情"
        shoucangBun.layoutButton(with: .top, imageTitleSpace: 8)
        shoucangBun.setImage(UIImage.init(named: "good_detail_iscollect"), for: .normal)
        shoucangBun.setImage(UIImage.init(named: "good_detail_iscollect_yes"), for: .selected)
        backBtn.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.35)
        if coupone_type == "1" || coupone_type == "10"{ //淘宝店铺信息
            requestStoreData()
        }
        requestGuessLike()  // 猜你喜欢
//        接受APPdelegate里发送的通知
        NotificationCenter.default.addObserver(self, selector: #selector(LQLoadGoodDeailNification(nitofication:)), name: NSNotification.Name(rawValue: LQTools().LQLoadGoodDeailNification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SZYGoodsViewController(nitofication:)), name: NSNotification.Name(rawValue: LQTools().SZYGoodsViewController), object: nil)
    }
    @objc func LQLoadGoodDeailNification(nitofication:Notification) {
        let goodInfo = JSON(nitofication.userInfo!).dictionaryValue
        coupone_type = (goodInfo["coupone_type"]?.stringValue)!
        good_item_id = (goodInfo["good_item_id"]?.stringValue)!
        requestData()
    }
    @objc func SZYGoodsViewController(nitofication:Notification) {
        requestData()
    }
    override func configSubViews() {
        navigationBackGroundImage.backgroundColor = UIColor.clear
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-50), style: .grouped, vc: self)
//        优惠券详情显示
        mainTableView.register(UINib.init(nibName: "LNGoodDetailNoSuperVipCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
//        图片
        mainTableView.register(UINib.init(nibName: "LQGoodsImagesCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
//        猜你喜欢
        mainTableView.register(UINib.init(nibName: "LNDetailGuessLikeCell", bundle: nil), forCellReuseIdentifier: identyfierTable2)
//        图片 webView
        mainTableView.register(UINib.init(nibName: "SZYLQGoodsImagesCell", bundle: nil), forCellReuseIdentifier: identyfierTable3)
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        mainTableView.tableHeaderView?.isHidden = true
        
        
        FooterWebView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 1))
        FooterWebView?.scrollView.isScrollEnabled = false
        FooterWebView?.sizeToFit()
        /** 网页收缩适配 */
        FooterWebView?.scalesPageToFit = true
        FooterWebView?.delegate = self
        
        FooterWebView?.isMultipleTouchEnabled = true
        FooterWebView?.isUserInteractionEnabled = true
        FooterWebView?.scrollView.isScrollEnabled = true
        FooterWebView?.contentMode = .scaleAspectFill
        
        mainTableView.tableFooterView = FooterWebView
        mainTableView.tableFooterView?.isHidden = false
        mainTableView.separatorStyle = .none
        mainTableView.tag = 1021
        
        self.view.addSubview(mainTableView)
        mainTableView.backgroundColor = kBGColor()
        backBtn.setImage(UIImage.init(named: "nav_return_white"), for: .normal)
        backBtn.cornerRadius = 35 / 2
        backBtn.snp.updateConstraints { (ls) in
            ls.left.equalToSuperview().offset(16)
        }
        self.view.backgroundColor = kBGColor()
        mainTableView.backgroundColor = UIColor.white
        
        weak var weakSelf = self
        mainTableView.snp.makeConstraints { (ls) in
            ls.left.width.equalToSuperview()
            ls.bottom.equalTo(weakSelf!.bgView.snp.top)
            ls.top.equalToSuperview().offset(-kStatusBarH)
        }
        FooterWebView?.addObserver(self, forKeyPath: "scrollView.contentSize", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "scrollView.contentSize" {
            let webview = object as! UIWebView
            FooterWebView?.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: webview.scrollView.contentSize.height)
            mainTableView.tableFooterView = FooterWebView
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func refreshHeaderAction() {
        requestData()
    }
    override func requestData() { // 获取优惠券数据
        if coupone_type.count == 0 || good_item_id.count == 0 {
            return
        }
        let request = SKRequest.init()
        
        if self.coupone_type == "10" {
            request.setParam("1" as NSObject, forKey: "type")
        } else {
            request.setParam(coupone_type as NSObject, forKey: "type")
        }
//        request.setParam("1" as NSObject, forKey: "type")
        request.setParam(good_item_id as NSObject, forKey: "itemid")
        weak var weakSelf = self
        request.callGET(withUrl1: LNUrls().kShow_coupon_deltai) { (response) in
//            LQLoadingView().SVPHide(\\\\\)
            
            kDeBugPrint(item: "详情数据 \(response?.data)")
            
            if !(response?.success)! {
                if response?.code == 4001 {
                    weakSelf?.tankuangtishi()
                }
                return
            }
            
            kDeBugPrint(item: response?.data)
            DispatchQueue.main.async(execute: { () -> Void in
                let datas =  JSON((response?.data["data"])!)
                weakSelf?.codeString = JSON((response?.data["code"])!).stringValue
                weakSelf?.GoodsInformationModel = SZYGoodsInformationModel.setupValues(json: datas)
                if weakSelf?.goodsUrl != "" {
                    weakSelf?.GoodsInformationModel.images.insert((weakSelf?.goodsUrl)!, at: 0)
                }
                if weakSelf?.StoreInformationModel != nil {
                    weakSelf?.mainTableView.reloadData()
                }
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
            kDeBugPrint(item: response?.data)
            if response?.data == nil {
                if weakSelf?.GoodsInformationModel != nil {
                    weakSelf?.mainTableView.reloadData()
                }
                return
            }
            kDeBugPrint(item: response?.data)
            DispatchQueue.main.async(execute: { () -> Void in
//                下面的写法是因为不知道店铺数据和优惠券数据哪个先返回。如果店铺信息回来，优惠券还没回来的时候，就先用一个全局承载，等到优惠券信息回来，再把这些数据作为他的一个熟悉，当然也可以加一个线程，等到优惠券信息返回来之后再请求这个。
                let data = JSON(response?.data! as Any)["data"]["seller"]
                weakSelf?.StoreInformationModel = SZYStoreInformationModel.setupValues(json: data)
                
                let url = "https://mdetail.tmall.com/templates/pages/desc?id=" + (weakSelf?.good_item_id)!
                let myRequest = URLRequest(url: OCTools.getEfficientAddress(url))
                weakSelf?.FooterWebView?.loadRequest(myRequest)
                
                if weakSelf?.GoodsInformationModel != nil {
                    weakSelf?.mainTableView.reloadData()
                }
            })
        }
    }
//    请求猜你喜欢的数据
    func requestGuessLike() {
        let request = SKRequest.init()
        weak var weakSelf = self
        request.setParam(good_item_id as NSObject, forKey: "itemid")
        request.callGET(withUrl: LNUrls().kGuess_like) { (response) in
            kDeBugPrint(item: response?.code)
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!).arrayValue
                weakSelf?.newGuessModels.removeAll()
                for index in 0..<datas.count{
                    let json = datas[index]
                    let model = SZYGoodsInformationModel.setupValues(json: json)
                    weakSelf?.newGuessModels.append(model)
                }
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    func tankuangtishi() {
        let tankuan = SZYGoodsWithoutCouponsViewController()
        tankuan.daliCanshu = self
        tankuan.titleStr = "该商品无优惠信息"
        tankuan.contentStr = "是否查看更多同类商品"
        tankuan.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        tankuan.modalPresentationStyle = .custom
        self.modalPresentationStyle = .currentContext
        self.present(tankuan, animated: false, completion: nil)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDraging = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1021 {
            titleLabel.alpha = (scrollView.contentOffset.y + 20) / navHeight / 2 * 3
            navigaView.backgroundColor = kSetRGBAColor(r: 255, g: 255, b: 255, a: scrollView.contentOffset.y / navHeight / 2 * 3)
        }
    }
    // 收藏
    
    @IBAction func shoucangClick(_ sender: UIButton) {
        if !self.loginClick() {  //判断登陆
            return
        }
        if shoucangBun.isSelected {
            let request = SKRequest.init()
            weak var weakSelf = self
            if self.coupone_type == "10" {
                request.setParam("1" as NSObject, forKey: "type")
            } else {
                request.setParam(coupone_type as NSObject, forKey: "type")
            }
            request.setParam((GoodsInformationModel.favourite) as NSObject, forKey: "id")
            request.callDELETE(withUrl: LNUrls().kFavourite_cancle+(GoodsInformationModel.favourite)) { (response) in
                if !(response?.success)! {
                    return
                }
                DispatchQueue.main.async {
                    weakSelf?.shoucangBun.isSelected = false
                }
            }
        } else {
            let request = SKRequest.init()
            request.setParam((GoodsInformationModel.item_id) as NSObject, forKey: "item_id")
            if self.coupone_type == "10" {
                request.setParam("1" as NSObject, forKey: "type")
            }else{
                request.setParam(coupone_type as NSObject, forKey: "type")
            }
            request.setParam((GoodsInformationModel.title) as NSObject, forKey: "title")
            request.setParam((GoodsInformationModel.pic_url) as NSObject, forKey: "pic_url")
            request.setParam((GoodsInformationModel.volume) as NSObject, forKey: "volume")
            request.setParam((GoodsInformationModel.price) as NSObject, forKey: "price")
            request.setParam((GoodsInformationModel.coupon_price) as NSObject, forKey: "coupon_price")
            request.setParam((GoodsInformationModel.final_price) as NSObject, forKey: "final_price")
            weak var weakSelf = self
            request.callPOST(withUrl: LNUrls().kFavourite_add) { (response) in
                DispatchQueue.main.async {
                    if !(response?.success)! {
                        setToast(str: "收藏失败")
                        return
                    }
                    weakSelf?.shoucangBun.isSelected = true
                    weakSelf?.requestData()
                }
            }
        }
    }
    // 分享
    @IBAction func fenxiangClick(_ sender: UIButton) {
        if !self.loginClick() {  //判断登陆
            return
        }
        if !self.bindingInformationClick(goods: GoodsInformationModel) {  //判断是否绑定手机号 上级 是否授权
            return
        }
        
        let share = SZYShareGoodsViewController()
        share.goodsModel = GoodsInformationModel
        self.navigationController?.pushViewController(share, animated: true)
    }
    // 领券购买
    @IBAction func goumaiClick(_ sender: UIButton) {
        if !self.loginClick() { //判断登陆
            return
        }
        if !self.bindingInformationClick(goods: GoodsInformationModel) {  //判断是否绑定手机号 上级 是否授权
            return
        }
        
        if GoodsInformationModel.type == "1" {
            let showParam = AlibcTradeShowParams.init()
            showParam.openType = AlibcOpenType.native
            //如果要换了百川平台的应用，这里的要换成对应的appkey
            showParam.backUrl="tbopen25316706"
            showParam.linkKey = "taobao"
            showParam.isNeedPush = false
            showParam.nativeFailMode = AlibcNativeFailMode.jumpH5
            let page = AlibcTradePageFactory.page(GoodsInformationModel.coupon_url)
            AlibcTradeSDK.sharedInstance().tradeService().show(self, page: page, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                
            }, tradeProcessFailedCallback: { (error) in
                
            })
        } else if GoodsInformationModel.type == "2" {
            KeplerApiManager.sharedKPService().isOpenByH5 = false
            KeplerApiManager.sharedKPService().jDappBackTagID = "sdkback432b5083c69bf32a09d41dc16c434cda"
            KeplerApiManager.sharedKPService().openKeplerPage(withURL: (GoodsInformationModel.coupon_link.url), sourceController: self, jumpType: 2, customParams: nil)
        } else if GoodsInformationModel.type == "3" {
            if UIApplication.shared.canOpenURL(NSURL.init(string: "pinduoduo://")! as URL) {
                var openUrl = GoodsInformationModel.coupon_link.mobile_url
                let arr = openUrl.components(separatedBy: "https://mobile.yangkeduo.com/")
                if arr.count == 2 {
                    openUrl = arr[1]
                } else if arr.count == 21 {
                    openUrl = arr[0]
                } else {
                    setToast(str: "地址错误")
                    return
                }
                UIApplication.shared.openURL(NSURL.init(string: "pinduoduo://com.xunmeng.pinduoduo/"+openUrl)! as URL)
            } else { // 如果没装拼多多，就用自己的web
                let WebVC = LQWebViewController()
                WebVC.webTitle = "粉丝福利购"
                //                WebVC.navBGImag = "com_nav_background_img"
                WebVC.webUrl = GoodsInformationModel.coupon_link.mobile_url
                self.navigationController?.pushViewController(WebVC, animated: true)
            }
        }
        
//        let showParam = AlibcTradeShowParams.init()
//        showParam.openType = AlibcOpenType.native
//        //如果要换了百川平台的应用，这里的要换成对应的appkey
//        showParam.backUrl="tbopen25316706"
//        showParam.linkKey = "taobao"
//        showParam.isNeedPush = false
//        showParam.nativeFailMode = AlibcNativeFailMode.jumpH5
//        let page = AlibcTradePageFactory.page(GoodsInformationModel.coupon_url)
//        AlibcTradeSDK.sharedInstance().tradeService().show(self, page: page, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//
//        }, tradeProcessFailedCallback: { (error) in
//
//        })
        
    }
//    配置跳转淘宝的参数
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
    func savePictureClick() {
        
        if GoodsInformationModel.images.count == 0 {
            setToast(str: "对不起，暂无图片")
            return
        }
        
        for urlStr in GoodsInformationModel.images {
            let data = try! Data.init(contentsOf: URL.init(string: urlStr)!)
            let image = UIImage.init(data: data as Data)
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            setToast(str: "已保存")
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) { //加载完成
//        kDeBugPrint(item: webView.scrollView.contentSize.height)
//        FooterWebView.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: webView.scrollView.contentSize.height)
//        mainTableView.tableFooterView = FooterWebView
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        FooterWebView?.removeObserver(self, forKeyPath: "scrollView.contentSize")
        FooterWebView?.delegate = nil
        FooterWebView = nil
    }
}
extension SZYGoodsViewController : SZYGoodsWithoutCouponsViewControllerDelegate {
    func getButtonClick(tag: Int) {
        kDeBugPrint(item: tag)
        
        if tag == 100 {
            self.navigationController?.popViewController(animated: true)
        } else if tag == 101 {
            let vc = LNLikeTheItemViewController()
            vc.item_id = self.good_item_id
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.popViewController(animated: false)
        }
    }
}
extension SZYGoodsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if newGuessModels.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! LNGoodDetailNoSuperVipCell
            cell.selectionStyle = .none
            cell.setUpUserInfo(GoodsInformationModel: GoodsInformationModel, StoreInformationModel: StoreInformationModel)
            weak var weakSelf = self
            cell.callBackPhoneNum { (s) in  // 点击了领券 saveCallBackPhoneNum
                weakSelf?.goumaiClick(UIButton())
            }
            cell.saveCallBackPhoneNum { (ls) in // 保存图片
                weakSelf?.savePictureClick()
            }
            cell.setmark(type: coupone_type)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! LNDetailGuessLikeCell
            cell.selectionStyle = .none
            cell.setUpData(models: newGuessModels)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 50
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let Header = UIView.init()
        Header.backgroundColor = kBGColor()
        
        if section == 1 {
            let titleLabel = UIButton.init(frame: CGRect.init(x: 0, y: 10, width: kSCREEN_WIDTH, height: 40))
            titleLabel.setTitle("商品推荐", for: .normal)
            titleLabel.backgroundColor = UIColor.white
            titleLabel.setTitleColor(kGaryColor(num: 69), for: .normal)
            titleLabel.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            Header.addSubview(titleLabel)
        }
        
        return Header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView.init()
        foot.backgroundColor = kBGColor()
        if section == 0 {
            if newGuessModels.count <= 0 {
                let lab = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: kSCREEN_WIDTH, height: 40))
                lab.backgroundColor = UIColor.white
                lab.text = "商品详情"
                lab.textColor = kGaryColor(num: 69)
                lab.textAlignment = .center
                lab.font = UIFont.systemFont(ofSize: 15)
                foot.addSubview(lab)
            }
        } else if section == 1 {
            let lab = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: kSCREEN_WIDTH, height: 40))
            lab.backgroundColor = UIColor.white
            lab.text = "商品详情"
            lab.textColor = kGaryColor(num: 69)
            lab.textAlignment = .center
            lab.font = UIFont.systemFont(ofSize: 15)
            foot.addSubview(lab)
        }
        return foot
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            if newGuessModels.count > 0 {
                return 0.01
            } else {
                return 50
            }
        } else if section == 1 {
            return 50
        }
        return 0.01
    }
}
