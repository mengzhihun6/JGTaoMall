//
//  AppDelegate.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import UserNotifications
import AdSupport
import SwiftyUserDefaults
import IQKeyboardManagerSwift
import SwiftyJSON
import JDKeplerSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    fileprivate var adImage = UIImageView()
    //声明定时器
    fileprivate var timer : Timer?
    fileprivate var timeNow = 4
    fileprivate var downBuuton = UIButton()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        设置当前启动之后的根控制器
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor=UIColor.white
//
//        //判断是否是第一次登陆
//        if UserDefaults.standard.bool(forKey: "firstLaunch") == false{
//            UserDefaults.standard.set(true, forKey: "firstLaunch")
//            self.window?.rootViewController = GH_LunBoViewController()
//        }else{
//            self.window!.rootViewController=LNMainTabBarController()
//
//        }
        let show:Bool = (UserDefaults.standard.object(forKey: "show") != nil)
        //判断
        if show == false{
            //判断赋予的值是否相同
            UserDefaults.standard.set(true, forKey: "show")
            //初始化
            self.window?.rootViewController = GH_LunBoViewController()
        }else{
            self.window!.rootViewController=LNMainTabBarController()
        }
        
        
        self.window!.makeKeyAndVisible()
        
        /*
         *  初始化ShareSDK应用
         *
         *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
         *  @param importHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
         *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
         */
        
        ShareSDK.registerActivePlatforms( [ SSDKPlatformType.typeWechat.rawValue], onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform {
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
        }, onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform {
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: kWXAppKey, appSecret: kWXAppSecret)
                default:
                    break
                }
        })
        
//        注册极光推送
        let entity = JPUSHRegisterEntity.init()
        if #available(iOS 12.0, *) {
            entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue)|UInt8(JPAuthorizationOptions.badge.rawValue)|UInt8(JPAuthorizationOptions.sound.rawValue)|UInt8(JPAuthorizationOptions.providesAppNotificationSettings.rawValue))
        } else { // Fallback on earlier versions
            entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue)|UInt8(JPAuthorizationOptions.badge.rawValue)|UInt8(JPAuthorizationOptions.sound.rawValue))
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        // Optional
        // 获取IDFA
        // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuid
        
        // Required
        // init Push
        // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
        // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
        
//        JPUSHService.setup(withOption: launchOptions, appKey: LQTools().JPUSHAppKey, channel: nil, apsForProduction: false)
        JPUSHService.setup(withOption: launchOptions, appKey: LQTools().JPUSHAppKey, channel: nil, apsForProduction: true, advertisingIdentifier: "123")  //apsForProduction:  是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
        JPUSHService.setBadge(0)
        
        //        在前台时收到推送时调用
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(nofication:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidLogin(nofication:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        // Override point for customization after application launch.
        application.applicationIconBadgeNumber = 0
        
//        阿里百川，里面的参数主要都是按照百川文档来的，后期如果需要有改动，最好先去看文档。
        ALBBSDK.sharedInstance()?.albbsdkInit()
        ALBBSDK.sharedInstance().setAppkey(LQTools().TAOBAOAppKey)
        ALBBSDK.sharedInstance().setAuthOption(NormalAuth)

        AlibcTradeSDK.sharedInstance().setDebugLogOpen(true)
        let taokeParams = AlibcTradeTaokeParams.init()
        taokeParams.pid = LQTools().TAOBAOAppKey
        AlibcTradeSDK.sharedInstance().setTaokeParams(taokeParams)
        AlibcTradeSDK.sharedInstance().setISVCode("nieyun_isv_code")
//        AlibcTradeSDK.sharedInstance().setIsForceH5(true)
        AlibcTradeSDK.sharedInstance()?.setIsvVersion("2.2.2")
        AlibcTradeSDK.sharedInstance()?.asyncInit(success: {
            JGLog("百川SDK初始化成功")
        }, failure: { (error) in
            JGLog("百川SDK初始化失败")
            print(error?.localizedDescription as Any)
        })

//        京东的，如果有需要，可以直接去京东开普勒平台申请相关需求，打开下面代码替换JDAppKey和JDAppSecret即可。
        
//        AppMonitor.turn(onAppMonitorRealtimeDebug:["debug_api_url":"http://muvp.alibaba-inc.com/online/UploadRecords.do","debug_key":"ALITrade_IOS_lingfeng_20170228"] )
        
//        KeplerApiManager.sharedKPService().asyncInitSdk(LQTools().JDAppKey, secretKey: LQTools().JDAppSecret, sucessCallback: {
//            kDeBugPrint(item: "JD 注册成功")                
//        }) { (error) in
//            kDeBugPrint(item: "JD 注册失败")
//        }
        
        setKeyBoard()
        BaiduMobStat.default().start(withAppId: "2c4304327f512")
        // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
        //        微信支付
        //        enableMTA：是否支持数据上报
        WXApi.registerApp(kWXAppKey, enableMTA: true)
        
        //bug
        Bugly.start(withAppId: "9d47ecba80")
//        在LNMainTabBarController类里面会重新请求启动图，请求完成之后会保存到SD里面，每次启动之后，判断能不能根据地址获取到图片m，如果不能的话，就不要显示启动广告了。有的话再显示
//        if Defaults[kLastImage] == nil {
//            return true
//        }
//        
//        if let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: Defaults[kLastImage]!) {
//            
//            adImage = UIImageView.init(frame: (self.window?.bounds)!)
//            adImage.image = image
//            self.window?.addSubview(adImage)
//            
////            给i图片添加点击事件
//            let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(viewTheBigImage(ges:)))
//            singleTap.numberOfTapsRequired = 1
//            adImage.addGestureRecognizer(singleTap)
////            打开imageView的交互
//            adImage.isUserInteractionEnabled = true
//            
//            var navHeight:CGFloat = 64
//            if kSCREEN_HEIGHT == 812 {
//                navHeight = 88
//            }
//
//            downBuuton.frame = CGRect(x: kSCREEN_WIDTH-80, y: navHeight/2, width: 65, height: 28)
//            downBuuton.setTitle("3秒跳过广告", for: .normal)
//            downBuuton.addTarget(self, action: #selector(skipAdView(sender:)), for: .touchUpInside)
//            downBuuton.cornerRadius = downBuuton.height/2
//            downBuuton.backgroundColor = kGaryColor(num: 30)
//            downBuuton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//            adImage.addSubview(downBuuton)
//            
//            DispatchQueue.main.async {
//                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.changeBtnTitle), userInfo: nil, repeats: true)
//                RunLoop.main.add(self.timer!, forMode: .commonModes)
//            }
//
//        }
        
        AppDelegate.tiaozhuan()
        return true
    }
    
//    定时器方法
    @objc fileprivate func changeBtnTitle(){
        
        timeNow = timeNow-1
        
        if timeNow < 0 {
//            倒计时结束，移除图片，并将定时器失效置为nil
            adImage.removeFromSuperview()
            self.timer?.invalidate()
            self.timer = nil
        }else{
            downBuuton.setTitle("\(timeNow)秒跳过广告", for: .normal)
        }
    }
    
//    查看广告详情
    @objc  func viewTheBigImage(ges:UITapGestureRecognizer) {
        let tabbar = self.window?.rootViewController as? LNMainTabBarController
        let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
        
        if (nav?.childViewControllers.count)!>0 {
            nav?.childViewControllers[0].presentedViewController?.dismiss(animated: false, completion: nil)
        }

        let webVc = LQWebViewController()
        webVc.webUrl = Defaults[kLastUrl]!
        webVc.webTitle = "详情"
        nav?.pushViewController(webVc, animated: true)
        ges.view?.removeFromSuperview()
    }
    
    @objc  func skipAdView(sender:UIButton) {
        // 点击跳过，移除图片，并将定时器失效置为nil
        adImage.removeFromSuperview()
        self.timer?.invalidate()
        self.timer = nil
    }
    
//    配置一下IQKeyboard，可根据自己的需要来，不想用的话，将manager.enable = false
    private func setKeyBoard() {
        
        let manager = IQKeyboardManager.shared
        manager.enable = true
        manager.shouldResignOnTouchOutside = true
        manager.shouldToolbarUsesTextFieldTintColor = true
        manager.enableAutoToolbar = false
        
    }
    
    //注册标签（Tags）和别名（Alias）标签可以有多个，但是别名只能有一个。
    @objc func networkDidLogin(nofication:NSNotification) {
        let registrationID = JPUSHService.registrationID()
        kDeBugPrint(item: registrationID)
        
        let version = ""
        let tags = NSSet.init(objects: version) as! Set<String>
        
        
        JPUSHService.setTags(tags, completion: { (iResCode, iTags, iAlias) in
            
        }, seq: 1)
        
    }
    
//    极光的东西
    @objc func networkDidReceiveMessage(nofication:NSNotification) {
        kDeBugPrint(item: nofication)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if AlibcTradeSDK.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
            setToast(str: "从淘宝返回")
        }
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return WXApi.handleOpen(url, delegate: self)

//        if url.absoluteString.contains(kWXAppKey) {
//            return WXApi.handleOpen(url, delegate: self)
//        }else{
//
//
//            let param:[String:Any] = ["UIApplicationOpenURLOptionsOpenInPlaceKey":"0",
//                       "UIApplicationOpenURLOptionsSourceApplicationKey":"com.taobao.taobao4iphone"]
//            let flag = (AlibcTradeSDK.sharedInstance()?.application(app, open: url, options: param))!
//
//            return flag
//        }
        
//        这里注意一下，如果以后增加了淘宝的相关操作，按照淘宝官方流程操作完了，还是集成失败。那就要去查一下这里的写法。我这里只适用于目前的这些功能
        let param:[String:Any] = ["UIApplicationOpenURLOptionsOpenInPlaceKey":"0",
                                  "UIApplicationOpenURLOptionsSourceApplicationKey":"0"]
        let flag = (AlibcTradeSDK.sharedInstance()?.application(app, open: url, options: param))!
        
        return flag
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        kDeBugPrint(item: "进入后台")
//        进入后台之后，将首页的s定时器暂停
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LNInvalidateTheTimer_Notification"), object: self, userInfo: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
//        h应用回到前台之后，将暂停的定时器重新唤醒。（判断当前显示的是不是主页，如果不是就不必唤醒）
        if OCTools().getCurrentVC().isKind(of: LNPageViewController.self) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "LNresetTheTimer_Notification"), object: self, userInfo: nil)
        }
        
//        将APP图标上面的通知数字清空
        application.applicationIconBadgeNumber = 0

//        下面的方法是监听粘贴板，如果用户没有登录，就不必监听了，需要改的话，直接删掉就行了。
        if Defaults[kUserToken] == nil {
            return
        }
        
        let text = UIPasteboard.general.string
        if text == nil {
            return
        }
        if (text?.count)! > 0{
//            kDeBugPrint(item: "++++++++++ \(text!)")
            
            var urlString : String = ""
            if text!.count == 15 { // 处理手机号前后 字符串
                let index3 = text!.index(text!.startIndex, offsetBy: 1)
                let index4 = text!.index(text!.startIndex, offsetBy: 14)
                urlString = String(text![index3..<index4])
            }
            if urlString.contains(" ") {
                urlString = urlString.replacingOccurrences(of: " ", with: "")
            }
            
            
            if isPurnInt(string: urlString) == true { // 判断手机号
                return
            }
            if isPurnFloat(string: urlString) == true { //判断是否是纯数字
                return
            }
            if isPurnFloat(string: text!) == true { //判断是否是纯数字
                return
            }

            
            let request = SKRequest.init()
            weak var weakSelf = self
            request.setParam("1" as NSObject, forKey: "type")
            request.setParam(text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSObject, forKey: "itemid")
            request.callGET(withUrl: LNUrls().kShow_coupon_deltai) { (response) in
               
                let pasteboard = UIPasteboard.general
                pasteboard.string = ""
                
                let tabbar = weakSelf!.window?.rootViewController as? LNMainTabBarController
                let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
                
                let vc = JGPasteSearchViewController()
                vc.Delegate = weakSelf
                vc.modalPresentationStyle = .custom
                
                if !(response?.success)! {
                    
                    vc.typeString = "1"
                    vc.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
                    
                    let nav1 = LNNavigationController.init(rootViewController: vc)
                    nav1.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
                    nav1.isNavigationBarHidden = true
                    nav1.modalPresentationStyle = .custom
                    
                    nav!.modalPresentationStyle = .currentContext
                    nav!.present(nav1, animated: false, completion: nil)
                    
                    return
                }
                
                vc.typeString = "2"
                var goodsInformationModel = SZYGoodsInformationModel()
                goodsInformationModel = SZYGoodsInformationModel.setupValues(json: JSON((response?.data["data"])!))
                vc.goods = goodsInformationModel
                vc.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
                
                let nav1 = LNNavigationController.init(rootViewController: vc)
                nav1.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
                nav1.isNavigationBarHidden = true
                nav1.modalPresentationStyle = .custom
                
                nav!.modalPresentationStyle = .currentContext
                nav!.present(nav1, animated: false, completion: nil)
            }
        }
    }
    
    func isJudgeCharNumber(str: String, char: String) -> Int {
//        kDeBugPrint(item: " 判断传入数据  输出结果 \(str) \(char)")
        var num:Int = 0
        for index in str.indices.indices {
            let sss: String = String(format: "\(str[index])")
//            char.caseInsensitiveCompare(sss as String).rawValue   相等 值为零
            if char == sss {
                num += 1
            }
        }
        return num
        
    }
    
    func isPurnInt(string: String) -> Bool {
//        let scan: Scanner = Scanner(string: string)
//        var val:Float = 0
//        return scan.scanFloat(&val) && scan.isAtEnd
        let scan: Scanner = Scanner(string: string)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    func isPurnFloat(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Float = 0
        return scan.scanFloat(&val) && scan.isAtEnd
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


//  MARK: - 弹框处理事件
extension AppDelegate : JGPasteSearchViewControllerDelegate {
    func JGPasteSearchViewControllerGoToDetail(goods: SZYGoodsInformationModel) {
        
//        let tabbar = self.window?.rootViewController as? LNMainTabBarController
//        let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
//
//        let detailVc = SZYGoodsViewController()
//        detailVc.good_item_id = goods.item_id
//        detailVc.coupone_type = goods.type
//        detailVc.goodsUrl = goods.pic_url
//        detailVc.GoodsInformationModel = goods
//        nav!.pushViewController(detailVc, animated: true)
        
        
        let tabbar = self.window?.rootViewController as? LNMainTabBarController
        let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
        
        
        let ressult = LQSearchResultViewController()
        ressult.keyword = goods.title
        ressult.type  = "1"
        nav!.pushViewController(ressult, animated: true)
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = ""
        
        
    }

}
//
////  MARK: - 弹框处理事件
//extension AppDelegate : BCTPasteSearchViewControllerDelegate {
//    func delegateScroll(_ senderTag: Int, _ goods: SZYGoodsInformationModel) {
//        let tabbar = self.window?.rootViewController as? LNMainTabBarController
//        let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
//
//        if senderTag == 50 {
//            let detailVc = SZYGoodsViewController()
//            detailVc.good_item_id = goods.item_id
//            detailVc.coupone_type = goods.type
//            detailVc.goodsUrl = goods.pic_url
//            detailVc.GoodsInformationModel = goods
//
//            nav!.pushViewController(detailVc, animated: true)
//        } else if senderTag == 51 {
//            if goods.isBindPhone == "false" {  //没有绑定手机号
//                let presentVc = LNBandingPhoneViewController.init()
//                presentVc.typeBollStr = "5"
//                let nav1 = LNNavigationController.init(rootViewController: presentVc)
//                nav1.isNavigationBarHidden = true
//                nav!.present(nav1, animated: true, completion: nil)
//            } else if goods.isBindInviter == "false" {  //没有绑定验证码
//                let presentVc = LNBandingCodeViewController.init()
//                presentVc.typeBollStr = "5"
//                let nav1 = LNNavigationController.init(rootViewController: presentVc)
//                nav1.isNavigationBarHidden = true
//                nav!.present(nav1, animated: true, completion: nil)
//            } else if goods.isOauth == "false" {  //没有 淘宝 授权
//                if !(ALBBSession.sharedInstance()?.isLogin())! {
//                    let loginService = ALBBSDK.sharedInstance()
//                    loginService?.auth(nav, successCallback: { (session) in
//                        var pageUrl = goods.oauthUrl
//                        if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
//                            if !pageUrl.contains(Defaults[kUserToken]!) {
//                                if !pageUrl.contains("?") {
//                                    pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
//                                } else {
//                                    pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
//                                }
//                            }
//                        }
//
//                        let page = AlibcTradePageFactory.page(pageUrl)
//                        let taoKeParams = AlibcTradeTaokeParams.init()
//                        taoKeParams.pid = nil
//                        let showParam = AlibcTradeShowParams.init()
//                        showParam.openType = .auto
//                        let myView = SZYwebViewController.init()
////                        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
////                            kDeBugPrint(item: ls)
////                        }, tradeProcessFailedCallback: { (error) in
////                            kDeBugPrint(item: error)
////                        })
////                        if (ret == 1) {
////                            let nav1 = LNNavigationController.init(rootViewController: myView)
////                            nav1.isNavigationBarHidden = true
////                            nav!.present(nav1, animated: true, completion: nil)
////                        }
//                        let ret =    AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: goods.coupon_url, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//                        }, tradeProcessFailedCallback: { (error) in
//                        })
//                        if (ret == 1) {
//                            let nav1 = LNNavigationController.init(rootViewController: myView)
//                            nav1.isNavigationBarHidden = true
//                            nav!.present(nav1, animated: true, completion: nil)
//                        }
//
//                    }, failureCallback: { (session, error) in
//                        setToast(str: "授权失败!")
////                        self.window?.rootViewController = LNMainTabBarController()
//                    })
//                } else {
//                    kDeBugPrint(item: goods.oauthUrl)
//                    var pageUrl = goods.oauthUrl
//                    if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
//                        if !pageUrl.contains(Defaults[kUserToken]!) {
//                            if !pageUrl.contains("?") {
//                                pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
//                            } else {
//                                pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
//                            }
//                        }
//                    }
//                    let page = AlibcTradePageFactory.page(pageUrl)
//                    let taoKeParams = AlibcTradeTaokeParams.init()
//                    taoKeParams.pid = nil
//                    let showParam = AlibcTradeShowParams.init()
//                    showParam.openType = .auto
//                    let myView = SZYwebViewController.init()
////                    let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
////                        kDeBugPrint(item: ls)
////                    }, tradeProcessFailedCallback: { (error) in
////                        kDeBugPrint(item: error)
////                    })
////                    if (ret == 1) {
////                        let nav1 = LNNavigationController.init(rootViewController: myView)
////                        nav1.isNavigationBarHidden = true
////                        nav!.present(nav1, animated: true, completion: nil)
////                    }
//
//                    let ret =    AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: goods.coupon_url, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//                    }, tradeProcessFailedCallback: { (error) in
//                    })
//                    if (ret == 1) {
//                        let nav1 = LNNavigationController.init(rootViewController: myView)
//                        nav1.isNavigationBarHidden = true
//                        nav!.present(nav1, animated: true, completion: nil)
//                    }
//                }
//            } else {
//                let pasteboard = UIPasteboard.general
//                pasteboard.string = goods.share.kouling
//                setToast(str: "口令转换成功, 已自动复制到粘贴板!")
//            }
//        } else if senderTag == 52 {
//            if goods.isBindPhone == "false" {  //没有绑定手机号
//                let presentVc = LNBandingPhoneViewController.init()
//                presentVc.typeBollStr = "5"
//                let nav1 = LNNavigationController.init(rootViewController: presentVc)
//                nav1.isNavigationBarHidden = true
//                nav!.present(nav1, animated: true, completion: nil)
//            } else if goods.isBindInviter == "false" {  //没有绑定验证码
//                let presentVc = LNBandingCodeViewController.init()
//                presentVc.typeBollStr = "5"
//                let nav1 = LNNavigationController.init(rootViewController: presentVc)
//                nav1.isNavigationBarHidden = true
//                nav!.present(nav1, animated: true, completion: nil)
//            } else if goods.isOauth == "false" {  //没有 淘宝 授权
//                if !(ALBBSession.sharedInstance()?.isLogin())! {
//                    let loginService = ALBBSDK.sharedInstance()
//                    loginService?.auth(nav, successCallback: { (session) in
//                        var pageUrl = goods.oauthUrl
//                        if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
//                            if !pageUrl.contains(Defaults[kUserToken]!) {
//                                if !pageUrl.contains("?") {
//                                    pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
//                                } else {
//                                    pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
//                                }
//                            }
//                        }
//                        let page = AlibcTradePageFactory.page(pageUrl)
//                        let taoKeParams = AlibcTradeTaokeParams.init()
//                        taoKeParams.pid = nil
//                        let showParam = AlibcTradeShowParams.init()
//                        showParam.openType = .auto
//                        let myView = SZYwebViewController.init()
////                        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
////                            kDeBugPrint(item: ls)
////                        }, tradeProcessFailedCallback: { (error) in
////                            kDeBugPrint(item: error)
////                        })
////                        if (ret == 1) {
////                            let nav1 = LNNavigationController.init(rootViewController: myView)
////                            nav1.isNavigationBarHidden = true
////                            nav!.present(nav1, animated: true, completion: nil)
////                        }
//
//                        let ret =    AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: goods.coupon_url, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//                        }, tradeProcessFailedCallback: { (error) in
//                        })
//                        if (ret == 1) {
//                            let nav1 = LNNavigationController.init(rootViewController: myView)
//                            nav1.isNavigationBarHidden = true
//                            nav!.present(nav1, animated: true, completion: nil)
//                        }
//
//                    }, failureCallback: { (session, error) in
//                        setToast(str: "授权失败!")
////                        self.window?.rootViewController = LNMainTabBarController()
//                    })
//                } else {
//                    kDeBugPrint(item: goods.oauthUrl)
//                    var pageUrl = goods.oauthUrl
//                    if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
//                        if !pageUrl.contains(Defaults[kUserToken]!) {
//                            if !pageUrl.contains("?") {
//                                pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
//                            } else {
//                                pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
//                            }
//                        }
//                    }
//                    let page = AlibcTradePageFactory.page(pageUrl)
//                    let taoKeParams = AlibcTradeTaokeParams.init()
//                    taoKeParams.pid = nil
//                    let showParam = AlibcTradeShowParams.init()
//                    showParam.openType = .auto
//                    let myView = SZYwebViewController.init()
//
//                 let ret =    AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: goods.coupon_url, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//                    }, tradeProcessFailedCallback: { (error) in
//                    })
//                    if (ret == 1) {
//                        let nav1 = LNNavigationController.init(rootViewController: myView)
//                        nav1.isNavigationBarHidden = true
//                        nav!.present(nav1, animated: true, completion: nil)
//                    }
//                }
//            } else {
//                let share = SZYShareGoodsViewController()
//                share.goodsModel = goods
//                nav!.pushViewController(share, animated: true)
//            }
//
//        }
//
//    }
//
//    func getTaokeParam() -> AlibcTradeTaokeParams {
//        if ALiTradeSDKShareParam.sharedInstance().isUseTaokeParam {
//            let taoke = AlibcTradeTaokeParams.init()
//            taoke.pid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "pid") as? String
//            taoke.subPid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "subPid") as? String
//            taoke.unionId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "unionId") as? String
//            taoke.adzoneId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "adzoneId") as? String
//            taoke.extParams = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "extParams") as? [AnyHashable : Any]
//            return taoke
//        }else{
//            return AlibcTradeTaokeParams()
//        }
//    }
//
//    func delegateScrollOrModel(_ senderTag: Int) {
//        kDeBugPrint(item: senderTag)
//        if senderTag == 55 { //查相似
//
//        } else if senderTag == 56 || senderTag == 57 { // 我知道了  不用处理
//
//        } else if senderTag == 201 {
//            let tabbar = self.window?.rootViewController as? LNMainTabBarController
//            let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
//
//            let text = UIPasteboard.general.string
//            let ressult = LQSearchResultViewController()
//            ressult.keyword = text!
//            ressult.type  = "1"
//            nav!.pushViewController(ressult, animated: true)
//
//            let pasteboard = UIPasteboard.general
//            pasteboard.string = ""
//        }
//    }
//}

//极光的东西，不明白就看文档
extension AppDelegate : JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        
        JPUSHService.setBadge(0)
        
//        通知携带的type有两种，一种是1，需要跳转到商品详情，但是t如果当前的控制器就是在详情，那么就直接发送一个通知f让详情页面进行刷新就行了，如果不是m，那就需要push到详情页面。
        
//        另一种是2，跟type1同理
        
        let info = JSON(userInfo).dictionaryValue
        
        if info["type"]?.stringValue == "1" {
            if OCTools().getCurrentVC().isKind(of: SZYGoodsViewController.self) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LQLoadGoodDeailNification), object: self, userInfo: ["good_item_id":(info["params"]?.stringValue)!,"coupone_type":(info["platform"]?.stringValue)!])
            }else{
                let tabbar = self.window?.rootViewController as? LNMainTabBarController
                let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
                let detail = SZYGoodsViewController()
                detail.good_item_id = (info["params"]?.stringValue)!
                if info.keys.contains("platform") {
                    detail.coupone_type = (info["platform"]?.stringValue)!
                }else{
                    detail.coupone_type = "1"
                }
                nav?.pushViewController(detail, animated: true)
            }
        }else{
            if info["params"] != nil {
                if OCTools().getCurrentVC().isKind(of: LQWebViewController.self) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: LQTools().LQLoadH5DeailNification), object: self, userInfo: ["requsetUrl":(info["params"]?.stringValue)!])
                }else{
                    let tabbar = self.window?.rootViewController as? LNMainTabBarController
                    let nav = tabbar?.childViewControllers[(tabbar?.selectedIndex)!] as? LNNavigationController
                    let webVc = LQWebViewController()
                    webVc.webUrl = (info["params"]?.stringValue)!
                    webVc.webTitle = "详情"
                    nav?.pushViewController(webVc, animated: true)
                }
            }
        }

        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    
}

extension AppDelegate : WXApiDelegate {
    //    如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    func onResp(_ resp: BaseResp!) {
        //        PayResp
        
//        这里是微信支付的结果，有使用的话，可以通过发送通知告诉支付页面的支付结果。
        let strTitle = "支付结果"
        var strMsg = "\(resp.errCode)"
        if resp.isKind(of: PayResp.self) {
            switch resp.errCode {
            case 0 :
                strMsg = "支付成功!"
                print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
                
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: WXPaySuccessNotification)))
                break
            case -1 :
                strMsg = "支付失败，请您重新支付!"
                print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
                break
            case -2 :
                strMsg = "退出支付！"
                print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
                break
                
            default:
                strMsg = "支付失败，请您重新支付!"
                print("retcode = \(resp.errCode), retstr = \(resp.errStr)")
            }
        }
        let alert = UIAlertView(title: strTitle, message: strMsg, delegate: nil, cancelButtonTitle: "好的")
        //        alert.show()
    }
}
