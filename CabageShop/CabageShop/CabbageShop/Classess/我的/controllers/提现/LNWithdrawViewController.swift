//
//  LNWithdrawViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNWithdrawViewController: LNBaseViewController {
    let identyfierTable1  = "identyfierTable1"
    let identyfierTable2  = "identyfierTable2"
    
    var model = LNMemberModel()
    var model1 = SZYPersonalCenterModel()
    var model2 = SZYChartModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.textColor = UIColor.white
    }
    
    override func configSubViews() {
        
        navigationTitle = "提现"
//        navigationBgImage = UIImage.init(named: "Rectangle_01")
        titleLabel.textColor = UIColor.white
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), style: .plain, vc: self)
        
        mainTableView.register(UINib(nibName: "LNWithdrawCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.register(UINib(nibName: "SZYLNWithdrawCell", bundle: nil), forCellReuseIdentifier: identyfierTable1)
        mainTableView.register(UINib(nibName: "SZYWithdrawalAmountCell", bundle: nil), forCellReuseIdentifier: identyfierTable2)
        
        mainTableView.separatorStyle = .none
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.backgroundColor = kGaryColor(num: 245)
        
        self.view.addSubview(mainTableView)
        
//        btnTitle = "流水"
        
        rightBtn1.setImage(UIImage.init(named: "记录"), for: .normal)
        rightBtn1.setTitleColor(kSetRGBColor(r: 0, g: 0, b: 0), for: .normal)
    }
    
    override func backAction(sender: UIButton) {
//        if self.tabBarController?.presentingViewController != nil {
//            self.tabBarController?.dismiss(animated: true, completion: nil)
//        }else{
//            self.tabBarController?.navigationController?.popViewController(animated: true)
//        }
        self.navigationController?.popViewController(animated: true)
    }

    override func rightAction(sender: UIButton) {

        self.navigationController?.pushViewController(LNDealLogViewController(), animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }

}

extension LNWithdrawViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! SZYLNWithdrawCell
//            cell.model = model1
            cell.setUpUserInfo(model: model1, chart: model2)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable2, for: indexPath) as! SZYWithdrawalAmountCell
//            cell.model = model1
            cell.setUpUserInfo(model: model1, chart: model2)
            cell.selectionStyle = .none
            return cell
        }
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
        }else{
            return 10
        }
    }
}
