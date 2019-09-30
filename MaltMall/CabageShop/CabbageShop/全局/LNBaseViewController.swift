//
//  LNBaseViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyUserDefaults
import DeviceKit

class LNBaseViewController: UIViewController {
    var mainTableView = UITableView()
    //    数据源
    var mainTableArr = NSMutableArray()
    //    总页数
    var totalPage = ""
    //    当前分页
    var currentPage = 1
    //    右键按钮1
    var rightBtn1 = UIButton()
    //    右键按钮2
    var rightBtn2 = UIButton()
    //    标题
    var titleLabel = UILabel()
    //    导航栏高度
    var navHeight:CGFloat = 64
    //    导航栏背景图片
    var navigationBackGroundImage = UIImageView()
    //    导航栏
    var navigaView = UIView()
    //    返回按钮
    var backBtn = UIButton()
    let identyfierTable  = "identyfierTable"

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        if Device() == .iPhoneX {
            navHeight = 88
        }
        //
        if kSCREEN_HEIGHT == 812 {
            navHeight = 88
        }

        mainTableView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = kBGColor()
        setNavigaView()
        configSubViews()
        
        addHeaderRefresh()

        requestData()
        
        // 网络加载失败的通知
        NotificationCenter.default.addObserver(self, selector: #selector(networkRequestFailed(nitofication:)), name: NSNotification.Name(rawValue: LQTools().LQNetworkRequestFailed), object: nil)
        
        
        
        
        bringNavigationToFront()
    }
    
    func bringNavigationToFront() {
        self.view.bringSubview(toFront: navigaView)
    }
    
    
    @objc func networkRequestFailed(nitofication:Notification) {
        
        if mainTableView.mj_header != nil {
            mainTableView.mj_header.endRefreshing()
        }
        
        if mainTableView.mj_footer != nil {
            mainTableView.mj_footer.endRefreshing()
        }
        
        LQLoadingView().SVPHide()
    }
    
    
    ///下拉刷新
    func addHeaderRefresh()  {
        
        weak var weakSelf = self
        mainTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            weakSelf?.refreshHeaderAction()
        })
        
    }
    
    
    ///下拉刷新事件
    func refreshHeaderAction() {
        mainTableView.mj_header.endRefreshing()
    }
    
    
    ///上拉加载
    func addFooterRefresh() {
        weak var weakSelf = self
        mainTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            weakSelf?.refreshFooterAction()
        })
    }
    
    
    ///上拉加载事件
    func refreshFooterAction() {
        
    }
    
    
    
    //    子视图布局
    func configSubViews() -> Void {
        
    }
    
    
    //    网络请求
    func requestData() -> Void {
        
    }
    
    func changeStyle() {
        titleLabel.textColor = UIColor.white
        backBtn.setImage(UIImage.init(named: "nav_return_black"), for: .normal)
        rightBtn1.setTitleColor(UIColor.black, for: .normal)
        rightBtn2.setTitleColor(UIColor.black, for: .normal)
        
        navigaView.backgroundColor = UIColor.hex("#222222")
    }
    
    //    “我的” 界面需要隐藏导航栏，子控制器push和pop的时候会有空白，就重写了一个假导航栏
    func setNavigaView() {
        
        
        navigaView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: navHeight))
//        navigaView.layer.shadowColor = kGaryColor(num: 0).cgColor
//        navigaView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        navigaView.layer.shadowOpacity = 0//阴影透明度，默认0
//        navigaView.layer.shadowRadius = 0//阴影半径，默认3
//        navigaView.backgroundColor = kSetRGBColor(r: 233, g: 13, b: 68)
        navigationBackGroundImage = UIImageView.init()
        navigaView.addSubview(navigationBackGroundImage)
        
        backBtn = UIButton.init()
        
        var backBtnCenterY = navigaView.centerY+10
        
        if Device() == .iPhoneX {
            backBtnCenterY = navigaView.centerY+20
        }
        
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navigaView.centerY+20
        }
        backBtn.setImage(UIImage.init(named: "nav_return_white"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        navigaView.addSubview(backBtn)
        
        titleLabel = UILabel.init(frame: CGRect(x: 80, y: 0, width: kSCREEN_WIDTH - 160, height: 30))
        titleLabel.centerY = backBtn.centerY
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navigaView.addSubview(titleLabel)
        
        rightBtn1 = UIButton.init()
        rightBtn1.titleLabel?.textAlignment = .right
        rightBtn1.addTarget(self, action: #selector(rightAction(sender:)), for: .touchUpInside)
        rightBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn1.setTitleColor(UIColor.white, for: .normal)
        navigaView.addSubview(rightBtn1)
        
        rightBtn2 = UIButton.init()
        rightBtn2.titleLabel?.textAlignment = .right
        rightBtn2.addTarget(self, action: #selector(rightAction2(sender:)), for: .touchUpInside)
        rightBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn2.setTitleColor(UIColor.white, for: .normal)
        navigaView.addSubview(rightBtn2)
        
        self.view.addSubview(navigaView)
        
        navigationBackGroundImage.snp.makeConstraints { (ls) in
            ls.top.right.left.bottom.equalToSuperview()
        }
        
        navigaView.snp.makeConstraints { (ls) in
            ls.top.left.right.equalToSuperview()
            ls.height.equalTo(navHeight)
        }
        
        backBtn.snp.makeConstraints { (ls) in
            ls.left.equalTo(0)
            ls.centerY.equalTo(backBtnCenterY)
            ls.width.equalTo(35)
            ls.height.equalTo(35)
        }
        
        titleLabel.snp.makeConstraints { (ls) in
            ls.centerX.equalToSuperview()
            ls.centerY.equalTo(backBtn)
            ls.width.lessThanOrEqualTo(kSCREEN_WIDTH/2)
            ls.height.equalTo(30)
        }
        
        rightBtn1.snp.makeConstraints { (ls) in
            ls.right.equalToSuperview().offset(-5)
            ls.width.equalTo(50)
            ls.height.equalTo(30)
            ls.centerY.equalTo(backBtn)
        }
        
        rightBtn2.snp.makeConstraints { (ls) in
            ls.right.equalTo(rightBtn1.snp.left).offset(-5)
            ls.width.equalTo(50)
            ls.height.equalTo(30)
            ls.centerY.equalTo(backBtn)
        }
        
    }
    
    public var navigationTitle : String = "" {
        didSet {
            titleLabel.text = navigationTitle
        }
    }
    
    
    public var btnTitle : String = "" {
        
        didSet {
            rightBtn1.setTitle(btnTitle, for: .normal)
            let with = getLabWidth(labelStr: btnTitle, font: UIFont.systemFont(ofSize: 16), height: 30)+5
            rightBtn1.snp.updateConstraints { (ls) in
                ls.width.equalTo(with)
            }
        }
    }
    
    public var btnTitle2 : String = "" {
        didSet {
            rightBtn2.setTitle(btnTitle2, for: .normal)
            
            let with = getLabWidth(labelStr: btnTitle2, font: UIFont.systemFont(ofSize: 16), height: 30)+5
            rightBtn2.snp.updateConstraints { (ls) in
                ls.width.equalTo(with)
            }
        }
    }
    
    public var btnImage : String = "" {
        didSet {
            rightBtn1.setImage(UIImage.init(named: btnImage), for: .normal)
        }
    }
    
    public var btnImage2 : String = "" {
        didSet {
            rightBtn2.setImage(UIImage.init(named: btnImage2), for: .normal)
        }
    }
    
    
    public var navigationBgImage : UIImage? {
        didSet {
            navigationBackGroundImage.image = navigationBgImage
        }
    }
    
    
    @objc func backAction(sender:UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightAction(sender:UIButton) -> Void {
        
    }
    
    @objc func rightAction2(sender:UIButton) -> Void {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LQLoadingView().SVPHide()
    }
    
    //    滑动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    
    //    点击视图事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //    MARK: - 判断是否绑定 手机号 邀请码 授权
    public func bindingInformationClick(goods: SZYGoodsInformationModel) -> Bool {
        
        if goods.isBindPhone == "false" {  //没有绑定手机号
            let presentVc = LNBandingPhoneViewController.init()
            presentVc.typeBollStr = "4"
            let nav1 = LNNavigationController.init(rootViewController: presentVc)
            nav1.isNavigationBarHidden = true
            self.present(nav1, animated: true, completion: nil)
            return false
        } else if goods.isBindInviter == "false" {  //没有绑定验证码
            let presentVc = LNBandingCodeViewController.init()
            presentVc.typeBollStr = "4"
            let nav1 = LNNavigationController.init(rootViewController: presentVc)
            nav1.isNavigationBarHidden = true
            self.present(nav1, animated: true, completion: nil)
            return false
        } else if goods.isOauth == "false" {  //没有 淘宝 授权
            
            kDeBugPrint(item: "淘宝有没有授权  \((ALBBSession.sharedInstance()?.isLogin())!)")
            
            if !(ALBBSession.sharedInstance()?.isLogin())! {
                let loginService = ALBBSDK.sharedInstance()
                loginService?.auth(self, successCallback: { (session) in
                    var pageUrl = goods.oauthUrl
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
                    let myView = SZYwebViewController.init()
                    
                    let ret = AlibcTradeSDK.sharedInstance().tradeService()?.open(byBizCode: "detail", page: page, webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                        JGLog("\(back)")

                    }, tradeProcessFailedCallback: { (error) in
                        JGLog("\(error)")

                    })
                    
                    
                    
//                   let ret =  AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: self, showParams: showParam, taoKeParams: taoKeParams, trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//                        JGLog("\(back)")
//                    }, tradeProcessFailedCallback: { (error) in
//                        JGLog("\(error)")
//
//                    })
                    
                    
//                    let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//                        kDeBugPrint(item: ls)
//                    }, tradeProcessFailedCallback: { (error) in
//                        kDeBugPrint(item: error)
//                    })
                    if (ret == 1) {
                        let nav1 = LNNavigationController.init(rootViewController: myView)
                        nav1.isNavigationBarHidden = true
                        self.present(nav1, animated: true, completion: nil)
                    }
                }, failureCallback: { (session, error) in
                    setToast(str: "授权失败!")
//                        self.window?.rootViewController = LNMainTabBarController()
                })
            } else {
                kDeBugPrint(item: goods.oauthUrl)
                var pageUrl = goods.oauthUrl
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
                showParam.isNeedPush = true
                showParam.nativeFailMode = .jumpH5
                let myView = SZYwebViewController.init()
//                let ret = AlibcTradeSDK.sharedInstance().tradeService()?.open(byBizCode: "trade", page: page, webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//                    JGLog("\(back)")
//
//                }, tradeProcessFailedCallback: { (error) in
//                    JGLog("\(error)")
//                })
                
                
                
                let ret =  AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                    JGLog("\(back)")
                }, tradeProcessFailedCallback: { (error) in
                    JGLog("\(error)")

                })
                
                
                
//                let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//                    kDeBugPrint(item: ls)
//                }, tradeProcessFailedCallback: { (error) in
//                    kDeBugPrint(item: error)
//                })
                if (ret == 1) {
                    let nav1 = LNNavigationController.init(rootViewController: myView)
                    nav1.isNavigationBarHidden = true
                    self.present(nav1, animated: true, completion: nil)
                }
            }
            
            return false
        }
        
        return true
    }
    //    MARK: - 判断是否登陆
    public func loginClick() -> Bool {
        if Defaults[kUserToken] == nil || Defaults[kUserToken] == "" {
            let presentVc = JGLoginViewController.init()
//            presentVc.typeString = "2"
            let nav = LNNavigationController.init(rootViewController: presentVc)
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    public func jumpPageClick(code: String, urlStr: String) -> Bool {
        
        if code == "4002" || code == "4003" || code == "4004" || code == "4005" {
            let tankuan = SZYCertificationViewController()
            tankuan.daliCanshu = self
            tankuan.code = code
            tankuan.urlString = urlStr
            tankuan.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
            tankuan.modalPresentationStyle = .custom
            self.modalPresentationStyle = .currentContext
            self.present(tankuan, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    public func taokeParam() -> (AlibcTradeTaokeParams) {
        let tt = AlibcTradeTaokeParams()
//        taoke.pid =[[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"pid"];
//        taoke.subPid = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"subPid"];
//        taoke.unionId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"unionId"];
//
//        taoke.adzoneId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"adzoneId"];
//        id extParams =  [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"extParams"];
//        if([extParams isKindOfClass:[NSDictionary class]]){
//            taoke.extParams = extParams;
//        }else {
//            // 解析字符串
//            taoke.extParams = [self dictionaryWithJsonString:extParams];
//        }
        tt.pid = (ALiTradeSDKShareParam .sharedInstance()?.taoKeParams .object(forKey: "pid") as! String)
        tt.subPid = (ALiTradeSDKShareParam .sharedInstance()?.taoKeParams .object(forKey: "subPid") as! String)

        tt.unionId = (ALiTradeSDKShareParam .sharedInstance()?.taoKeParams .object(forKey: "unionId") as! String)

        tt.adzoneId = (ALiTradeSDKShareParam .sharedInstance()?.taoKeParams .object(forKey: "adzoneId") as! String)
        let extParamsq = ALiTradeSDKShareParam .sharedInstance()?.taoKeParams.object(forKey: "extParams")

        if extParamsq is NSDictionary {
            let dict : NSDictionary = extParamsq as! NSDictionary
            tt.extParams = (dict as! [AnyHashable : Any])
        }else{
            let ss : String = extParamsq as! String
            
            tt.extParams = self.getDictionaryFromJSONString(jsonString: ss) as! [AnyHashable : Any]
        }
    
        return tt
    }
   
   public func getTaokeParam() -> AlibcTradeTaokeParams {
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
    
    public  func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        
        
    }
    public func bindingClick() -> Bool{
//        Defaults[kBandingPhone] = "1"
//        Defaults[kBandingInviter] = "1"
        
        if Defaults[kBandingPhone] != "1" {
            let presentVc = LNBandingPhoneViewController.init()
            let nav = LNNavigationController.init(rootViewController: presentVc)
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
            
            return false
        }
        if Defaults[kBandingInviter] != "1" {
            let presentVc = LNBandingCodeViewController.init()
            let nav = LNNavigationController.init(rootViewController: presentVc)
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    //    #MARK:- 获取点击事件要跳转的页面
    func moduleIdentifier(str: String, vc: UIViewController) {
        var typeStr = String()
        let dict:NSMutableDictionary = NSMutableDictionary()
        var stri = String()
        
        if !str.contains("hongtang") {
            return
        }
        
        if str.contains("webview") {
            chooseVc(chooseStr: "webview", dict: dict, url: str.replacingOccurrences(of: "hongtang://webview?url=", with: ""), vc: vc)
            return
        }
        
        let arr = str.components(separatedBy: "//")
        if arr.count > 1 {
            stri = arr[1]
        }
        
        var stri1 = String()
        let arr1 = stri.components(separatedBy: "?")
        if arr1.count > 1 {
            typeStr = arr1[0]
            stri1 = arr1[1]
        } else {
            typeStr = arr1[0]
            chooseVc(chooseStr: typeStr, dict: dict, url: "", vc: vc)
            return
        }
        
        let arr2 = stri1.components(separatedBy: "&")
        if arr2.count > 0 {
            for index in 0..<arr2.count {
                let aa = arr2[index]
                let arrrr = aa.components(separatedBy: "=")
                dict.setObject(arrrr[1], forKey: arrrr[0] as NSCopying)
            }
        }
        chooseVc(chooseStr: typeStr, dict: dict, url: "", vc: vc)
    }
    func chooseVc(chooseStr:String, dict:NSMutableDictionary, url: String, vc: UIViewController) {
        switch chooseStr {
        case "home":
            kDeBugPrint(item: "首页")
            vc.navigationController?.tabBarController?.selectedIndex = 0
            break
        case "quanzi":
            kDeBugPrint(item: "圈子")
            vc.navigationController?.tabBarController?.selectedIndex = 2
            break
        case "taobao":
            kDeBugPrint(item: "淘宝")
            let item = JTHtaoBaoViewController()
            item.superViewController = vc
            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "jingdong":
            kDeBugPrint(item: "京东")
//            let item = YHJDorPDDPageVC()
//            item.typeIntString = "2"
//            vc.navigationController?.pushViewController(item, animated: true)
            let item = JDorPDDScreeningVC()
            item.typeIntString = "2"
            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "pinduoduo":
            kDeBugPrint(item: "拼多多")
//            let item = YHJDorPDDPageVC()
//            item.typeIntString = "3"
//            vc.navigationController?.pushViewController(item, animated: true)
            let item = JDorPDDScreeningVC()
            item.typeIntString = "3"
            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "entrance":
            kDeBugPrint(item: "超级入口")
            //H5
            break
        case "category":
            kDeBugPrint(item: "超级分类")
            vc.navigationController?.tabBarController?.selectedIndex = 1
            break
        case "user":
            kDeBugPrint(item: "个人中心")
            vc.navigationController?.tabBarController?.selectedIndex = 3
            break
        case "miaosha":
            kDeBugPrint(item: "限时秒杀")
            let item = LNMiaoshaViewController()
            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "invite":
            kDeBugPrint(item: "邀请海报")
            let item = LNInviterViewController()
            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "shouyi":
            kDeBugPrint(item: "我的收益")
            
//            因为没办法获取用户信息, 所以不能实现这个跳转了
            
//            let vc = LNMyEarningViewController()
//            vc.userModel = userModel
//            vc.selectIndex = 1
//            vc.navigationController?.pushViewController(item, animated: true)
            
            break
        case "order":
            kDeBugPrint(item: "我的订单")
            
            let item = LNOrderViewController()
            item.select_sort = ""
            vc.navigationController?.pushViewController(item, animated: true)
            
            break
        case "withdraw":
            kDeBugPrint(item: "余额提现")
            
//            let item = JTHWithdrawViewController()
//            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "team":
            kDeBugPrint(item: "我的团队")
            
//            let item = JTHNewTeamDetailViewController()
//            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "favourite":
            kDeBugPrint(item: "我的收藏")
            
            let item = LNShowCollectViewController()
            item.selectIndex = 0
            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "kefu":
            kDeBugPrint(item: "专属客服")
//            let item = JTHLNCustomServiceViewController()
//            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "zhiyin":
            kDeBugPrint(item: "新手指引")
//            let item = JTHNewUserViewController()
//            item.isNewUser = true
//            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "wenti":
            kDeBugPrint(item: "常见问题")
//            let item = JTHNewUserViewController()
//            item.isNewUser = false
//            vc.navigationController?.pushViewController(item, animated: true)
            break
        case "feedback":
            kDeBugPrint(item: "意见反馈")
            vc.navigationController?.pushViewController(LNSubmitSuggestViewController(), animated: true)
            break
        case "about":
            kDeBugPrint(item: "关于我们")
            vc.navigationController?.pushViewController(LNAboutUsViewController(), animated: true)
            break
        case "signin":
            kDeBugPrint(item: "每日签到")
            
            break
        case "daka":
            kDeBugPrint(item: "早起打卡")
            
            break
        case "redpacket":
            kDeBugPrint(item: "购物红包")
            break
        case "lingyuangou":
            kDeBugPrint(item: "零钱抢购")
            break
        case "webview":
            kDeBugPrint(item: "H5网页")
            var pageUrl = url.replacingOccurrences(of: " ", with: "")
            if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
                if !pageUrl.contains(Defaults[kUserToken]!) {
                    if !pageUrl.contains("?") {
                        pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
                    } else {
                        pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
                    }
                }
            }
            
//            let page = AlibcTradePageFactory.page(pageUrl)
            let taoKeParams = AlibcTradeTaokeParams.init()
            taoKeParams.pid = nil
            let showParam = AlibcTradeShowParams.init()
            showParam.openType = .auto
            let myView = SZYwebViewViewController.init()
            myView.webTitle = ""
//            let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//                kDeBugPrint(item: "======11111=======")
//            }, tradeProcessFailedCallback: { (error) in
//                kDeBugPrint(item: error)
//            })
//            if (ret == 1) {
//                vc.navigationController?.pushViewController(myView, animated: true)
//            }
            let ret =  AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                JGLog("\(back)")
            }, tradeProcessFailedCallback: { (error) in
                JGLog("\(error)")
                
            })
            if (ret == 1) {
                                vc.navigationController?.pushViewController(myView, animated: true)
                            }
            
            
            break
        case "detail":
            kDeBugPrint(item: "优惠券详情")
            
            
            break
        default:
            break
        }
        kDeBugPrint(item: chooseStr)
        kDeBugPrint(item: dict)
    }
    
}
extension LNBaseViewController : SZYCertificationViewControllerDelegate {
    func getButtonClick(tag: Int, code: String, urlString: String) {
        
        if code == "4002" {
            let presentVc = JGLoginViewController.init()
//            presentVc.typeString = "2"
            let nav = LNNavigationController.init(rootViewController: presentVc)
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
        }
        if code == "4003" {
            let presentVc = LNBandingPhoneViewController.init()
            let nav = LNNavigationController.init(rootViewController: presentVc)
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
        } else if code == "4004" {
            let presentVc = LNBandingCodeViewController.init()
            let nav = LNNavigationController.init(rootViewController: presentVc)
            nav.isNavigationBarHidden = true
            self.present(nav, animated: true, completion: nil)
        } else if code == "4005" {
            if !(ALBBSession.sharedInstance()?.isLogin())! {
                let loginService = ALBBSDK.sharedInstance()
                loginService?.auth(self, successCallback: { (session) in
                    var pageUrl = urlString
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
                    let myView = SZYwebViewController.init()
//                    let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//                        kDeBugPrint(item: ls)
//                    }, tradeProcessFailedCallback: { (error) in
//                        kDeBugPrint(item: error)
//                    })
//                    if (ret == 1) {
//                        let nav = LNNavigationController.init(rootViewController: myView)
//                        nav.isNavigationBarHidden = true
//                        self.present(nav, animated: true, completion: nil)
//                    }
                    let ret =  AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                        JGLog("\(back)")
                    }, tradeProcessFailedCallback: { (error) in
                        JGLog("\(error)")
                        
                    })
                    if (ret == 1) {
                                                let nav = LNNavigationController.init(rootViewController: myView)
                                                nav.isNavigationBarHidden = true
                                                self.present(nav, animated: true, completion: nil)
                                            }
                }, failureCallback: { (session, error) in
                    self.view.window?.rootViewController = LNMainTabBarController()
                })
            } else {
                var pageUrl = urlString
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
                let myView = SZYwebViewController.init()
//                let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//                    kDeBugPrint(item: ls)
//                }, tradeProcessFailedCallback: { (error) in
//                    kDeBugPrint(item: error)
//                })
//                if (ret == 1) {
//                    let nav = LNNavigationController.init(rootViewController: myView)
//                    nav.isNavigationBarHidden = true
//                    self.present(nav, animated: true, completion: nil)
//                }
                let ret =  AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                    JGLog("\(back)")
                }, tradeProcessFailedCallback: { (error) in
                    JGLog("\(error)")
                    
                })
                
                if (ret == 1) {
                                        let nav = LNNavigationController.init(rootViewController: myView)
                                        nav.isNavigationBarHidden = true
                                        self.present(nav, animated: true, completion: nil)
                                    }
            }
        }
        
    }
}


//MARK: -
//MARK: - 传进去字符串,生成二维码图片
public func setupQRCodeImage(_ text: String, image: UIImage?) -> UIImage {
    //创建滤镜
    let filter = CIFilter(name: "CIQRCodeGenerator")
    filter?.setDefaults()
    //将url加入二维码
    filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
    //取出生成的二维码（不清晰）
    if let outputImage = filter?.outputImage {
        //生成清晰度更好的二维码
        let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
        //如果有一个头像的话，将头像加入二维码中心
        if var image = image {
            //给头像加一个白色圆边（如果没有这个需求直接忽略）
            image = circleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
            //合成图片
            let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 100, height: 100)
            
            return newImage
        }
        
        return qrCodeImage
    }
    
    return UIImage()
}

//image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
func syntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage{
    //开启图片上下文
    UIGraphicsBeginImageContext(image.size)
    //绘制背景图片
    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    
    let x = (image.size.width - width) * 0.5
    let y = (image.size.height - height) * 0.5
    iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
    //取出绘制好的图片
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //关闭上下文
    UIGraphicsEndImageContext()
    //返回合成好的图片
    if let newImage = newImage {
        return newImage
    }
    return UIImage()
}

//MARK: - 生成高清的UIImage
func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
    let integral: CGRect = image.extent.integral
    let proportion: CGFloat = min(size/integral.width, size/integral.height)
    
    let width = integral.width * proportion
    let height = integral.height * proportion
    let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
    let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
    
    let context = CIContext(options: nil)
    let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
    
    bitmapRef.interpolationQuality = CGInterpolationQuality.none
    bitmapRef.scaleBy(x: proportion, y: proportion);
    bitmapRef.draw(bitmapImage, in: integral);
    let image: CGImage = bitmapRef.makeImage()!
    return UIImage(cgImage: image)
}

//生成边框
func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
    let imageWidth = sourceImage.size.width + 2 * borderWidth
    let imageHeight = sourceImage.size.height + 2 * borderWidth
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
    UIGraphicsGetCurrentContext()
    
    let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width:sourceImage.size.height) * 0.5
    let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    bezierPath.lineWidth = borderWidth
    borderColor.setStroke()
    bezierPath.stroke()
    bezierPath.addClip()
    sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}
