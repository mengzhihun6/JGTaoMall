//
//  LNSystemNoticeViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class LNSystemNoticeViewController: LNBaseViewController {

    @IBOutlet weak var topSpace: NSLayoutConstraint!
    
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var selectType1: UIButton!
    @IBOutlet weak var selectType2: UIButton!
    
    var goodsTableView = UITableView()
    
    let identyfierTable1 = "identyfierTable1"
    
    let mainScrollView = UIScrollView.init()
    
    fileprivate var resource = [LQMainMessageModel]()
    fileprivate var resource2 = [LQMainMessageModel]()

    //    当前分页
    var currentGoodPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        addImageWhenEmpty()
        addFooterRefresh()

        goodsTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            self.refreshGoodFooterAction()
        })
        goodsTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.refreshGoodHeaderAction()
        })
        requestData2()
        
    }
    
    override func configSubViews() {
        
        topSpace.constant = navHeight-UIApplication.shared.statusBarFrame.size.height
        
        navigationTitle = "消息"
        titleLabel.textColor = UIColor.white
        
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
        mainTableView.register(UINib.init(nibName: "LNShowNoticeCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tag = 100
        mainTableView.separatorStyle = .none
        mainScrollView.addSubview(mainTableView)
        
        goodsTableView = getTableView(frame: CGRect(x: kSCREEN_WIDTH, y: 0, width: kSCREEN_WIDTH, height: mainScrollView.height), style: .plain, vc: self)
        goodsTableView.register(UINib.init(nibName: "LNShowNoticeCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
        goodsTableView.tag = 101
        goodsTableView.separatorStyle = .none
        mainScrollView.addSubview(goodsTableView)
        
        mainScrollView.backgroundColor = kGaryColor(num: 245)
        mainTableView.backgroundColor = kGaryColor(num: 245)
        goodsTableView.backgroundColor = kGaryColor(num: 245)
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
    }
    
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    
    
    override func refreshFooterAction() {
        currentPage = currentPage+1
        requestData()
    }
    
    
    override func requestData() {
        
        let request = SKRequest.init()
        request.setParam("2" as NSObject, forKey: "type")
        request.setParam("id" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kNotification) { (response) in
            DispatchQueue.main.async {
                if (weakSelf?.mainTableView.mj_header.isRefreshing)! {
                    weakSelf?.mainTableView.mj_header.endRefreshing()
                }
                if !(response?.success)! {
                    
                    if weakSelf?.mainTableView.mj_footer != nil {
                        weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                    }

                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.resource.removeAll()
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
                        weakSelf?.resource.append(LQMainMessageModel.setupValues(json: datas[index]))
                    }
                }
                weakSelf?.mainTableView.reloadData()
                
            }
        }
    }
    
    
    func refreshGoodFooterAction() {
        currentGoodPage = currentGoodPage+1
        requestData2()
    }
    func refreshGoodHeaderAction() {
        
        currentGoodPage = 1
        requestData2()
    }
    
    func requestData2() {
        
        let request = SKRequest.init()
        request.setParam("1" as NSObject, forKey: "type")
        request.setParam(String(currentGoodPage) as NSObject, forKey: "page")
        request.setParam("id" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kNotification) { (response) in
            DispatchQueue.main.async {
                if (weakSelf?.goodsTableView.mj_header.isRefreshing)! {
                    weakSelf?.goodsTableView.mj_header.endRefreshing()
                }
                if !(response?.success)! {
                    
                    if weakSelf?.goodsTableView.mj_footer != nil {
                        weakSelf?.goodsTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    return
                }

                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentGoodPage == 1 {
                        weakSelf?.resource2.removeAll()
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
                        weakSelf?.resource2.append(LQMainMessageModel.setupValues(json: datas[index]))
                    }
                    
                }
                weakSelf?.goodsTableView.reloadData()
                
            }
        }
    }
    
    
    fileprivate var emptyView = UIView()
    fileprivate var emptyView2 = UIView()

    //    当数据为空的时候，显示提示
    func addImageWhenEmpty() {
        
        emptyView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 46))
        emptyView.backgroundColor = kBGColor()
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 200 * kSCREEN_SCALE, height: 200 * kSCREEN_SCALE))
//        imageView.image = UIImage.init(named: "collect_empty_icon")
        imageView.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 200 * kSCREEN_SCALE)
        emptyView.addSubview(imageView)

        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 18))
        label.textAlignment = .center
        label.textColor = kGaryColor(num: 110)
        label.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY-35)
        label.font = kFont30
        label.numberOfLines = 2
        label.text = "没有留下任何内容，随便看看吧~"
        emptyView.addSubview(label)
        
        
        emptyView2 = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 46))
        emptyView2.backgroundColor = kBGColor()
        
        let imageView2 = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 200 * kSCREEN_SCALE, height: 200 * kSCREEN_SCALE))
//        imageView2.image = UIImage.init(named: "collect_empty_icon")
        imageView2.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 200 * kSCREEN_SCALE)
        emptyView2.addSubview(imageView2)
        
        let label2 = UILabel.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 18))
        label2.textAlignment = .center
        label2.textColor = kGaryColor(num: 110)
        label2.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY-35)
        label2.font = kFont30
        label2.numberOfLines = 2
        label2.text = "没有留下任何内容，随便看看吧~"
        emptyView2.addSubview(label2)

    }

}


//tableView代理
extension LNSystemNoticeViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resource.count == 0 {
            self.mainTableView.addSubview(emptyView)
        }else{
            emptyView.removeFromSuperview()
        }
        
        if resource2.count == 0 {
            self.goodsTableView.addSubview(emptyView2)
        }else{
            emptyView2.removeFromSuperview()
        }

        if tableView.tag == 100 {
            return resource.count
        }else{
            return resource2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 100 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNShowNoticeCell
            cell.selectionStyle = .none
            cell.model = resource[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! LNShowNoticeCell
            cell.model = resource2[indexPath.row]
            cell.selectionStyle = .none
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
extension LNSystemNoticeViewController:UIScrollViewDelegate {
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
