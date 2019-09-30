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

class JDorPDDScreeningVC: LNBaseViewController {
    var typeIntString = "2"    // 2. 京东   3. 拼多多
    
    //    顶部导航栏
    fileprivate var navigationView: UIView!
    //    弧形的图案
    var headBottomImage = UIImageView()
    
    fileprivate var topView:LNTopScrollView5!
    
    let headImageView_H:CGFloat = 160
    let searchButton_H:CGFloat = 35
    let topView_H:CGFloat = 50
    
    
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
        titleLabel.text = typeIntString == "2" ? "京东" : "拼多多"
        changeStyle()
        
        var topHeight = navHeight
        if kSCREEN_HEIGHT >= 812 {
            topHeight = navHeight + 20
        }
        mainTableView = getTableView(frame: CGRect(x: 0, y: topHeight, width: kSCREEN_WIDTH, height: view.height - navHeight - 44), style: .grouped, vc: self)
        mainTableView.register(UINib.init(nibName: "LNMainLayoutCell3", bundle: nil), forCellReuseIdentifier: identyfierTable)// 这个有升级赚
        mainTableView.tag = 100
        view.addSubview(mainTableView)
        glt_scrollView = mainTableView
        
        topView = LNTopScrollView5.init(frame: CGRect(x: 0, y: headImageView_H + searchButton_H + 20, width: kSCREEN_WIDTH, height: topView_H))
        topView.datas = ["综合","销量","佣金","价格"]
        topView.backgroundColor = UIColor.white
        topView.setTopView(selectIndex: 0)
        topView.isUserInteractionEnabled = true
        weak var weakSelf = self
        topView.callBackBlock { (index,flag ) in
            
            switch index {
            case 0:
                weakSelf?.select_type = "id"
                weakSelf?.sortedBy = "desc"
            case 1:
    
                weakSelf?.select_type = "volume"
                
            case 2:
   
                weakSelf?.select_type = "coupon_price"
            case 3:
                if !flag {
                    weakSelf?.sortedBy = "asc"
                }else{
                    weakSelf?.sortedBy = "desc"
                }
                weakSelf?.select_type = "price"
                
            default:
                break
            }
            weakSelf?.requestData()
            
        }

        
    }
    
    
    //      #MARK:  跳转到搜索
    @objc func pushToSearch() {
        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
        search.hidesBottomBarWhenPushed = true
        search.isPresent = false
        search.typeString = typeIntString
        self.navigationController?.pushViewController(search, animated: false)
    }
    
    @objc func pushToDate() {  //左
        self.navigationController?.popViewController(animated: true)
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
            request.setParam("type:2" as NSObject, forKey: "search")
        } else if typeIntString == "3" {
            request.setParam("type:3" as NSObject, forKey: "search")
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
extension JDorPDDScreeningVC : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return GoodsInformationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        let sectionHead = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height:searchButton_H + headImageView_H + topView_H + 20))
        
        // 搜索框
        let searchButton = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: tableView.width - 20 , height: searchButton_H))
        searchButton.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton.layer.cornerRadius = searchButton_H / 2
        searchButton.clipsToBounds = true
        searchButton.backgroundColor = kGaryColor(num: 246)
        searchButton.setTitle("输入关键词搜索", for: .normal)
        searchButton.setTitleColor(kGaryColor(num: 69), for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        searchButton.addTarget(self, action: #selector(pushToSearch), for: .touchUpInside)
        searchButton.backgroundColor = UIColor.white
        sectionHead.addSubview(searchButton)
        
        // 京东/拼多多 图片
        let jingdongView = YHJDorPDDTableHeaderView.init(frame: CGRect.init(x: 0, y: searchButton_H + 20, width: kSCREEN_WIDTH, height: headImageView_H))
        jingdongView.setImage(type: typeIntString)
        jingdongView.backgroundColor = kSetRGBColor(r: 246, g: 246, b: 246)
        sectionHead.addSubview(jingdongView)
        
        // 筛选栏
        sectionHead.addSubview(topView)
        
        return sectionHead
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchButton_H + headImageView_H + topView_H + 20
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
