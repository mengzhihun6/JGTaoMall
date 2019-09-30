//
//  SZYMainViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/19.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import SwiftyUserDefaults

@objc public protocol SZYMainViewControllerDelegate: NSObjectProtocol {
    @objc func delegateScroll(_ offSetY: CGFloat)
}

class SZYMainViewController: LNBaseViewController {
    
    let identyfierTable1 = "identyfierTable1"
    let identyfierTable2 = "identyfierTable2"
    let identyfierTable3 = "identyfierTable3"
    let identyfierTable4 = "identyfierTable4"
    
    let identyfierTable5 = "identyfierTable5"
    let identyfierTable6 = "identyfierTable6"

//    一定要weak，防止循环引用
    weak var superViewController : LNPageViewController?
    
    var scrollDelegate : SZYMainViewControllerDelegate?
    
    
    var homeDiyModel : JTHHomeDiyModel?
    var newCouponsSource = [SZYGoodsInformationModel]()
    
    //    时间选择View
    fileprivate var topView = LNTopScrollView3_1()
    fileprivate var selectIndex1 = 0
    var topBun = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addFooterRefresh()
        let head = mainTableView.mj_header as! MJRefreshNormalHeader
        head.lastUpdatedTimeLabel.textColor = UIColor.white
        head.stateLabel.textColor = UIColor.white
        // diy 数据获取
        requestForLayout()
    }
    override func configSubViews() {
        navigaView.isHidden = true
        titleLabel.textColor = UIColor.white
        var top = navHeight+20
        if kSCREEN_HEIGHT>800 {
            top = navHeight+25
        }
        mainTableView = getTableView(frame: CGRect(x: 0, y: top-2.5, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-top-10-64), style: .grouped, vc: self)
        
//        两列 四列 四个按钮
        mainTableView.register(UINib(nibName: "SZYSecondFourTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
//        横向滑动
        mainTableView.register(UINib(nibName: "SZYCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable2)
//        banner
        mainTableView.register(UINib(nibName: "SZYBannerTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable3)
//        九宫格
        mainTableView.register(UINib(nibName: "SZYScratchableIatexTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable4)
//        情报局
        mainTableView.register(UINib(nibName: "SZYCiaTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable5)
//        商品
        mainTableView.register(UINib(nibName: "SZYDiyGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable6)
//        商品信息
        mainTableView.register(UINib(nibName: "LNMainLayoutCell3", bundle: nil), forCellReuseIdentifier: identyfierTable)
        
//        一定要将所有的背景设为透明，否则看不到后面的东西
        mainTableView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
        mainTableView.separatorStyle = .none
        self.view.addSubview(mainTableView)
        
        topView = LNTopScrollView3_1.init(frame: CGRect(x: 0, y: 10, width: kSCREEN_WIDTH, height: 60))
        setTopView()
        weak var weakSelf = self
        topView.callBackBlock { (index, title) in
            weakSelf?.selectIndex1 = index + 1
            weakSelf?.currentPage = 1
            weakSelf?.requestData()
            kDeBugPrint(item: "index  \(index)   title  \(title) ")
        }
        
        topBun = UIButton.init(frame: CGRect.init(x: kSCREEN_WIDTH - 55, y: kSCREEN_HEIGHT - 165, width: 45, height: 45));
        topBun.backgroundColor = UIColor.red
        topBun.setImage(UIImage.init(named: "返回顶部"), for: .normal)
        topBun.addTarget(self, action: #selector(topBunClick), for: .touchUpInside)
        topBun.cornerRadius = topBun.height / 2.0
        topBun.clipsToBounds = true
        topBun.isHidden = true
        self.view.addSubview(topBun)
    }
    @objc func topBunClick() {
        //        //***************方法一***************//
        //        [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        //
        //        //***************方法二***************//
        //        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        //
        //        //***************方法三***************//
        //        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        //        [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        let indexPat = IndexPath.init(row: 0, section: 0)
        mainTableView.scrollToRow(at: indexPat as IndexPath, at: .bottom, animated: true)
    }
    func setTopView() {
        var selectIndex = 0
        let dateFamater = DateFormatter.init()
        dateFamater.dateFormat = "HH"
        let time = Int(dateFamater.string(from: Date.init()))
        
//        判断当前时间属于哪一个阶段
        if time! >= 0 && time! < 10 {
            selectIndex = 5
        }
        if time! >= 10 && time! < 12 {
            selectIndex = 6
        }
        if time! >= 12 && time! < 15 {
            selectIndex = 7
        }
        if time! >= 15 && time! < 20 {
            selectIndex = 8
        }
        if time! >= 20 {
            selectIndex = 9
        }
        selectIndex1 = selectIndex + 1
        topView.lineColor = kGaryColor(num: 255)//kGaryColor
        topView.setTopView(titles: [ "00:00", "10:00", "12:00", "15:00", "20:00", "00:00", "10:00", "12:00", "15:00", "20:00", "00:00", "10:00", "12:00", "15:00", "20:00" ], selectIndex: selectIndex)
        
        topView.setSelectIndex(index: selectIndex, animation: true)
        
    }
    override func refreshHeaderAction() {
        currentPage = 1
        requestForLayout()
        requestData()
    }
    override func refreshFooterAction() {
        currentPage = currentPage + 1
        requestData()
    }
//    请求布局 diy
    func requestForLayout() {
        let request = SKRequest.init()
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().JTHHomdeDiy) { (response) in
            kDeBugPrint(item: response?.data)
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!)
                weakSelf?.homeDiyModel = JTHHomeDiyModel.setUpModel(json: datas)
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    override func requestData() {
        /*
        let request = SKRequest.init()
        request.setParam("hour_type:"+String(selectIndex1) as NSObject, forKey: "search")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: LNUrls().kKuaiqiang) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            kDeBugPrint(item: response?.data)
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.newCouponsSource.removeAll()
                        if weakSelf?.currentPage == pages {
                            weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.mainTableView.mj_footer.resetNoMoreData()
                        }
                    }else{
                        if (weakSelf?.currentPage)! >= pages {
                            weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.mainTableView.mj_footer.endRefreshing()
                        }
                    }
                    
                    for index in 0..<datas.count{
                        weakSelf?.newCouponsSource.append(SZYGoodsInformationModel.setupValues(json: datas[index]))
                    }
                    
                    if (weakSelf?.mainTableView.mj_header.isRefreshing)! {
                        weakSelf?.mainTableView.mj_header.endRefreshing()
                    }
                }else{
                    if weakSelf?.mainTableView.mj_footer != nil {
                        weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                weakSelf?.mainTableView.reloadData()
            }
        }
        */
        
        let request = SKRequest.init()
        weak var weakSelf = self
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        
        request.setParam("type:1;tag:2" as NSObject, forKey: "search")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.setParam("id" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("10" as NSObject, forKey: "limit")
        request.callGET(withUrl: LNUrls().kSwhow_coupon) { (response) in
            LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                if !(response?.success)! {
                    weakSelf?.mainTableView.mj_footer.endRefreshing()
                    weakSelf?.mainTableView.mj_header.endRefreshing()
                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                if datas.count >= 0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.newCouponsSource.removeAll()
                        if weakSelf?.currentPage == pages {
                            weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                        } else {
                            weakSelf?.mainTableView.mj_footer.resetNoMoreData()
                        }
                    } else {
                        if (weakSelf?.currentPage)! >= pages {
                            weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                        } else {
                            weakSelf?.mainTableView.mj_footer.endRefreshing()
                        }
                    }
                    for index in 0..<datas.count{
                        let json = datas[index]
                        weakSelf?.newCouponsSource.append(SZYGoodsInformationModel.setupValues(json: json))
                    }
                    if (weakSelf?.newCouponsSource.count)! > 0{
                        var randomNumber:Int = Int(arc4random() % UInt32((weakSelf?.newCouponsSource.count)!)) - 1
                        if randomNumber < 0 {
                            randomNumber = 0
                        }
                        if randomNumber + 1 <= (weakSelf?.newCouponsSource.count)! {
                            Defaults[kGetTheRandomItemId] = weakSelf?.newCouponsSource[randomNumber].item_id
                        }
                    }
                    if (weakSelf?.mainTableView.mj_header.isRefreshing)! {
                        weakSelf?.mainTableView.mj_header.endRefreshing()
                    }
                } else {
                    if weakSelf?.mainTableView.mj_footer != nil {
                        weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                weakSelf?.mainTableView.reloadData()
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.mj_offsetY > 600 {
//            topBun.isHidden = false
//        } else {
//            topBun.isHidden = true
//        }
        if scrollDelegate != nil {
            scrollDelegate?.delegateScroll(scrollView.mj_offsetY)
        }
    }
    
}


extension SZYMainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if homeDiyModel == nil {
            return 0
        } else {
            return 3 + (homeDiyModel?.home.goods.count)!
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 + homeDiyModel!.home.goods.count - 1 {
            return newCouponsSource.count
        } else {
            if section > 1 {
                let goods: goodsDiyModel = homeDiyModel!.home.goods[section - 2]
                if goods.type == "special" && goods.theme == "4" {
                    return goods.list.count
                }
            }
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable3, for: indexPath) as! SZYBannerTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
            
            cell.superViewController = superViewController
            cell.setUpValues(model: (homeDiyModel?.home.banner)!)
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable4, for: indexPath) as! SZYScratchableIatexTableViewCell
            cell.selectionStyle = .none
            
            cell.superViewController = superViewController
            cell.serUpModel(model: (homeDiyModel?.home.entrance)!)
            
            return cell
        } else  if indexPath.section > 1 && indexPath.section < (3 + homeDiyModel!.home.goods.count - 1) {
            let goods: goodsDiyModel = homeDiyModel!.home.goods[indexPath.section - 2]
            if goods.type == "topic" { //专题
                
                let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! SZYSecondFourTableViewCell
                cell.selectionStyle = .none
                cell.superViewController = superViewController
                if goods.theme == "1" { // 两列并排
                    cell.setModel(model: goods.data)
                } else if goods.theme == "2" { // 四列并排
                    cell.setModelFour(model: goods.data)
                } else if goods.theme == "3" { //单独一张图
                    cell.setOneModel(model: goods.data)
                } else if goods.theme == "4" { //四个固定图
                    cell.setFourModel(model: goods.data)
                }
                return cell
            } else if goods.type == "special" { //商品
                kDeBugPrint(item: "输出goods.list  \(goods.list)")
                if goods.theme == "1" || goods.theme == "2" || goods.theme == "3" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! SZYCollectionViewTableViewCell
                    cell.superViewController = superViewController
                    cell.selectionStyle = .none
                    cell.typeString = goods.theme
                    cell.titleLable.text = goods.title
//                    cell.setUpValues(model: goods.list)
                    cell.setUpValues(model: goods)
                    return cell
                }  else { //单个横排商品  goods.theme == "4"
                    let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable6, for: indexPath) as! SZYDiyGoodsTableViewCell
                    cell.selectionStyle = .none
                    
                    cell.setUpModel(model: goods.list[indexPath.row])
                    
                    return cell
                }
                
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNMainLayoutCell3
        cell.setValues2(model: newCouponsSource[indexPath.row], type: "")
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section > 1 {
            if indexPath.section < (3 + homeDiyModel!.home.goods.count - 1) {
                let goods: goodsDiyModel = homeDiyModel!.home.goods[indexPath.section - 2]
                if goods.type == "special" &&  goods.theme == "4" {  // 完成显示 操作
                    
                    let detailVc = SZYGoodsViewController()
                    detailVc.good_item_id = goods.list[indexPath.row].item_id
                    detailVc.coupone_type = goods.list[indexPath.row].type
                    detailVc.goodsUrl = goods.list[indexPath.row].pic_url
                    detailVc.GoodsInformationModel = goods.list[indexPath.row]
                    superViewController?.navigationController?.pushViewController(detailVc, animated: true)
                    
                }
            } else if indexPath.section == (3 + homeDiyModel!.home.goods.count - 1) { // 最后商品 区头   完成区头样式
                
                let detailVc = SZYGoodsViewController()
                detailVc.good_item_id = newCouponsSource[indexPath.row].item_id
                detailVc.coupone_type = newCouponsSource[indexPath.row].type
                detailVc.goodsUrl = newCouponsSource[indexPath.row].pic_url
                detailVc.GoodsInformationModel = newCouponsSource[indexPath.row]
                superViewController?.navigationController?.pushViewController(detailVc, animated: true)
                
            }
        }
        
    }
    // 表头
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHead = UIView.init()
        sectionHead.contentMode = .scaleToFill
        sectionHead.backgroundColor = kSetRGBColor(r: 246, g: 246, b: 246)
        
        if section > 1 {
            if section < (3 + homeDiyModel!.home.goods.count - 1) {
                let goods: goodsDiyModel = homeDiyModel!.home.goods[section - 2]
                if goods.type == "special" &&  goods.theme == "4" {  // 完成显示 操作
                    let beijingView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: kSCREEN_WIDTH, height: 45))
                    beijingView.backgroundColor = UIColor.white
                    sectionHead.addSubview(beijingView)
                    
                    let nameLab = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 150, height: 45))
                    nameLab.text = goods.title
                    nameLab.textColor = kSetRGBColor(r: 55, g: 55, b: 55)
                    nameLab.font = UIFont.systemFont(ofSize: 15)
                    beijingView.addSubview(nameLab)
                    
                    let bun = UIButton.init(frame: CGRect.init(x: kSCREEN_WIDTH - 80, y: 0, width: 70, height: 45))
                    bun.setImage(UIImage.init(named: "首页更多"), for: .normal)
                    bun.setTitle("更多", for: .normal)
                    bun.setTitleColor(kSetRGBColor(r: 153, g: 153, b: 153), for: .normal)
                    bun.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                    bun.addTarget(self, action: #selector(shangPinBunClick(bun:)), for: .touchUpInside)
                    bun.tag = 50
                    beijingView.addSubview(bun)
                    bun.layoutButton(with: .right, imageTitleSpace: 10)
                }
            } else if section == (3 + homeDiyModel!.home.goods.count - 1) { // 最后商品 区头   完成区头样式
                
                let beijingView = UIView.init(frame: CGRect.init(x: 0, y: 10, width: kSCREEN_WIDTH, height: 45))
                beijingView.backgroundColor = UIColor.white
                sectionHead.addSubview(beijingView)
                
                let nameLab = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 150, height: 50))
                nameLab.text = "热销商品"
                nameLab.textColor = kSetRGBColor(r: 55, g: 55, b: 55)
                nameLab.font = UIFont.systemFont(ofSize: 15)
                beijingView.addSubview(nameLab)
                
//                sectionHead.addSubview(topView)
                
            }
        }
        
        return sectionHead
    }
    
    @objc func shangPinBunClick(bun: UIButton) {
        
        for index in 0..<homeDiyModel!.home.goods.count {
            let goods: goodsDiyModel = (homeDiyModel?.home.goods[index])!
            if goods.type == "special" &&  goods.theme == "4" {
                
                let dataUrl = goods.data[0].url
                if dataUrl.contains("list") {
                    let arr1 = dataUrl.components(separatedBy: "?")
                    
                    let viewC = SZYModuleViewController()
                    viewC.titleString = goods.title
                    viewC.typeInt = 2
                    if arr1.count > 1 {
                        viewC.SZYTypeString = arr1[1]
                    }
                    superViewController?.navigationController?.pushViewController(viewC, animated: true)
                } else if dataUrl.contains("webview") {
                    var pageUrl = dataUrl.replacingOccurrences(of: "hongtang://webview?url=", with: "")
                    
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
                    myView.webTitle = goods.title
                    let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
                        kDeBugPrint(item: "======11111=======")
                    }, tradeProcessFailedCallback: { (error) in
                        kDeBugPrint(item: error)
                    })
                    if (ret == 1) {
                        superViewController?.navigationController?.pushViewController(myView, animated: true)
                    }
                    
                }
                
                break
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 1 {
            if section < (3 + homeDiyModel!.home.goods.count - 1) {
                let goods: goodsDiyModel = homeDiyModel!.home.goods[section - 2]
                if goods.type == "special" &&  goods.theme == "4" {
                    return 55
                }
                
            } else if section == (3 + homeDiyModel!.home.goods.count - 1) { // 最后商品 区头
                return 55
            }
            
            return 10
        }
        return 0.01
    }
    // 表尾
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView.init()
        foot.backgroundColor = kBGColor()
        return foot
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
