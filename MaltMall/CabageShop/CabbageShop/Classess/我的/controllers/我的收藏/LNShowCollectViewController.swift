//
//  LNShowCollectViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

class LNShowCollectViewController: LNBaseViewController {
    
    fileprivate let segmnet = UISegmentedControl.init(items: ["收藏","足迹"])
    
    var selectIndex = 0
    
    //    数据源
    fileprivate var resource = [LNMyCollectionModel]()
    var newResource = [SZYGoodsInformationModel]()
    

    
    fileprivate var request_url = LNUrls().kFavourite

    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()
        addImageWhenEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func configSubViews() {
        navigationTitle = "我的收藏"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.black
        backBtn.setImage(UIImage.init(named: "nav_return_black"), for: .normal)
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - CGFloat(navHeight) ), style: .plain, vc: self)
        mainTableView.register(UINib.init(nibName: "LNMainLayoutCell3", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tag = 1021
        mainTableView.separatorStyle = .none
        mainTableView.estimatedRowHeight = 50
        self.view.addSubview(mainTableView)
        
        
//        let segmnet = UISegmentedControl.init(items: ["收藏","足迹"])
//        segmnet.frame = CGRect(x: 0, y: 0, width: 170, height: 28)
//        segmnet.borderColor = UIColor.white
//        segmnet.tintColor = UIColor.white
//        segmnet.backgroundColor = kMainColor1()
//        segmnet.addTarget(self, action: #selector(didChanged(sender:)), for: .valueChanged)
//        segmnet.selectedSegmentIndex = 0
//        var backBtnCenterY = navigaView.centerY+10
//
//        if kSCREEN_HEIGHT == 812 {
//            backBtnCenterY = navigaView.centerY+20
//        }
//
//        segmnet.center = CGPoint(x: self.view.centerX, y: backBtnCenterY)
//        navigaView.addSubview(segmnet)
    }
    
    @objc func didChanged(sender:UISegmentedControl) {
        kDeBugPrint(item: sender.selectedSegmentIndex)
        selectIndex = sender.selectedSegmentIndex
        
        if selectIndex == 0 {
            request_url = LNUrls().kFavourite
        }else{
            request_url = LNUrls().kHistory
        }
        refreshHeaderAction()
    }
    
    
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
        
        weak var weakSelf = self
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("id" as NSObject, forKey: "orderBy")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        request.callGET(withUrl: request_url) { (response) in
            if !(response?.success)! {
                return
            }
            kDeBugPrint(item: response?.data)
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["last_page"].intValue
                    
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.newResource.removeAll()
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
                        weakSelf?.newResource.append(SZYGoodsInformationModel.setupValues(json: datas[index]))
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
    
    
    fileprivate var emptyView = UIView()
    
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
    }
    
}


//tableView代理
extension LNShowCollectViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newResource.count == 0 {
            self.mainTableView.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
        return newResource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNMainLayoutCell3
        cell.selectionStyle = .none
        
        cell.setValues1(model: newResource[indexPath.row], type: "5")
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVc = SZYGoodsViewController()
        detailVc.coupone_type = newResource[indexPath.row].type
        detailVc.good_item_id = newResource[indexPath.row].item_id
        detailVc.goodsUrl = newResource[indexPath.row].pic_url
        detailVc.GoodsInformationModel = newResource[indexPath.row]
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if selectIndex != 0 {
            return "删除足迹"
        }else{
            return "取消收藏"
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let request = SKRequest.init()
            weak var weakSelf = self
            
            var str = "/"
            
            if selectIndex != 0 {
                str = ""
            }
            
            request.callDELETE(withUrl:request_url + str + newResource[indexPath.row].id) { (response) in
                if !(response?.success)! {
                    return
                }
                weakSelf?.newResource.remove(at: indexPath.row)
                weakSelf?.mainTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let Header = UIView.init()
        Header.backgroundColor = kBGColor()
        
        return Header
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
