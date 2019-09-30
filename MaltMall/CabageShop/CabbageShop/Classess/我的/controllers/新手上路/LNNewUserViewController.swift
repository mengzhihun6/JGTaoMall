//
//  LNNewUserViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNNewUserViewController: LNBaseViewController {
        
    var isNewUser = true
    
    //    数据源
    fileprivate var resource = [LNArticlesModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configSubViews() {
        
        if isNewUser {
            navigationTitle = "新手上路"
        }else{
            navigationTitle = "常见问题"
        }
        titleLabel.textColor = UIColor.white
        self.navigaView.backgroundColor = kSetRGBAColor(r: 243, g: 66, b: 56, a: 0)

        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), style: .plain, vc: self)
        
        mainTableView.register(UINib(nibName: "LNNewUserTeachCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.separatorStyle = .none
        self.view.addSubview(mainTableView)
        
        let bgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH+80, height: kSCREEN_HEIGHT+100))
        bgView.image = getNavigationIMGVertical(NSInteger(self.view!.height+100), fromColor: kSetRGBColor(r: 255, g: 135, b: 82), toColor: kSetRGBColor(r: 255, g: 82, b: 84))
        bgView.contentMode = .scaleToFill
        self.view.insertSubview(bgView, at: 0)

    }
    
    override func refreshHeaderAction() {
        requestData()
    }
    
    override func requestData() {
        
        let request = SKRequest.init()
        if !isNewUser {
            request.setParam("category_id:2" as NSObject, forKey: "search")
        }else{
            request.setParam("category_id:1" as NSObject, forKey: "search")
        }
        request.setParam("sort" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")

        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kArticle) { (response) in
            
            DispatchQueue.main.async {
                weakSelf?.mainTableView.mj_header.endRefreshing()
                if !(response?.success)! {
                    return
                }
                weakSelf?.resource.removeAll()
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                for index in 0..<datas.count{
                    let json = datas[index]
                    let model = LNArticlesModel.setupValues(json: json)
                    weakSelf?.resource.append(model)
                }
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigaView.backgroundColor = kSetRGBAColor(r: 240, g: 137, b: 93, a: scrollView.contentOffset.y/navHeight)
    }

}

extension LNNewUserViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resource.count
    }       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNNewUserTeachCell
        cell.setUpValues(model:resource[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = LNArticelDetailViewController()
        detail.article_id = resource[indexPath.row].id
        detail.naviTitle = resource[indexPath.row].title
        navigationController?.pushViewController(detail, animated: true)
    }
    
    
    
}
