//
//  LNMineViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//   chart.money  commission

import UIKit
import DeviceKit
import SwiftyJSON
import SwiftyUserDefaults

class LNMineViewController: LNBaseViewController {

    let identyfierTable1 = "identyfierTable1"
    let identyfierTable12 = "identyfierTable12"
    
    let identyfierTable5 = "identyfierTable5"
    let identyfierTable6 = "identyfierTable6"
    let identyfierTable7 = "identyfierTable7"
    
    fileprivate var memberModel : LNMemberModel?
    var PersonalCenterModel = SZYPersonalCenterModel()
    var ChartModel = SZYChartModel()
    
    var resoruce = [LNPartnerModel]()
    fileprivate var isLoaded = false

    let images = [[""],/*[""],*/["邀请","我的收藏",/*"常见问题",*/"联系我们", "教程", "常见问题", "自定义密令"]]
    let titles = [[""],/*[""],*/["邀请好友","我的收藏",/*"常见问题",*/"专属客服", "新手教程", "常见问题", "专属邀请码"]]

    let unImage = [[""],[/*"mine_options_4","mine_options_5",*/"mine_options_6","mine_options_7"]]
    let unTitles = [[""],[/*"新手指引","常见问题",*/"意见反馈","关于我们"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LNChangePersonalInfo(nitofication:)), name: NSNotification.Name(rawValue: LQTools().LNChangePersonalInfo), object: nil)
    }
    
    @objc func LNChangePersonalInfo(nitofication:Notification) {
        requestData()
    }

    override func configSubViews() {
        self.navigaView.isHidden = true
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 49 + 20), style: .grouped, vc: self)
        mainTableView.register(UINib(nibName: "LNMineInfoCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.register(UINib(nibName: "LNMineOptionsCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
        mainTableView.register(UINib(nibName: "LNMineUnloginCell", bundle: nil), forCellReuseIdentifier: identyfierTable12)
        
        mainTableView.register(UINib(nibName: "SZYLNMineInfoCell", bundle: nil), forCellReuseIdentifier: identyfierTable5)
        mainTableView.register(UINib(nibName: "SZYAdvertisingTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable6)
        mainTableView.register(UINib(nibName: "SZYLNMineOptionsCell", bundle: nil), forCellReuseIdentifier: identyfierTable7)
        
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        mainTableView.tableHeaderView?.isHidden = true
        
        mainTableView.backgroundColor = kGaryColor(num: 245)
        mainTableView.separatorStyle = .none
        self.view.addSubview(mainTableView)
        
        var backBtnCenterY = navigaView.centerY+10
        if Device() == .iPhoneX {
            backBtnCenterY = navigaView.centerY+20
        }
        
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navigaView.centerY+20
        }
    }
    
    override func backAction(sender: UIButton) {
        let setting = LNSettingViewController()
        if memberModel != nil {
            setting.model = memberModel!
        }
        self.navigationController?.pushViewController(setting, animated: true)
    }
    
    override func refreshHeaderAction() {
        requestData()
    }
    
    override func requestData() {
        if Defaults[kUserToken] == nil {
            DispatchQueue.main.async {
               self.mainTableView.mj_header.endRefreshing()
            }
            return
        }
        
        let request = SKRequest.init()
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kPersonalCenter) { (response) in
            weakSelf?.mainTableView.mj_header.endRefreshing()
            if !(response?.success)! {
                return
            }
            kDeBugPrint(item: response?.data)
            let datas =  JSON(response?.data["data"] as Any)["user"]["data"]
            weakSelf?.PersonalCenterModel = SZYPersonalCenterModel.setupValues(json: datas)
            let datas1 =  JSON(response?.data["data"] as Any)["chart"]
            weakSelf?.ChartModel = SZYChartModel.setupValues(json: datas1)
            weakSelf?.mainTableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
        
//        view.layer.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
        self.view.backgroundColor = UIColor.init(r: 242.0/255.0, g: 242.0/255.0, b: 242.0/255.0)
    }
    
}

extension LNMineViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if Defaults[kUserToken] == nil {
            return unImage.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Defaults[kUserToken] == nil {
            return unImage[section].count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Defaults[kUserToken] == nil {
            
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable12, for: indexPath) as! LNMineUnloginCell
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! LNMineOptionsCell
                cell.setValuesWith(image: unImage[indexPath.section][indexPath.row], title: unTitles[indexPath.section][indexPath.row], detail: "")
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable5, for: indexPath) as! SZYLNMineInfoCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            if self.PersonalCenterModel.credit1 != "" {
                cell.setUpUserInfo(model: self.PersonalCenterModel, chart: self.ChartModel)
            }
            return cell
        /*case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable6, for: indexPath) as! SZYAdvertisingTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.setImageUrl(urlStr: "")
            return cell*/
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable7, for: indexPath) as! SZYLNMineOptionsCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.setValuesWith(image: images[indexPath.section][indexPath.row], title: titles[indexPath.section][indexPath.row], type: "")
            if indexPath.row == 0 {
                cell.setValuesWith(image: images[indexPath.section][indexPath.row], title: titles[indexPath.section][indexPath.row], type: "0")
            } else if indexPath.row == images[indexPath.section].count - 1 {
                cell.setValuesWith(image: images[indexPath.section][indexPath.row], title: titles[indexPath.section][indexPath.row], type: "1")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if Defaults[kUserToken] == nil {
            if indexPath.section == 0 {
                self.present(loginOut(), animated: true, completion: nil)
            }else{
                switch indexPath.row {
//                case 0://新手指引
//                    let newUser = LNNewUserViewController()
//
//                    newUser.isNewUser = true
//                    self.navigationController?.pushViewController(newUser, animated: true)
//                    break
//                case 1://常见问题
//                    let newUser = LNNewUserViewController()
//
//                    newUser.isNewUser = false
//                    self.navigationController?.pushViewController(newUser, animated: true)
//                    break
                case 0://意见反馈
                    self.navigationController?.pushViewController(LNSubmitSuggestViewController(), animated: true)

                    break
                case 1://关于我们
                    self.navigationController?.pushViewController(LNAboutUsViewController(), animated: true)
                    
                    break
                default:
                    break
                }
            }
            return
        }
        
        if indexPath.section == 0 {
            return
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 3://新手指引
//                let newUser = LNNewUserViewController()
//                newUser.isNewUser = true
//                self.navigationController?.pushViewController(newUser, animated: true)
                
                gotoTaobaoOrders()
                
                break
            case 1://我的收藏
                self.navigationController?.pushViewController(LNShowCollectViewController(), animated: true)
                
                break
//            case 2://常见问题
//                let newUser = LNNewUserViewController()
//
//                newUser.isNewUser = false
//                self.navigationController?.pushViewController(newUser, animated: true)
//                break
            case 2://专属客服
                let group = LNCustomServiceViewController()

                if PersonalCenterModel.group != nil {
                    group.PersonalCenterModel = PersonalCenterModel.group
                }
                self.navigationController?.pushViewController(group, animated: true)
                break
            case 0://邀请好友
                if self.bindingClick() {
                    let inviteVC = LNInviterViewController()
                    if PersonalCenterModel.invite_code != "" {
                        inviteVC.inviteCodeStr = PersonalCenterModel.invite_code
                    } else {
                        inviteVC.inviteCodeStr = PersonalCenterModel.hashid
                    }
                    self.navigationController?.pushViewController(inviteVC, animated: true)
                }
                break
            case 4: //常见问题
                var pageUrl = JGBaseH5Url + "/pages/ques/index"
                if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
                    if !pageUrl.contains(Defaults[kUserToken]!) {
                        if !pageUrl.contains("?") {
                            pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
                        } else {
                            pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
                        }
                    }
                }
//                let page = AlibcTradePageFactory.page(pageUrl)
                let taoKeParams = AlibcTradeTaokeParams.init()
                taoKeParams.pid = nil
                let showParam = AlibcTradeShowParams.init()
                showParam.openType = .auto
                let myView = SZYwebViewViewController.init()
//                let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//                    kDeBugPrint(item: "======11111=======")
//                }, tradeProcessFailedCallback: { (error) in
//                    kDeBugPrint(item: error)
//                })
//                if (ret == 1) {
//                    self.navigationController?.pushViewController(myView, animated: true)
//                }
                
                let ret = AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
                }, tradeProcessFailedCallback: { (error) in
                })
                if (ret == 1) {
                                        self.navigationController?.pushViewController(myView, animated: true)
                                    }
                break
            case 5: //自定义密令
                
                let tankuan = BCTVersionViewController()
//                tankuan.daliCanshu = self
//                tankuan.titleStr = "该商品无优惠信息"
//                tankuan.contentStr = "是否查看更多同类商品"
                tankuan.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
                tankuan.modalPresentationStyle = .custom
                self.modalPresentationStyle = .currentContext
                self.present(tankuan, animated: false, completion: nil)
                
                break
            default:
                break
            }

        }else{
            switch indexPath.row {
            case 0://意见反馈
                self.navigationController?.pushViewController(LNSubmitSuggestViewController(), animated: true)
                break
            case 1://关于我们
                self.navigationController?.pushViewController(LNAboutUsViewController(), animated: true)
                
                break
            default:
                break
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            let headview = UIView.init()
            headview.backgroundColor = kBGColor()
            return headview
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if Defaults[kUserToken] == nil  {
          
            if indexPath.section == 0 {
                return 190;

            }else {
                return 40;
            }
            
          }else{
            return 570
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if Defaults[kUserToken] == nil {
            return 0.01
        }else{
        return 230
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if Defaults[kUserToken] == nil {
            return nil
        }else{
        
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 230))
//        footerView.backgroundColor = UIColor.red
        //图片
        let footerImageView = UIImageView.init(frame: CGRect(x: 10, y: 10, width: kSCREEN_WIDTH - 20, height: 90))
        footerImageView.image = UIImage.init(named: "home_AdIcon")
//        footerImageView.backgroundColor = UIColor.yellow
        
        footerView .addSubview(footerImageView)
        var buttonTitle : Array = ["邀请好友", "我的收藏", "专属客服", "新手教程", "常见问题", "专属邀请码"]
        var buttonImage : Array = ["jg_make_per", "jg_love", "jg_searce_m","jg_new_per", "jg_question_q", "jg_make_plus"]
        
        for i in 0..<6 {
            let button = UIButton()
            let floatI = CGFloat(i )
            let floatLL = CGFloat(i - 3)
            let floatX = CGFloat(i + 1)
            let floatXX = CGFloat(i - 2)
            
            let width = (kSCREEN_WIDTH - 40)/3
            button.backgroundColor = UIColor.black
            if i < 3{
                button.frame = CGRect(x: 10 * floatX + width * floatI, y: 110, width: (kSCREEN_WIDTH - 40)/3, height: 55)
              
            }else {
                button.frame = CGRect(x: 10 * floatXX + width * floatLL, y: 175, width: (kSCREEN_WIDTH - 40)/3, height: 55)
              
            }
            button.layer.cornerRadius = 10
            button.backgroundColor = UIColor.white
            button.tag = 9527 + i
            button.setImage(UIImage.init(named: buttonImage[i]), for: UIControl.State.normal)
            button.setTitle(buttonTitle[i], for: UIControl.State.normal)
            button.setTitleColor(UIColor.init(r: 93, g: 93, b: 93), for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button .addTarget(self, action: #selector(buttonClick), for: UIControlEvents.touchDown)
            footerView .addSubview(button)
        }
        
        
        
        return footerView
        }
    }
    
    @objc func buttonClick(sender : UIButton) {
        
        let tags = sender.tag - 9527
        
        
        
        switch tags {
        case 0:
            if self.bindingClick() {
                let inviteVC = LNInviterViewController()
                if PersonalCenterModel.invite_code != "" {
                    inviteVC.inviteCodeStr = PersonalCenterModel.invite_code
                } else {
                    inviteVC.inviteCodeStr = PersonalCenterModel.hashid
                }
                self.navigationController?.pushViewController(inviteVC, animated: true)
            }
            break
            
        case 1:
            self.navigationController?.pushViewController(LNShowCollectViewController(), animated: true)
            break
        case 2:
            let group = LNCustomServiceViewController()
            
            if PersonalCenterModel.group != nil {
                group.PersonalCenterModel = PersonalCenterModel.group
            }
            self.navigationController?.pushViewController(group, animated: true)
            break
        case 3:
              gotoTaobaoOrders()
            break
        case 4:
            var pageUrl = JGBaseH5Url + "/pages/ques/index"
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
//            let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//                kDeBugPrint(item: "======11111=======")
//            }, tradeProcessFailedCallback: { (error) in
//                kDeBugPrint(item: error)
//            })
//            if (ret == 1) {
//                self.navigationController?.pushViewController(myView, animated: true)
//            }
            let ret = AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
            }, tradeProcessFailedCallback: { (error) in
            })
            if (ret == 1) {
                                self.navigationController?.pushViewController(myView, animated: true)
                            }
            
            break
       
        default:
            let tankuan = BCTVersionViewController()
            //                tankuan.daliCanshu = self
            //                tankuan.titleStr = "该商品无优惠信息"
            //                tankuan.contentStr = "是否查看更多同类商品"
            tankuan.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
            tankuan.modalPresentationStyle = .custom
            self.modalPresentationStyle = .currentContext
            self.present(tankuan, animated: false, completion: nil)
            break
        }
        
    }
    
    
    
    func gotoTaobaoOrders() {
//        let tradeService = AlibcTradeSDK()
//        let viewSettings = self.getWebViewSetting()
        
//        TaeWebViewUISettings *viewSettings =[self getWebViewSetting];
//        ALBBPage *page=[ALBBPage  myOrdersPage:@"0" isAllOrder:YES];
//        [_tradeService  show:self.navigationController isNeedPush:YES webViewUISettings:viewSettings page:page taoKeParams:nil tradeProcessSuccessCallback:_tradeProcessSuccessCallback tradeProcessFailedCallback:_tradeProcessFailedCallback];
        var pageUrl = JGBaseH5Url + "/pages/course/index"
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
//        let page = AlibcTradePageFactory.myOrdersPage(0, isAllOrder: true)  //淘宝订单
        let taoKeParams = AlibcTradeTaokeParams.init()
        taoKeParams.pid = nil
        let showParam = AlibcTradeShowParams.init()
        showParam.openType = .auto
        let myView = SZYwebViewViewController.init()
//        myView.webTitle = "测试"
//        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//            kDeBugPrint(item: "======11111=======")
//        }, tradeProcessFailedCallback: { (error) in
//            kDeBugPrint(item: error)
//        })
//        if (ret == 1) {
//            self.navigationController?.pushViewController(myView, animated: true)
//        }
        let ret = AlibcTradeSDK.sharedInstance().tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
        }, tradeProcessFailedCallback: { (error) in
        })
        if (ret == 1) {
                        self.navigationController?.pushViewController(myView, animated: true)
                    }
        
        
        
//        DispatchQueue.main.async {
//            self.navigationController?.navigationBar.isTranslucent = false
//            let showParam = AlibcTradeShowParams.init()
//            showParam.openType = AlibcOpenType.H5
//            showParam.backUrl="tbopen27863290"
//            showParam.linkKey = "taobao"
//            showParam.isNeedPush=true
//            showParam.nativeFailMode = AlibcNativeFailMode.jumpH5
//
//            let page = AlibcTradePageFactory.myOrdersPage(0, isAllOrder: true)
//            AlibcTradeSDK.sharedInstance().tradeService().show(self, page: page, showParams: showParam, taoKeParams: self.getTaokeParam(), trackParam: ALiTradeSDKShareParam.sharedInstance().customParams as? [AnyHashable : Any], tradeProcessSuccessCallback: { (back) in
//
//            }, tradeProcessFailedCallback: { (error) in
//
//            })
//        }
        
    }
    
//    @objc @objc func getTaokeParam() -> AlibcTradeTaokeParams {
//
//        if ALiTradeSDKShareParam.sharedInstance().isUseTaokeParam {
//            let taoke = AlibcTradeTaokeParams.init()
//            taoke.pid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "pid") as? String
//            taoke.subPid = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "subPid") as? String
//            taoke.unionId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "unionId") as? String
//            taoke.adzoneId = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "adzoneId") as? String
//            taoke.extParams = ALiTradeSDKShareParam.sharedInstance().taoKeParams.object(forKey: "extParams") as? [AnyHashable : Any]
//
//            return taoke
//        }else{
//            return AlibcTradeTaokeParams()
//        }
//    }
    
    
}
