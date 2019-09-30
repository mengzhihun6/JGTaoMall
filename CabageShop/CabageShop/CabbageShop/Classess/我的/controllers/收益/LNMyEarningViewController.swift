//
//  LNMyEarningViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyJSON

class LNMyEarningViewController: LNBaseViewController {
    
    @IBOutlet weak var head_bgImageView: UIImageView!
    
    @IBOutlet weak var head_height: NSLayoutConstraint!
    
    @IBOutlet weak var under_line: UIView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    
    var EarningsModel : SZYEarningsModel!
    
    var selectIndex = 1
    fileprivate var selectType = 1

    fileprivate var date_type = String()
    var userModel : SZYPersonalCenterModel?
    var model = LNMemberModel()
    
    let identyfierTable1  = "identyfierTable1"
//    fileprivate var showView = ArrowheadMenu()
    //    顶部选择栏
    var topView = LNTopSelectView()
    
    override func viewDidLoad() {
        if Device() == .iPhoneX {
            head_height.constant = 184 + 20
        }
        if kSCREEN_HEIGHT == 812 {
            head_height.constant = 184 + 20
        }
        switch selectIndex {
        case 1:
            date_type = "today"
        case 2:
            date_type = "yesterday"
        case 3:
            date_type = "week"
        case 4:
            date_type = "month"
        case 5:
            date_type = "lastMonth"
        default:
            date_type = ""
        }  //  第一次在父类 调用请求
        super.viewDidLoad()
        navigationTitle = "我的收益"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.clear
        head_bgImageView.isUserInteractionEnabled = true
    }
    
    override func backAction(sender: UIButton) {
//        if self.tabBarController?.presentingViewController != nil {
//            self.tabBarController?.dismiss(animated: true, completion: nil)
//        }else{
//            self.tabBarController?.navigationController?.popViewController(animated: true)
//        }
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func requestData() {
        let request = SKRequest.init()
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        request.setParam(date_type as NSObject, forKey: "date_type")
//        request.setParam("" as NSObject, forKey: "")
        request.callGET(withUrl: LNUrls().kShouyi) { (response) in
            DispatchQueue.main.async {
                LQLoadingView().SVPHide()
                weakSelf?.mainTableView.mj_header.endRefreshing()
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!)
                weakSelf?.EarningsModel = SZYEarningsModel.setupValues(json: datas)
                weakSelf?.moneyLabel.text = OCTools().getStrWithFloatStr2(weakSelf?.EarningsModel.order.money)
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    func requsetALL () {
        let request = SKRequest.init()
        LQLoadingView().SVPwillShowAndHideNoText()
        weak var weakSelf = self
        request.setParam(date_type as NSObject, forKey: "date_type")
        request.callGET(withUrl: LNUrls().kShouyi) { (response) in
            
            DispatchQueue.main.async {
                
                weakSelf?.mainTableView.mj_header.endRefreshing()
                if !(response?.success)! {
                    return
                }
//                let datas =  JSON((response?.data["data"])!)
//                weakSelf?.order_count = datas["order"].stringValue
//                weakSelf?.order_amont = datas["commission"].stringValue
                weakSelf?.mainTableView.reloadData()
            }
        }
    }

    override func configSubViews() {
        
        topView = LNTopSelectView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 44))
        topView.backgroundColor = UIColor.clear
        topView.normalColor = kGaryColor(num: 255)
        topView.selectColor = kGaryColor(num: 255)
        let mainTableArr = NSMutableArray.init(array: ["今日", "昨日", "近七天", "本月", "上月"])
        topView.setTopView(titles: mainTableArr as! [String], selectIndex: selectIndex - 1)
        weak var weakSelf = self
        topView.callBackBlock { (index) in
            kDeBugPrint(item: index)
            weakSelf?.selectIndex = Int(index)! + 1
            switch index {
            case "0":
                weakSelf?.date_type = "today"
            case "1":
                weakSelf?.date_type = "yesterday"
            case "2":
                weakSelf?.date_type = "week"
            case "3":
                weakSelf?.date_type = "month"
            case "4":
                weakSelf?.date_type = "lastMonth"
            default:
                weakSelf?.date_type = ""
            }
            if weakSelf?.date_type.count != 0 {
                weakSelf?.refreshHeaderAction()
            }
        }
        head_bgImageView.addSubview(topView)
        topView.underLine.backgroundColor = UIColor.white
        topView.snp.makeConstraints { (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.height.equalTo(45)
        }
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: CGFloat(navHeight)+47, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - CGFloat(navHeight) - 49), style: .grouped, vc: self)
        mainTableView.register(UINib.init(nibName: "SZYLNNewEarningCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        
        mainTableView.separatorStyle = .none
        mainTableView.backgroundColor = kBGColor()
        mainTableView.estimatedSectionFooterHeight = 0
        mainTableView.estimatedSectionHeaderHeight = 0
        self.view.addSubview(mainTableView)
        
        mainTableView.snp.makeConstraints { (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalTo(head_bgImageView.snp.bottom)
        }
//        let titles = ["淘宝","京东","拼多多",]
//        //        气泡
//        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: titles, icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
//        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
//        showView.delegate = self
    }
    
    override func refreshHeaderAction() {
        requestData()
    }
    // 放弃使用
    @IBAction func selectShowInfo(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.under_line.centerX = sender.centerX
            
        }
        selectIndex = sender.tag-100
        
        switch selectIndex {
        case 1:
            date_type = "today"
        case 2:
            date_type = "yesterday"
        case 3:
            date_type = "week"
        case 4:
            date_type = "month"
        case 5:
            date_type = "lastMonth"
        default:
            date_type = ""
        }
        if date_type.count != 0 {
            refreshHeaderAction()
        }else{
//            requsetALL()
        }
    }
    
}
//tableView代理
extension LNMyEarningViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if EarningsModel != nil {
            return 6
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! SZYLNNewEarningCell
        switch indexPath.section {
        case 0:
            let yugu = StringToFloat(str: EarningsModel.commission.commission1) + StringToFloat(str: EarningsModel.commission.commission2) + StringToFloat(str: EarningsModel.commission.groupCommission1) + StringToFloat(str: EarningsModel.commission.groupCommission2)
            let yuguStr = String.init(format:"%.2f",yugu)
//            let diandan = Int(EarningsModel.order.commissionGroup1)! + Int(EarningsModel.order.commissionGroup2)! + Int(EarningsModel.order.commissionOrder1)! + Int(EarningsModel.order.commissionOrder2)!
            if selectIndex == 1 {
                cell.setValues(title: "今日收益", yuguStr: yuguStr, dindanStr: EarningsModel.order.sum)
            } else if selectIndex == 2 {
                cell.setValues(title: "昨日收益", yuguStr: yuguStr, dindanStr: EarningsModel.order.sum)
            } else if selectIndex == 3 {
                cell.setValues(title: "近七天收益", yuguStr: yuguStr, dindanStr: EarningsModel.order.sum)
            } else if selectIndex == 4 {
                cell.setValues(title: "本月收益", yuguStr: yuguStr, dindanStr: EarningsModel.order.sum)
            } else if selectIndex == 5 {
                cell.setValues(title: "上月收益", yuguStr: yuguStr, dindanStr: EarningsModel.order.sum)
            }
            break
        case 1:
            if selectIndex == 1 {
                cell.setValues(title: "今日结算", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.userNum), dindanStr: EarningsModel.order.orderNum)
            } else if selectIndex == 2 {
                cell.setValues(title: "昨日结算", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.userNum), dindanStr: EarningsModel.order.orderNum)
            } else if selectIndex == 3 {
                cell.setValues(title: "近七天结算", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.userNum), dindanStr: EarningsModel.order.orderNum)
            } else if selectIndex == 4 {
                cell.setValues(title: "本月结算", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.userNum), dindanStr: EarningsModel.order.orderNum)
            } else if selectIndex == 5 {
                cell.setValues(title: "上月结算", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.userNum), dindanStr: EarningsModel.order.orderNum)
            }
            break
        case 2:
            cell.setValues(title: "自产收益", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.commission1), dindanStr: EarningsModel.order.commissionOrder1)
            break
        case 3:
            cell.setValues(title: "下级收益", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.commission2), dindanStr: EarningsModel.order.commissionOrder2)
            break
        case 4:
            cell.setValues(title: "团队收益", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.groupCommission1), dindanStr: EarningsModel.order.commissionGroup1)
            break
        case 5:
            cell.setValues(title: "补贴收益", yuguStr: OCTools().getStrWithFloatStr2(EarningsModel.commission.groupCommission2), dindanStr: EarningsModel.order.commissionGroup2)
            break
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView.init()
        headview.backgroundColor = kBGColor()
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headview = UIView.init()
        headview.backgroundColor = kBGColor()
        return headview
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func StringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string) {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
}


extension LNMyEarningViewController:MenuViewControllerDelegate{
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
        switch tag {
        case 0:
            selectType = 1
        case 1:
            selectType = 2
        default:
            selectType = 3
        }
        
//        if selectIndex == 1 {
//            requestData()
//        }else{
//            requsetALL()
//        }
    }
}

