//
//  LNNewMainViewController.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import SwiftyUserDefaults

@objc public protocol LNMainPageDidScrollDelegate: NSObjectProtocol {
    @objc func didScroll(_ offSetY: CGFloat)
}

class LNNewMainViewController: LNBaseViewController {

    let identyfierTable1 = "identyfierTable1"
    
    let identyfierTable2 = "identyfierTable2"
    
    let identyfierTable3 = "identyfierTable3"
    
    let identyfierTable4 = "identyfierTable4"

    //气泡
    fileprivate var showView = ArrowheadMenu()
    //    数据源
    fileprivate var resource = [LNNewMainLayoutModel]()
    
//    一定要weak，防止循环引用
    weak var superViewController : LNPageViewController?

    var type = String()
    
    var scrollDelegate : LNMainPageDidScrollDelegate?

    //    数据源
    fileprivate var couponsSource = [LNYHQListModel]()
    var newCouponsSource = [SZYGoodsInformationModel]()
    var topBun = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()
        let head = mainTableView.mj_header as! MJRefreshNormalHeader
        head.lastUpdatedTimeLabel.textColor = UIColor.white
        head.stateLabel.textColor = UIColor.white
//        requestForLayout()
    }
    
    override func configSubViews() {
        navigaView.isHidden = true

        titleLabel.textColor = UIColor.white
//        navigaView.isHidden = true
        var top = navHeight+20
//        if kSCREEN_HEIGHT>700 {
//            top = navHeight+10
//        }
        if kSCREEN_HEIGHT>800 {
            top = navHeight+25
        }
        mainTableView = getTableView(frame: CGRect(x: 0, y: top-2.5, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight-10-64), style: .grouped, vc: self)
        
        // MARK:       布局这一块不懂得话问牛哥，他那有文档
        
        
//        顶部
        mainTableView.register(UINib(nibName: "LNNewHeadCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
//        布局1
        mainTableView.register(UINib(nibName: "LNMainLayoutCell1", bundle: nil), forCellReuseIdentifier: identyfierTable1)
//        布局2
        mainTableView.register(UINib(nibName: "LNMainLayoutCell2", bundle: nil), forCellReuseIdentifier: identyfierTable2)
//        布局3
        mainTableView.register(UINib(nibName: "LNMainLayoutCell3", bundle: nil), forCellReuseIdentifier: identyfierTable3)
//        布局4
        mainTableView.register(UINib(nibName: "nweCellTableViewCell", bundle: nil), forCellReuseIdentifier: identyfierTable4)
//        一定要将所有的背景设为透明，否则看不到后面的东西
        mainTableView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
        self.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
        mainTableView.separatorStyle = .none
        self.view.addSubview(mainTableView)
        
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
    override func refreshHeaderAction() {
        currentPage = 1
        LQLoadingView().SVPwillShowAndHideNoText()
        requestData()
    }
    
    
    override func refreshFooterAction() {
        currentPage = currentPage+1
        LQLoadingView().SVPwillShowAndHideNoText()
        requestData()
    }
    
//    请求布局
    func requestForLayout() {
        let request = SKRequest.init()
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kMina_page_data+"?search=pid:0;status:1&searchJoin=and&sortedBy=desc&orderBy=sort") { (response) in
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                for index in 0..<datas.count{
                    let json = datas[index]
                    let model = LNNewMainLayoutModel.setupValues(json: json)
                    if model.layout1 == "3" {
                        weakSelf?.requestForLayout3(model: model)
                    }
                    weakSelf?.resource.append(model)
                }
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    
//    请求Layout=3的数据
    func requestForLayout3(model:LNNewMainLayoutModel) {
        let request = SKRequest.init()
        weak var weakSelf = self
        request.setParam(model.limit as NSObject, forKey: "limit")
        request.callGET(withUrl: LNUrls().kSwhow_coupon+"?"+model.params) { (response) in
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                var coupous = [LNYHQListModel]()
                for index in 0..<datas.count{
                    let json = datas[index]
                    let model = LNYHQListModel.setupValues(json: json)
                    coupous.append(model)
                }
                model.coupous = coupous
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    
    override func requestData() {
        let request = SKRequest.init()
        weak var weakSelf = self

        request.setParam(String(currentPage) as NSObject, forKey: "page")

        request.callGET(withUrl: BaseUrl+"/taoke/coupon?search=type:1;tag:2&searchJoin=and&orderBy=id&sortedBy=desc&limit=10") { (response) in
            LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                
                if !(response?.success)! {
                    weakSelf?.mainTableView.mj_footer.endRefreshing()
                    weakSelf?.mainTableView.mj_header.endRefreshing()
                    return
                }
                
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentPage == 1 {
//                        weakSelf?.couponsSource.removeAll()
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
                        let json = datas[index]
//                        let model = LNYHQListModel.setupValues(json: json)
//                        weakSelf?.couponsSource.append(model)
                        weakSelf?.newCouponsSource.append(SZYGoodsInformationModel.setupValues(json: json))
                    }
                    
                    if (weakSelf?.newCouponsSource.count)!>0{
                        var randomNumber:Int = Int(arc4random() % UInt32((weakSelf?.newCouponsSource.count)!))-1
                        
                        if randomNumber<0{
                            randomNumber = 0
                        }
                        if randomNumber+1 <= (weakSelf?.newCouponsSource.count)! {
                            Defaults[kGetTheRandomItemId] = weakSelf?.newCouponsSource[randomNumber].item_id
                        }
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
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.mj_offsetY > 600 {
            topBun.isHidden = false
        } else {
            topBun.isHidden = true
        }
        if scrollDelegate != nil {
            scrollDelegate?.didScroll(scrollView.mj_offsetY)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        页面打开，定时器开启
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LNresetTheTimer_Notification"), object: self, userInfo: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        //        页面打开，定时器开启
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LNresetTheTimer_Notification"), object: self, userInfo: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        页面消失，定时器关闭
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LNInvalidateTheTimer_Notification"), object: self, userInfo: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }

}

extension LNNewMainViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        if couponsSource.count>0 {
//            return 1+resource.count+1
//        }else{
//            return 1+resource.count
//        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == 0 {
//            return 1
//        }else if section == resource.count+1{
//
//            return couponsSource.count
//        }else{
//            if resource[section-1].layout1 == "3" {
//                return resource[section-1].coupous.count
//            }else{
//                return 1
//            }
//        }
        if section == 2 {
            return newCouponsSource.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNNewHeadCell
            cell.selectionStyle = .none
            cell.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable4, for: indexPath) as! nweCellTableViewCell
            cell.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)
            cell.selectionStyle = .none
            return cell
        } else /*if indexPath.section == 2*/ {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable3, for: indexPath) as! LNMainLayoutCell3
            cell.setValues1(model: newCouponsSource[indexPath.row], type: "")
            cell.selectionStyle = .none
            return cell
        }
        
//        if indexPath.section == resource.count+1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable3, for: indexPath) as! LNMainLayoutCell3
//            cell.setValues(model: couponsSource[indexPath.row], type: "")
//            cell.selectionStyle = .none
//            return cell
//        }
//        switch resource[indexPath.section-1].layout1 {
//        case "1":
//            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! LNMainLayoutCell1
//            cell.setDatas(model: resource[indexPath.section-1])
//            cell.selectionStyle = .none
//            return cell
//        case "2":
//            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! LNMainLayoutCell2
//            cell.setTitle(model: resource[indexPath.section-1])
//            cell.selectionStyle = .none
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable3, for: indexPath) as! LNMainLayoutCell3
//            if resource[indexPath.section-1].layout1 == "4" {
//                cell.setImage(image: resource[indexPath.section-1].thumb)
//            }else{
//                cell.setValues(model: resource[indexPath.section-1].coupous[indexPath.row], type: "s")
//            }
//            cell.selectionStyle = .none
//            return cell
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            return
        }
        
        if indexPath.section == 2 {
            let vc = SZYGoodsViewController()
            vc.good_item_id = newCouponsSource[indexPath.row].item_id
            vc.coupone_type = newCouponsSource[indexPath.row].type
            vc.goodsUrl = newCouponsSource[indexPath.row].pic_url
            vc.GoodsInformationModel = newCouponsSource[indexPath.row]
            superViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHead = UIView.init()
//        let titleLabel = UILabel.init(frame: CGRect(x: 16, y: 0, width: kSCREEN_WIDTH-100, height: 40))
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        titleLabel.textColor = kGaryColor(num: 80)
//
//        if section == resource.count+1 {
//            titleLabel.text = "精选宝贝"
//        }else{
//            titleLabel.text = resource[section-1].name
//            if section != 0 {
//                if resource[section-1].layout1 == "3" {
//                    let moreBtn = UIButton.init(frame: CGRect(x: kSCREEN_WIDTH-80, y: 0, width: 80, height: 40))
//                    moreBtn.setTitle("更多", for: .normal)
//                    moreBtn.setTitleColor(kGaryColor(num: 165), for: .normal)
//                    moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//                    moreBtn.setImage(UIImage.init(named: "路径496_more"), for: .normal)
//                    moreBtn.addTarget(self, action: #selector(pushToDate(sender:)), for: .touchUpInside)
//                    moreBtn.layoutButton(with: .right, imageTitleSpace: 5)
//                    moreBtn.tag = 10+section
//                    sectionHead.addSubview(moreBtn)
//                }
//            }
//        }
//        sectionHead.addSubview(titleLabel)
        sectionHead.contentMode = .scaleToFill
        sectionHead.backgroundColor = UIColor.white

        return sectionHead
    }
    
    @objc func pushToDate(sender:UIButton) {
        
        if resource[sender.tag-10-1].layout2 == "1" {
            let listVc = LNOtherListViewController2()
            listVc.model = resource[sender.tag-10-1]
            superViewController?.navigationController?.pushViewController(listVc, animated: true)
        }else{
            let listVc = LNOtherListViewController()
            listVc.model = resource[sender.tag-10-1]
            superViewController?.navigationController?.pushViewController(listVc, animated: true)
        }

    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if resource.count <= 1 || section == 0 {
//            return 0
//        }
//        if section == resource.count+1 {
//            return 40
//        }
//        if resource[section-1].layout1 == "1" {
//            return 0
//        }
//        if resource[section-1].layout1 == "3" {
//            return 40
//        }else{
//            return 0
//        }
        return 0.01
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let foot = UIView.init()
        foot.backgroundColor = kBGColor()
        
        return foot
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 0.01
    }
    
}
