//
//  LNMainTabBarController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
class LNMainTabBarController: UITabBarController {
    let mianVC  = LNPageViewController()
    let circleVC = SZYLQShowQuanViewController() //LQShowQuanViewController()
    
    let superInterface = SZYLNSuperInterfaceViewController() //LNSuperInterfaceViewController()  SZYSuperInterfaceViewController
    
    //    var searchVc  = CXSearchController()：
    //    var searchVc  = MG_MemberCenterViewController()
    //    var searchVc  = LNMiaoshaViewController()
    var searchVc  = SZYMembersViewController()
    
    let mineVC    = LNMineViewController()
    
    var selectIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBar.tintColor=UIColor.orange
        
        
        self.tabBar.barTintColor = JGMainColor


        
        addChildCOntrollers()
        //        setupUnreadMessageCount()
        getUserInfo()
        
        self.tabBar.isTranslucent = false
        
        let request = SKRequest.init()
        request.setParam("and" as NSObject, forKey: "searchJoin")
        
        request.callGET(withUrl: LNUrls().kRequest_ads) { (response) in
            if !(response?.success)! {
                return
            }
            
            if JSON((response?.data)!)["data"]["data"].arrayValue.count == 0 {
                return
            }
            
            let data = JSON((response?.data)!)["data"]["data"].arrayValue[0]
            Defaults[kLastImage] = data["image"].stringValue
            Defaults[kLastUrl] = data["url"].stringValue
            
            let imageData = try? Data.init(contentsOf: URL.init(string: Defaults[kLastImage]!)!)
            if imageData == nil {
                return
            }
            let image = UIImage.init(data: imageData!)
            SDWebImageManager.shared().saveImage(toCache: image, for: OCTools.getEfficientAddress(Defaults[kLastImage]!))
        }
        
    }
    
    
    @objc func setupUnreadMessageCount(){
        let request = SKRequest.init()
        
        request.callGET(withUrl: LNUrls().kMember) { (response) in
            
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                
                let datas =  JSON((response?.data["data"])!)["data"]
                
                if datas["phone"].stringValue.count == 0 {
                    Defaults[kBandingPhone] = "0"
                }else{
                    Defaults[kBandingPhone] = "1"
                }
                
                if datas["inviter_id"].stringValue.count == 0 {
                    Defaults[kBandingInviter] = "0"
                }else{
                    Defaults[kBandingInviter] = "1"
                }
                
                let version = datas["hashid"].stringValue
                let tags = NSSet.init(objects: version) as! Set<String>
                JPUSHService.setTags(tags, completion: { (iResCode, iTags, iAlias) in
                }, seq: 1)
                
            }
        }
    }
    
    func getUserInfo() {
        
        //        let str1 = str.replacingOccurrences(of: "<div style=\"text-align: center;\"><img data-lazyload=\"", with: "")
        //        let str2 = str1.replacingOccurrences(of: "alt=\"\" /></div>", with: ",")
        //        let str3 = str2.replacingOccurrences(of: "<br/>", with: "")
        //        let str4 = str3.replacingOccurrences(of: "\"", with: "")
        //        var urls = str4.components(separatedBy: " ,")
        //        urls.removeLast()
        //        print(urls)
    }
    
    func addChildCOntrollers() {
        
        setupOneChildViewController("首页", image: "tabbar_main_unselect", selectedImage: "tabbar_main_select", controller: mianVC)
        //        searchVc = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
        //        setupOneChildViewController("会员中心", image: "tabbar_member_unselect", selectedImage: "tabbar_member_select", controller: searchVc)
        setupOneChildViewController("品牌", image: "tabbar_member_unselect", selectedImage: "tabbar_member_select", controller: superInterface)
        
        
        
        //        var url = "https://h5.hongtang.online/#/pages/upgrade/index?token="
        //        if Defaults[kUserToken] == nil || Defaults[kUserToken] == "" {
        ////            setToast(str: "获取token失败，请重新登录！") baicai.top
        //        } else {
        //            url = url + Defaults[kUserToken]!
        //        }
        //
        //        let page = AlibcTradePageFactory.page(url)
        //        let taoKeParams = AlibcTradeTaokeParams.init()
        //        taoKeParams.pid = nil
        //        let showParam = AlibcTradeShowParams.init()
        //        showParam.openType = .auto
        //        let myView = SZYMembersViewController.init()
        //        myView.webTitle = ""//goods.title
        //        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
        //            kDeBugPrint(item: "======11111=======")
        //        }, tradeProcessFailedCallback: { (error) in
        //            kDeBugPrint(item: error)
        //        })
        //
        //        if (ret == 1) {
        //            setupOneChildViewController("", image: "tabbar_super_unselect", selectedImage: "tabbar_super_unselect", controller: myView)
        //        }
        setupOneChildViewController("", image: "tabbar_super_unselect", selectedImage: "tabbar_super_unselect", controller: searchVc)
        
        
        setupOneChildViewController("发圈", image: "tabbar_quan_unselect", selectedImage: "tabbar_quan_select", controller: circleVC)
        
        setupOneChildViewController("我的", image: "tabbar_me_unselect", selectedImage: "tabbar_me_select", controller: mineVC)
    }
    
    /// 添加一个子控制器
    fileprivate func setupOneChildViewController(_ title: String, image: String, selectedImage: String, controller: UIViewController) {
        
        controller.tabBarItem.title = title
        controller.title = title
        //        selectedTapTabBarItems(tabBarItem: controller.tabBarItem)
        //        unSelectedTapTabBarItems(tabBarItem: controller.tabBarItem)
        ////        controller.tabBarItem.image = UIImage(named: image)
        ////        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)
        
        
        controller.tabBarItem = UITabBarItem(title: title, image: UIImage(named: image)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal))
        controller.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.hex("#909090")], for:.normal)
        controller.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.hex("#F3D6B5")], for:.selected)
        addChildViewController(LNNavigationController.init(rootViewController: controller))
    }
    
    
//    func unSelectedTapTabBarItems(tabBarItem:UITabBarItem) {
//        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.hex("#909090")], for: .normal);
//    }
//    
//    
//    func selectedTapTabBarItems(tabBarItem:UITabBarItem) {
//        
//        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.hex("#F3D6B5")], for: .selected);
//    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        kDeBugPrint(item: item.title)
    }
    
}

