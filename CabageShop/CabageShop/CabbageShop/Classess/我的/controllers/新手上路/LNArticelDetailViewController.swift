//
//  LNArticelDetailViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNArticelDetailViewController: LNBaseViewController {
    
    //    数据源
    fileprivate var imageStr = String()
    fileprivate var titleStr = String()
    fileprivate var contentStr = String()

    var article_id = String()
    var naviTitle = String()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configSubViews() {
        
        
        navigationTitle = naviTitle
        
        titleLabel.textColor = UIColor.white
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), style: .plain, vc: self)
        
        mainTableView.register(UINib(nibName: "LNArticleDetailCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.separatorStyle = .none
        self.view.addSubview(mainTableView)
        
    }
    
    override func refreshHeaderAction() {
        requestData()
    }
    
    override func requestData() {
        
        let request = SKRequest.init()
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kArticle+"/"+article_id) { (response) in
            
            DispatchQueue.main.async {
                weakSelf?.mainTableView.mj_header.endRefreshing()
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"]
                
                weakSelf?.imageStr = datas["thumb"].stringValue
                weakSelf?.contentStr = datas["content"].stringValue
                weakSelf?.titleStr = datas["title"].stringValue
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
}

extension LNArticelDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if titleStr.count == 0 {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNArticleDetailCell
        cell.setImage(image: imageStr, titleStr: titleStr, content: contentStr)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
