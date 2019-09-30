//
//  SZYItemViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/16.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MJRefresh

class SZYItemViewController: LNBaseViewController {
    var mainResource = [LNQuanSingleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigaView.isHidden = true
        addFooterRefresh()
        
    }
    override func configSubViews() {
        mainTableView = getTableView(frame: CGRect(x: 0, y: 44, width: kSCREEN_WIDTH, height: view.height - 64 - 44 - 49), style: .grouped, vc: self)
        mainTableView.register(UINib.init(nibName: "LNShowQuanCell1", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tag = 100
        mainTableView.separatorStyle = .none
        view.addSubview(mainTableView)
        glt_scrollView = mainTableView
    }
    override func refreshFooterAction() {
        currentPage = currentPage+1
        requestData()
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
}
//tableView代理
extension SZYItemViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainResource.count//1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//mainResource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNShowQuanCell1
        cell.selectionStyle = .none
        cell.model = mainResource[indexPath.section]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.tag == 100 {
            
        }else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 10
        } else {
            return 0.01
        }
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
