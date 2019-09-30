//
//  LNOrderViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNOrderViewController: LNBaseViewController, UITextFieldDelegate{
    fileprivate var showView = ArrowheadMenu()
    fileprivate var calendarShowView = ArrowheadMenu()
    
    //    顶部选择栏
    var topView = LNTopSelectView()
    
    //
    fileprivate var isUneffect = false
    fileprivate var selectIndex = 0
    
    //    数据源
    fileprivate var resource = [LNOrderModel]()
    
    @IBOutlet weak var headView: UIView!
    
    @IBOutlet weak var under_line: UIView!
    
    
    var select_sort = String()   //全部 已付款   已结算  已失效
    fileprivate var select_type = "1"  //淘宝 京东  拼多多
    var classify = "1"     // 直推订单  下级订单...
    fileprivate var dateStr = ""     // 今日订单  昨日订单...

    //    当前选择的下标
    fileprivate var currentIndex = 0
    //  订单号
    var orderNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTitleView()
        addFooterRefresh()
        
        under_line.layer.cornerRadius = under_line.height/2
        under_line.clipsToBounds = true
        headView.removeFromSuperview()
        
        navigationTitle = "我的订单"
//        navigationBgImage = UIImage.init(named: "Rectangle") 
    }
    
    override func configSubViews() {
        
        let textField = UITextField.init(frame: CGRect.init(x: 40, y: navHeight + 10, width: kSCREEN_WIDTH - 80, height: 35))
        textField.backgroundColor = UIColor.white
        textField.clipsToBounds = true
        textField.delegate = self
        textField.returnKeyType = .search
        textField.cornerRadius = textField.height / 2.0
        textField.placeholder = "搜索你的订单号"
        textField.textColor = kGaryColor(num: 153)
        textField.font = UIFont.systemFont(ofSize: 14)
        
        let view1 = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 12, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "Shape")
        view1.addSubview(leftImage)
        textField.leftView = view1
        textField.leftViewMode = .always
        view.addSubview(textField)
        
        topView = LNTopSelectView.init(frame: CGRect(x: 0, y: navHeight + 10 + 35 + 8, width: kSCREEN_WIDTH, height: 44))
        topView.backgroundColor = UIColor.clear
        let mainTableArr = NSMutableArray.init(array: ["全部", "已付款", "已结算", "已失效"])
        
        if select_sort == "" {
            topView.setTopView(titles: mainTableArr as! [String], selectIndex: 0)
        } else {
            topView.setTopView(titles: mainTableArr as! [String], selectIndex: Int(select_sort)!)
        }
        weak var weakSelf = self
        topView.callBackBlock { (index) in
            kDeBugPrint(item: index)
            switch index {
            case "0":
                weakSelf?.select_sort = ""
            case "1":
                weakSelf?.select_sort = "1"
            case "2":
                weakSelf?.select_sort = "2"
            case "3":
                weakSelf?.select_sort = "3"
            default:
                break
            }
            weakSelf?.refreshHeaderAction()
        }
        self.view.addSubview(topView)
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: CGFloat(navHeight)+47, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - CGFloat(navHeight) - 49), style: .plain, vc: self)
        mainTableView.register(UINib.init(nibName: "SZYLQOrderListCellTB", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tag = 1021
        mainTableView.backgroundColor = kGaryColor(num: 245)
        self.view.addSubview(mainTableView)
        
        mainTableView.snp.makeConstraints { (ls) in
            ls.top.equalTo(topView.snp.bottom)
            ls.left.right.bottom.equalToSuperview()
        }
        addImageWhenEmpty()
    }
    
    override func backAction(sender: UIButton) {
//        if self.tabBarController?.presentingViewController != nil {
//            self.tabBarController?.dismiss(animated: true, completion: nil)
//        }else{
//            self.tabBarController?.navigationController?.popViewController(animated: true)
//        }
        self.navigationController?.popViewController(animated: true)
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
        
        if orderNumber != "" {
            if select_sort.count == 0 {
                request.setParam("type:1;trade_parent_id:" + orderNumber as NSObject, forKey: "search")
            } else {
                request.setParam("type:1;status:"+select_sort + ";trade_parent_id:" + orderNumber as NSObject, forKey: "search")
            }
        } else {
            if select_sort.count == 0 {
                request.setParam("type:1" as NSObject, forKey: "search")
            } else {
                request.setParam("type:1;status:"+select_sort as NSObject, forKey: "search")
            }
        }
        if classify != "" {
            request.setParam(classify as NSObject, forKey: "sendType") //直推...
        }
        if dateStr != "" {
            request.setParam(dateStr as NSObject, forKey: "time") //时间
        }
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        request.setParam("created_at" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        LQLoadingView().SVPwillShowAndHideNoText()

        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kOrder) { (response) in
            LQLoadingView().SVPHide()
            kDeBugPrint(item: response?.data)
            weakSelf?.orderNumber = ""
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
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
                        weakSelf?.resource.append(LNOrderModel.setupValues(json: datas[index]))
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

    
    fileprivate func resetTitleView() {
        
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = kMainColor1()
        
        rightBtn1.setImage(UIImage.init(named: "more_icon"), for: .normal)
        rightBtn2.setImage(UIImage.init(named: "main_page_left"), for: .normal)
        rightBtn1.snp.makeConstraints { (ls) in
            ls.right.equalToSuperview().offset(-5)
            ls.width.equalTo(40)
            ls.height.equalTo(30)
            ls.centerY.equalTo(backBtn)
        }
        rightBtn2.snp.makeConstraints { (ls) in
            ls.right.equalTo(rightBtn1.snp.left).offset(0)
            ls.width.equalTo(40)
            ls.height.equalTo(30)
            ls.centerY.equalTo(backBtn)
        }
        let titles = ["直推订单","下级订单","团队订单","补贴订单",] // 气泡
        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: titles, icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        showView.numInt = 100
        showView.delegate = self
        
        let titles1 = ["今日订单","昨日订单","近七天订单","本月订单","上月订单"]
        calendarShowView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: titles1, icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        calendarShowView.numInt = 101
        calendarShowView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        calendarShowView.delegate = self
    }
    
    
    @IBAction func selectShowInfo(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.under_line.centerX = sender.centerX
            
        }
        select_type = String(sender.tag-100)
        refreshHeaderAction()
    }

    
    
    override func rightAction(sender: UIButton) {
        
        showView.presentView(sender)
    }
    override func rightAction2(sender:UIButton) {
        calendarShowView.presentView(sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    fileprivate var emptyView = UIView()
    
    //    当数据为空的时候，显示提示
    func addImageWhenEmpty() {
        _ = emptyView.subviews.map {
            $0.removeFromSuperview()
        }

        emptyView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: mainTableView.height))
        emptyView.backgroundColor = kBGColor()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 111, height: 73))
        imageView.image = UIImage.init(named: "暂无相关数据")
        imageView.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 73 - 40)
        emptyView.addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 18))
        label.textAlignment = .center
        label.textColor = kGaryColor(num: 179)
        label.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 18 - 30)
        label.font = kFont34
        label.text = "暂无订单记录"
        emptyView.addSubview(label)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if (searchTextfield.text?.count)! == 0 {
//            setToast(str: "请输入关键词")
//
//            return false
//        }
//
//        let ressult = LQSearchResultViewController()
//        ressult.keyword = searchTextfield.text!
//        ressult.type  = "1"
//        self.navigationController?.pushViewController(ressult, animated: true)
//        textField.text = nil
//        textField.resignFirstResponder()
        if textField.text != "" {
            orderNumber = textField.text!
            currentPage = 1
            requestData()
        }
        self.view.endEditing(true)
        return true
    }
}


//tableView代理
extension LNOrderViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if resource.count == 0 {
            if !self.mainTableView.subviews.contains(emptyView) {
                self.mainTableView.addSubview(emptyView)
            }
        }else{
            emptyView.removeFromSuperview()
        }
        return resource.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! SZYLQOrderListCellTB
        cell.setupValues(model: resource[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kBGColor()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


extension LNOrderViewController:MenuViewControllerDelegate{
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
        let view = menu as! ArrowheadMenu
        if view.numInt == 100 { //上下级
            classify = String(tag+1)
        } else if view.numInt == 101 { //日历
            dateStr = String(tag+1)
//            switch tag {
//            case 0:
//                dateStr = "today"
//                break
//            case 1:
//                dateStr = "yestday"
//                break
//            case 2:
//                dateStr = "week"
//                break
//            case 3:
//                dateStr = "month"
//                break
//            case 4:
//                dateStr = "lastMonth"
//                break
//            default: break
//            }
        }
        refreshHeaderAction()
    }
}
