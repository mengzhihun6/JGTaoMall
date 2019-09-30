//
//  SZYFansViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/2/23.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYFansViewController: LNBaseViewController {
    
    let identyfierTable1 = "identyfierTable1"
    let identyfierTable2 = "identyfierTable2"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func configSubViews() {
        navigationTitle = "我的团队"
        titleLabel.textColor = UIColor.white
//        navigationBgImage = UIImage.init(named: "Rectangle")
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), style: .grouped, vc: self)
        mainTableView.register(UINib(nibName: "LNShowMyTeamCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        
        mainTableView.register(UINib(nibName: "SZYTeamMyRefereeCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
        mainTableView.register(UINib(nibName: "SZYTeamDataReportCell", bundle: nil), forCellReuseIdentifier: identyfierTable2)
        mainTableView.separatorStyle = .none
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.backgroundColor = kGaryColor(num: 245)
        
        self.view.addSubview(mainTableView)
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
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    override func requestData() {
        let request = SKRequest.init()
        LQLoadingView().SVPwillShowAndHideNoText()
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kTuanDui) { (response) in
            DispatchQueue.main.async {
                LQLoadingView().SVPHide()
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data)!)["data"]
                
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
}
extension SZYFansViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        if tuandui != nil {
//            return 2
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! SZYTeamMyRefereeCell
            cell.selectionStyle = .none
//            cell.setToValues(model: self.tuandui!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! SZYTeamDataReportCell
            cell.selectionStyle = .none
//            cell.setToValues(model: self.tuandui!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            let headview = UIView.init()
            headview.backgroundColor = kBGColor()
            return headview
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 16
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headview = UIView.init()
        headview.backgroundColor = kBGColor()
        return headview
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
