//
//  LNDealLogViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNDealLogViewController: LNBaseViewController {
    
    //气泡
    fileprivate var showView = ArrowheadMenu()
    //    数据源
    var model = [WithdrawalRecordModel]()
    var type = String()
    var typeString = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addFooterRefresh()
        addImageWhenEmpty()
    }
    
    override func configSubViews() {
//        navigationTitle = "提现记录"
        titleLabel.textColor = UIColor.white
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), style: .plain, vc: self)
        
        mainTableView.register(UINib(nibName: "SZYLNShowDealLogCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.backgroundColor = kGaryColor(num: 246)
        mainTableView.separatorStyle = .none
        self.view.addSubview(mainTableView)
        
        let segmnet = UISegmentedControl.init(items: ["提现记录", "入账记录"])
        segmnet.frame = CGRect(x: 0, y: 0, width: 200, height: 28)
        segmnet.borderColor = UIColor.white
        segmnet.tintColor = UIColor.white
        segmnet.backgroundColor = kMainColor1()
        segmnet.addTarget(self, action: #selector(didChanged(sender:)), for: .valueChanged)
        segmnet.selectedSegmentIndex = 0
        var backBtnCenterY = navigaView.centerY+10
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navigaView.centerY+20
        }
        segmnet.center = CGPoint(x: self.view.centerX, y: backBtnCenterY)
        navigaView.addSubview(segmnet)
        
//        rightBtn1.setImage(UIImage.init(named: "more_icon_black"), for: .normal)
        //        气泡
        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: ["支出","收入",], icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        showView.delegate = self
    }
    @objc func didChanged(sender:UISegmentedControl) {
        kDeBugPrint(item: sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            typeString = "1"
        } else {
            typeString = "2"
        }
        refreshHeaderAction()
    }
    override func rightAction(sender: UIButton) {
//        showView.presentView(sender)
    }
    override func refreshHeaderAction() {
        requestData()
    }
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
    }
    override func requestData() {
        var urlString = ""
        let request = SKRequest.init()
        LQLoadingView().SVPwillShowAndHideNoText()
        if typeString == "1" {  //提现记录
            urlString = LNUrls().WithdrawalRecord
        } else { // 入账记录
            urlString = LNUrls().kCommissionLog
        }
        request.setParam("created_at" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("1" as NSObject, forKey: "page")
        weak var weakSelf = self
        request.callGET(withUrl: urlString) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                weakSelf?.model.removeAll()
                for index in 0..<datas.count{
                    if weakSelf?.typeString == "1" {
                        weakSelf?.model.append(WithdrawalRecordModel.setupValues(json: datas[index]))
                    } else {
                        weakSelf?.model.append(WithdrawalRecordModel.setupValues1(json: datas[index]))
                    }
                }
                weakSelf?.mainTableView.mj_header.endRefreshing()
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    fileprivate var emptyView = UIView()
    
    //    当数据为空的时候，显示提示
    func addImageWhenEmpty() {
        
        emptyView = UIView.init(frame: CGRect(x: 0, y: 50, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 64 - 50))
        emptyView.backgroundColor = kBGColor()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 92, height: 84))
        imageView.image = UIImage.init(named: "暂无收益")
        imageView.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 84 - 50)
        emptyView.addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 18))
        label.textAlignment = .center
        label.textColor = kGaryColor(num: 178)
        label.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 58)
        label.font = kFont30
        label.numberOfLines = 1
        label.text = "暂无提现记录"
        emptyView.addSubview(label)
    }
}

extension LNDealLogViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if model.count == 0 {
            self.mainTableView.addSubview(emptyView)
        }else{
            emptyView.removeFromSuperview()
        }
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! SZYLNShowDealLogCell
        cell.selectionStyle = .none
        cell.setToValues(model: model[indexPath.row], typeString: typeString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 50))
        headview.backgroundColor = kSetRGBColor(r: 236, g: 239, b: 243)
        
        let timeLabel = UILabel.init(frame: CGRect.init(x: 30, y: 14, width: 50, height: 23))
        timeLabel.text = "时间"
        timeLabel.textColor = kSetRGBColor(r: 180, g: 177, b: 178)
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        headview.addSubview(timeLabel)
        
        let withdrawalLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 23))
        withdrawalLabel.text = "提现（元）"
        withdrawalLabel.textColor = kSetRGBColor(r: 180, g: 177, b: 178)
        withdrawalLabel.font = UIFont.systemFont(ofSize: 16)
        withdrawalLabel.textAlignment = .center
        withdrawalLabel.center = headview.center
        headview.addSubview(withdrawalLabel)
        
        let stateLabel = UILabel.init(frame: CGRect.init(x: 200, y: 14, width: kSCREEN_WIDTH - 230, height: 23))
        stateLabel.textAlignment = .right
        stateLabel.text = "状态"
        stateLabel.textColor = kSetRGBColor(r: 180, g: 177, b: 178)
        stateLabel.font = UIFont.systemFont(ofSize: 16)
        headview.addSubview(stateLabel)
        
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension LNDealLogViewController:MenuViewControllerDelegate{
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
        type = String(tag+1)
        refreshHeaderAction()
    }
}
