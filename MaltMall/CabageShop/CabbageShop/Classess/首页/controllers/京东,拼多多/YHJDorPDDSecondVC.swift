//
//  YHJDorPDDSecondVC.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/6/12.
//  Copyright © 2019 宋. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MJRefresh

class YHJDorPDDSecondVC: LNBaseViewController {
    var typeIntString = "2"    // 2. 京东   3. 拼多多
    
    var GoodsInformationModel = [SZYGoodsInformationModel]() //商品信息
    
    var model = LNTopListModel()
    fileprivate var select_type = "id"
    fileprivate var sortedBy = "desc"
    weak var superViewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()
    }
    override func configSubViews()  {
        navigaView.isHidden = true
        var topHeight = navHeight
        if kSCREEN_HEIGHT >= 812 {
            topHeight = navHeight + 20
        }
        mainTableView = getTableView(frame: CGRect(x: 0, y: 44, width: kSCREEN_WIDTH, height: view.height - navHeight - 44), style: .grouped, vc: self)
        mainTableView.register(UINib.init(nibName: "LNMainLayoutCell3", bundle: nil), forCellReuseIdentifier: identyfierTable)// 这个有升级赚
        mainTableView.tag = 100
//        mainTableView.isScrollEnabled = false
        view.addSubview(mainTableView)
        glt_scrollView = mainTableView
    }
    ///下拉刷新事件
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    override func refreshFooterAction() {
        currentPage = currentPage + 1
        requestData()
    }
    
    override func requestData() {
        let request = SKRequest.init()
        if typeIntString == "2" {
            if model.jingdong == "" {
                request.setParam("type:2"as NSObject, forKey: "search")
            } else {
                request.setParam("cat:"+model.jingdong+";type:2"as NSObject, forKey: "search")
            }
        } else if typeIntString == "3" {
            if model.pinduoduo == "" {
                request.setParam("type:3"as NSObject, forKey: "search")
            } else {
                request.setParam("cat:"+model.pinduoduo+";type:3"as NSObject, forKey: "search")
            }
        }
        request.setParam(select_type as NSObject, forKey: "orderBy")
        request.setParam(sortedBy as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: LNUrls().kSwhow_coupon) { (response) in
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
                        weakSelf?.GoodsInformationModel.removeAll()
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
                        weakSelf?.GoodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: json))
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
}
//tableView代理
extension YHJDorPDDSecondVC : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoodsInformationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! DPComInfoTableViewCell
//        //        cell.selectionStyle = .none
//        //        cell.setUpModel(model: GoodsInformationModel[indexPath.row], typeString: "0")
//        //        return cell
//
//        if Defaults[kCommissionRate] == nil || StringToFloat(str: Defaults[kCommissionRate]!) == StringToFloat(str: Defaults[kNextCommissionRate]!) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! JTHComInfoTableViewCell
//            cell.selectionStyle = .none
//            cell.setUpModel(model: GoodsInformationModel[indexPath.row], typeString: "0")
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! DPComInfoTableViewCell
//            cell.selectionStyle = .none
//            cell.setUpModel(model: GoodsInformationModel[indexPath.row], typeString: "0")
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNMainLayoutCell3
        cell.setValues2(model: GoodsInformationModel[indexPath.row], type: "")
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        kDeBugPrint(item: GoodsInformationModel[indexPath.row].item_id)
        kDeBugPrint(item: GoodsInformationModel[indexPath.row].type)
        kDeBugPrint(item: GoodsInformationModel[indexPath.row].pic_url)
        
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = GoodsInformationModel[indexPath.row].item_id
        detailVc.coupone_type = GoodsInformationModel[indexPath.row].type
        detailVc.goodsUrl = GoodsInformationModel[indexPath.row].pic_url
        detailVc.GoodsInformationModel = GoodsInformationModel[indexPath.row]
        self.navigationController?.pushViewController(detailVc, animated: true)
        
    }
    // 表头
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHead = UIView.init()
        sectionHead.contentMode = .scaleToFill
        sectionHead.backgroundColor = kSetRGBColor(r: 246, g: 246, b: 246)
        return sectionHead
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
