//
//  CSStoreWebViewController.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/14.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class CSStoreWebViewController: LNBaseViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    fileprivate var yhqModel : LNYHQDetailModel?

    var webUrl = ""
    var webTitle = ""
    var webView = WKWebView()
    fileprivate let config = WKWebViewConfiguration()
    fileprivate var footView = UIView()
    fileprivate var headView = UIView()
    fileprivate var searchBtn = UIButton.init()
    fileprivate var shareBtn = UIButton.init()
    fileprivate var buyQuan = UIButton.init()
    fileprivate var theItemId : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = webTitle
        titleLabel.textColor = UIColor.white
        
        webView = WKWebView.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - navHeight), configuration: config)
        
        let myRequest = URLRequest(url: OCTools.getEfficientAddress(webUrl))
        webView.load(myRequest)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
        webView.allowsBackForwardNavigationGestures = true
        
        view.addSubview(webView)
        btnImage = "reload_black"
        
        
        let leftBtn2 = UIButton.init()
        leftBtn2.titleLabel?.textAlignment = .right
        leftBtn2.addTarget(self, action: #selector(rightAction2(sender:)), for: .touchUpInside)
        leftBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftBtn2.setTitleColor(UIColor.black, for: .normal)
        leftBtn2.setTitle("关闭", for: .normal)
        navigaView.addSubview(leftBtn2)

        leftBtn2.snp.makeConstraints { (ls) in
            ls.left.equalTo(backBtn.snp.right)
            ls.width.greaterThanOrEqualTo(40)
            ls.height.equalTo(30)
            ls.centerY.equalTo(backBtn)
        }

        headView = UIView.init(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: 45))
        let headLabel = UILabel.init(frame: headView.bounds)
        headLabel.text = "请点击页面底部”一键找券查佣金“按钮"
        headLabel.textColor = kSetRGBColor(r: 137, g: 94, b: 56)
        headLabel.textAlignment = .center
        headLabel.font = UIFont.systemFont(ofSize: 14)
        headLabel.backgroundColor = kSetRGBColor(r: 251, g: 239, b: 216)
        headView.addSubview(headLabel)
        
        var bottom:CGFloat = 50
        if kSCREEN_HEIGHT>800 {
            bottom = 85
        }
        footView = UIView.init(frame: CGRect(x: 0, y: kSCREEN_HEIGHT-bottom, width: kSCREEN_WIDTH, height: bottom))
        footView.backgroundColor = UIColor.white
        
        shareBtn = UIButton.init(frame: CGRect(x: 16, y: 5, width: kSCREEN_WIDTH/2-16, height: 50-5*2))
        shareBtn.backgroundColor = kMainColor1()
        shareBtn.setTitle("分享赚 ￥1.42", for: .normal)
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        shareBtn.setTitleColor(UIColor.white, for: .normal)
        shareBtn.clipsToBounds = true
        let maskPath = UIBezierPath.init(roundedRect: shareBtn.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topLeft.rawValue)|UInt8(UIRectCorner.bottomLeft.rawValue))), cornerRadii: CGSize(width: shareBtn.height/2, height: shareBtn.height/2))
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = shareBtn.bounds
        maskLayer.path = maskPath.cgPath
        shareBtn.layer.mask = maskLayer
        
        shareBtn.setBackgroundImage(getNavigationIMG(Int(shareBtn.height), fromColor: kSetRGBColor(r: 73, g: 79, b: 100), toColor: kSetRGBColor(r: 54, g: 59, b: 71)), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareAction(sender:)), for: .touchUpInside)
        
        footView.addSubview(shareBtn)
        
        buyQuan = UIButton.init(frame: CGRect(x: kSCREEN_WIDTH/2, y: 5, width: kSCREEN_WIDTH/2-16, height: 50-5*2))
        buyQuan.backgroundColor = kMainColor1()
        buyQuan.setTitle("没券了", for: .normal)
        buyQuan.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        buyQuan.setTitleColor(UIColor.white, for: .normal)
        buyQuan.clipsToBounds = true
        
        let maskPath2 = UIBezierPath.init(roundedRect: buyQuan.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topRight.rawValue)|UInt8(UIRectCorner.bottomRight.rawValue))), cornerRadii: CGSize(width: buyQuan.height/2, height: buyQuan.height/2))
        
        let maskLayer2 = CAShapeLayer.init()
        maskLayer2.frame = buyQuan.bounds
        maskLayer2.path = maskPath2.cgPath
        buyQuan.layer.mask = maskLayer2
        
        buyQuan.setBackgroundImage(getNavigationIMG(Int(buyQuan.height), fromColor: kSetRGBColor(r: 241, g: 205, b: 135), toColor: kSetRGBColor(r: 182, g: 153, b: 96)), for: .normal)

        buyQuan.addTarget(self, action: #selector(lingquanAction(sender:)), for: .touchUpInside)
        
        footView.addSubview(buyQuan)

        
        searchBtn = UIButton.init(frame: CGRect(x: 16, y: 5, width: kSCREEN_WIDTH-32, height: 50-5*2))
        searchBtn.backgroundColor = kMainColor1()
        searchBtn.setTitle("一键找券查佣金", for: .normal)
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.clipsToBounds = true
        searchBtn.cornerRadius = searchBtn.height/2
        searchBtn.addTarget(self, action: #selector(lookForCoupons(sender:)), for: .touchUpInside)
        footView.addSubview(searchBtn)

        changeStyle()
    }
    
    func requesCoupon(good_item_id:String) {
        
        if good_item_id.count == 0 {
            return
        }
        
        let request = SKRequest.init()
    
        request.setParam("1" as NSObject, forKey: "type")
        
        request.setParam(good_item_id as NSObject, forKey: "itemid")
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: LNUrls().kShow_coupon_deltai) { (response) in
            LQLoadingView().SVPHide()
            
            DispatchQueue.main.async(execute: { () -> Void in
                if !(response?.success)! {
                    if response?.message == nil || (response?.message.count)! == 0{
                        setToast(str: "暂无优惠券")
                    }
                    return
                }

                weakSelf?.searchBtn.isHidden = true
                
                let datas =  JSON((response?.data["data"])!)
                weakSelf?.yhqModel = LNYHQDetailModel.setupValues(json: datas)
                
                weakSelf?.shareBtn.setTitle("分享赚 ￥"+OCTools().getStrWithFloatStr2((weakSelf?.yhqModel?.finalCommission)!), for: .normal)
                
                if OCTools().getStrWithFloatStr2((weakSelf?.yhqModel?.coupon_price)!) != "0.00" && OCTools().getStrWithIntStr((weakSelf?.yhqModel?.coupon_price)!) != "0"{
                    weakSelf?.buyQuan.setTitle("领券"+(weakSelf?.yhqModel?.coupon_price)!+"元", for: .normal)
                }else{
                     weakSelf?.buyQuan.setTitle("暂无优惠券", for: .normal)
                }

//                if Int((weakSelf?.yhqModel?.coupon_remain_count)!) == 0{
//                    weakSelf?.buyQuan.setTitle("暂无优惠券", for: .normal)
//                }else{
//                    weakSelf?.buyQuan.setTitle("去领券", for: .normal)
//                }
            })
        }

    }
    
    
    @objc func lookForCoupons(sender: UIButton) {
        if theItemId == nil {
            setToast(str: "对不起，暂无该商品信息")
            return
        }
        self.requesCoupon(good_item_id: theItemId!)
    }
    
    @objc func shareAction(sender: UIButton) {

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
        
        let string = "复制这条信息，"+(self.yhqModel?.kouling)!+"，打开【手机淘宝】即可查看"
        let title = (weakSelf?.yhqModel?.title)!
        let yuanjian = "\n【在售价】￥"+OCTools().getStrWithFloatStr2((weakSelf?.yhqModel?.price)!)
        let xianjia = "\n【券后价】￥"+OCTools().getStrWithFloatStr2((weakSelf?.yhqModel?.final_price)!)
        let youhuiquan = "\n【优惠券】￥"+(self.yhqModel?.coupon_price)!
        let address = "\n【下单地址】"+string
        share.good_title = title+yuanjian+xianjia+youhuiquan+address
        share.shareUrl = weakSelf?.yhqModel?.coupon_link_url
        share.model = (weakSelf?.yhqModel)!
        share.type = "1"
        self.navigationController?.pushViewController(share, animated: true)
    }
    
    @objc func lingquanAction(sender: UIButton) {
        
        if yhqModel == nil {
            setToast(str: "暂无信息")
            return
        }
//        if Int((yhqModel?.coupon_remain_count)!) == 0{
//
//            return
//        }
        
        
        let showParam = AlibcTradeShowParams.init()
        showParam.openType = AlibcOpenType.native
        
        //                showParam.backUrl="HTeasyTaobaoke://"
        showParam.backUrl="tbopen27863290"
        
        showParam.linkKey = "taobao"
        showParam.isNeedPush=false
        showParam.nativeFailMode = AlibcNativeFailMode.jumpH5
        
        //                let page = AlibcTradePageFactory.itemDetailPage("41576306115")
        //            let page = AlibcTradePageFactory.page("https://uland.taobao.com/coupon/edetail?e=Ptv76DDNSq4GQASttHIRqTVv4lJn3qic19C3HluYXIZs4JUp1U8AfohdS1HTHXkZcfPCLH1546L%2FwB%2BJBgJv%2Br9fwBwwUiqlnXKZhqqrAiChrqnsx7%2Fc%2BRyk4Acx5KDOb8DeY9Np2mueCV%2FGn9TRVGlzrR4%2Bfrcb2XhfVVaMpqHVP6kbsSb1VmroJfAJz%2FSH&traceId=0b0b4cad15411440847145740e&union_lens=lensId:0b0fc0d4_0c2d_166d358810f_975b")
        
        if self.yhqModel == nil {
            return
        }
        
        let page = AlibcTradePageFactory.page((self.yhqModel?.coupon_link_url)!)
        
//        AlibcTradeSDK.sharedInstance().tradeService().show(self, page: page, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//            
//        }, tradeProcessFailedCallback: { (error) in
//            
//        })
    }
    
    
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


    
    override func rightAction2(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func rightAction(sender: UIButton) {
        webView.reload()
    }
    override func backAction(sender: UIButton) {
        if webView.canGoBack {
            webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        kDeBugPrint(item: navigationAction.request.url)
        let urlStr = navigationAction.request.url?.absoluteString
        if (urlStr?.contains("&id="))! || (urlStr?.contains("?id="))! || (urlStr?.contains("&itemId="))! || (urlStr?.contains("?itemId="))!{
            kDeBugPrint(item: "跳转详情页")
            if (urlStr?.contains("&id="))! {
                let urlArr = urlStr?.components(separatedBy: "&id=")
                if (urlArr?.count)! > 1 {
                    var item_id = OCTools().getSubString(urlArr![1], withRangeStardIndex: 0, andLength: "577957424858".count)
                    if (item_id?.contains("&"))! {
                        item_id = item_id?.replacingOccurrences(of: "&", with: "")
                    }
                    if (item_id?.contains("="))! {
                        item_id = item_id?.replacingOccurrences(of: "=", with: "")
                    }
                    self.theItemId = item_id
                }
            } else if (urlStr?.contains("?id="))! {
                let urlArr = urlStr?.components(separatedBy: "?id=")
                if (urlArr?.count)! > 1 {
                    var item_id = OCTools().getSubString(urlArr![1], withRangeStardIndex: 0, andLength: "577957424858".count)
                    if (item_id?.contains("&"))! {
                        item_id = item_id?.replacingOccurrences(of: "&", with: "")
                    }
                    if (item_id?.contains("="))! {
                        item_id = item_id?.replacingOccurrences(of: "=", with: "")
                    }
                    self.theItemId = item_id
                }
            } else if (urlStr?.contains("&itemId="))! {
                let urlArr = urlStr?.components(separatedBy: "&itemId=")
                if (urlArr?.count)! > 1 {
                    var item_id = OCTools().getSubString(urlArr![1], withRangeStardIndex: 0, andLength: "577957424858".count)
                    if (item_id?.contains("&"))! {
                        item_id = item_id?.replacingOccurrences(of: "&", with: "")
                    }
                    if (item_id?.contains("="))! {
                        item_id = item_id?.replacingOccurrences(of: "=", with: "")
                    }
                    self.theItemId = item_id
                }
            } else if (urlStr?.contains("?itemId="))! {
                let urlArr = urlStr?.components(separatedBy: "?itemId=")
                if (urlArr?.count)! > 1 {
                    var item_id = OCTools().getSubString(urlArr![1], withRangeStardIndex: 0, andLength: "577957424858".count)
                    if (item_id?.contains("&"))! {
                        item_id = item_id?.replacingOccurrences(of: "&", with: "")
                    }
                    if (item_id?.contains("="))! {
                        item_id = item_id?.replacingOccurrences(of: "=", with: "")
                    }
                    self.theItemId = item_id
                }
            }
            let detailVc = SZYGoodsViewController()
            detailVc.good_item_id = self.theItemId!
            detailVc.coupone_type = "1"
            navigationController?.pushViewController(detailVc, animated: true)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       

//        LQLoadingView().SVPwillShowAndHideNoText()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /*
        kDeBugPrint(item: webView.url?.absoluteString)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6) {
            LQLoadingView().SVPHide()
        }
        
        footView.removeFromSuperview()
        headView.removeFromSuperview()
        
        let urlStr = webView.url?.absoluteString
        if (urlStr?.contains("&id="))! || (urlStr?.contains("?id="))! || (urlStr?.contains("&itemId="))!{
            
            self.view.addSubview(footView)
            self.view.addSubview(headView)
            debugPrint(urlStr!)
            
         

        }else{
            searchBtn.isHidden = false
            theItemId = nil
        }

        weak var weakSelf = self
        webView.evaluateJavaScript("document.title") { (data, error) in
            weakSelf?.titleLabel.text = JSON(data!).stringValue
        }
        */
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
//            UIApplication.shared.statusBarStyle = .default
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LQLoadingView().SVPHide()
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
