//
//  LQShowQuanViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/29.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MJRefresh

class LQShowQuanViewController: LNBaseViewController {

    
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var selectType1: UIButton!
    @IBOutlet weak var selectType2: UIButton!

    var goodsTableView = UITableView()
    
    let identyfierTable1 = "identyfierTable1"

    let mainScrollView = UIScrollView.init()
    
    var selectIndex = 0
    
    
    var mainResource = [LNQuanSingleModel]()
    var goodResource = [LNQuanGoodsModel]()
    
    //    当前分页
    var currentGoodPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        addFooterRefresh()
        
        goodsTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            self.refreshGoodFooterAction()
        })
        goodsTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.refreshGoodHeaderAction()
        })
        
        requestGoodData()
        titleLabel.textColor = UIColor.white
    }
    
    override func configSubViews() {
        
        topSpace.constant = navHeight-UIApplication.shared.statusBarFrame.size.height
        
        navigationTitle = "推圈"
        backBtn.setImage(nil, for: .normal)
        
        navigationBackGroundImage.snp.updateConstraints { (ls) in
            ls.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height)
        }

        
        mainScrollView.frame = CGRect(x: 0, y: navHeight+42, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight-42)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delegate = self
        mainScrollView.tag = 1000
        mainScrollView.isPagingEnabled = true
        mainScrollView.contentSize = CGSize(width: kSCREEN_WIDTH*2, height: kSCREEN_HEIGHT - CGFloat(navHeight) - 42)
        mainScrollView.bounces = false
        self.view.addSubview(mainScrollView)

        mainTableView = getTableView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: mainScrollView.height), style: .plain, vc: self)
        mainTableView.register(UINib.init(nibName: "LNShowQuanCell1", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tag = 100
        mainScrollView.addSubview(mainTableView)
        
        goodsTableView = getTableView(frame: CGRect(x: kSCREEN_WIDTH, y: 0, width: kSCREEN_WIDTH, height: mainScrollView.height), style: .plain, vc: self)
        goodsTableView.register(UINib.init(nibName: "LNShowQuanCell2", bundle: nil), forCellReuseIdentifier: identyfierTable1)
        goodsTableView.tag = 101
        mainScrollView.addSubview(goodsTableView)
        
//        changeStyle()
    }
    @IBAction func chooseSelectAction(_ sender: UIButton) {
        
        sender.isSelected = true
        UIView.animate(withDuration: 0.3) {
            self.underLine.centerX = sender.centerX
            if sender == self.selectType1 {
                self.selectType2.isSelected = false
                self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
            }else{
                self.selectType1.isSelected = false
                self.mainScrollView.contentOffset = CGPoint(x: kSCREEN_WIDTH, y: 0)
            }
        }
        selectIndex = sender.tag - 100
        
    }

    override func refreshHeaderAction() {
        
        currentPage = 1
        requestData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if selectIndex == 1 {
            chooseSelectAction(selectType2)
        } else {
            chooseSelectAction(selectType1)
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func refreshFooterAction() {
        currentPage = currentPage+1
        requestData()
    }
    
    
    func refreshGoodFooterAction() {
        currentGoodPage = currentGoodPage+1
        requestGoodData()
    }
    func refreshGoodHeaderAction() {
        
        currentGoodPage = 1
        requestGoodData()
    }

    func requestGoodData() {
        
        let request = SKRequest.init()
        DispatchQueue.main.async {
            LQLoadingView().SVPwillShowAndHideNoText()
        }
        
        request.setParam(String(currentGoodPage) as NSObject, forKey: "page")
        request.setParam("id" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        let requestUrl = "/taoke/haohuo"
        weak var weakSelf = self
        request.callGET(withUrl: BaseUrl+requestUrl) { (response) in
            DispatchQueue.main.async {

                if !(response?.success)! {
                    weakSelf?.goodsTableView.mj_footer.endRefreshing()
                    if weakSelf?.goodsTableView.mj_footer != nil {
                        weakSelf?.goodsTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    return
                }
                
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentGoodPage == 1 {
                        weakSelf?.goodResource.removeAll()

                        if weakSelf?.currentGoodPage == pages {
                            weakSelf?.goodsTableView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.goodsTableView.mj_footer.resetNoMoreData()
                        }
                        
                    }else{
                        
                        if (weakSelf?.currentGoodPage)! >= pages {
                            weakSelf?.goodsTableView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.goodsTableView.mj_footer.endRefreshing()
                        }
                        
                    }
                    
                    for index in 0..<datas.count{
                        weakSelf?.goodResource.append(LNQuanGoodsModel.setupValues(json: datas[index]))
                    }
                    if (weakSelf?.goodsTableView.mj_header.isRefreshing)! {
                        weakSelf?.goodsTableView.mj_header.endRefreshing()
                    }
                }else{

                    if weakSelf?.goodsTableView.mj_footer != nil {
                        weakSelf?.goodsTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
               
                if (weakSelf?.mainResource.count)!>0 {
                    LQLoadingView().SVPHide()
                }
                weakSelf?.goodsTableView.reloadData()
            }
        }
    }
    
    
    override func requestData() {
        
        let request = SKRequest.init()
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        request.setParam("show_at" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        let requestUrl = "/taoke/jingxuan"
        DispatchQueue.main.async {
            LQLoadingView().SVPwillShowAndHideNoText()
        }
        
        weak var weakSelf = self
        request.callGET(withUrl: BaseUrl+requestUrl) { (response) in
            DispatchQueue.main.async {
                if !(response?.success)! {
                    weakSelf?.mainTableView.mj_footer.endRefreshing()
                    if weakSelf?.mainTableView.mj_footer != nil {
                        weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    return
                }

                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.mainResource.removeAll()
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
                        weakSelf?.mainResource.append(LNQuanSingleModel.setupValues(json: datas[index]))
                    }
                    
                    if (weakSelf?.mainTableView.mj_header.isRefreshing)! {
                        weakSelf?.mainTableView.mj_header.endRefreshing()
                    }
                }else{
                    if weakSelf?.mainTableView.mj_footer != nil {
                        weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                LQLoadingView().SVPHide()
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }
}


//tableView代理
extension LQShowQuanViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            return mainResource.count
        }else{
            return goodResource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNShowQuanCell1
            cell.selectionStyle = .none
            cell.model = mainResource[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! LNShowQuanCell2
            cell.selectionStyle = .none
            cell.model = goodResource[indexPath.row]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.tag == 100 {

        }else{
            
        }
    }
    
}
extension LQShowQuanViewController:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 1000 {
            let offSet = scrollView.contentOffset.x/kSCREEN_WIDTH
            UIView.animate(withDuration: 0.3) {
                if offSet == 0 {
                    self.selectType1.isSelected = true
                    self.selectType2.isSelected = false
                    self.underLine.centerX = self.selectType1.centerX
                }else{
                    self.selectType1.isSelected = false
                    self.selectType2.isSelected = true
                    self.underLine.centerX = self.selectType2.centerX
                }
            }
        }
    }
}


