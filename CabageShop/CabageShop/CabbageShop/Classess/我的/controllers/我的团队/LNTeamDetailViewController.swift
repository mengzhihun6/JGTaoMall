//
//  LNTeamDetailViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/22.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import DeviceKit

class LNTeamDetailViewController: LNBaseViewController {
    //气泡
    fileprivate var showView = ArrowheadMenu()    //    数据源
    fileprivate var resource = [LNMyFansModel]()
//    导航View
    var navigationBarView = UIView()
//    搜索框
    var searchTextfield = UITextField()
//    底部人数
    var numLabel = UILabel()
    
    var inviter_id = String()
    var userName = String()
    var xiaji = String()
    
    
    fileprivate var searchLevel = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImageWhenEmpty()
        addFooterRefresh()
    }
    
    override func configSubViews() {
        navigaView.isHidden = true
        var viewHeight:CGFloat = 86
        var backBtnCenterY = viewHeight / 2 + 10
        if Device() == .iPhoneX {
            backBtnCenterY = navigaView.centerY+20
            viewHeight = viewHeight + 20
        }
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navigaView.centerY+20
            viewHeight = viewHeight + 20
        }
        navigationBarView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: viewHeight))
        self.view.addSubview(navigationBarView)
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: viewHeight))
//        imageView.image = UIImage.init(named: "Rectangle")
        imageView.backgroundColor = kSetRGBColor(r: 233, g: 13, b: 68)
        navigationBarView.addSubview(imageView)
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "nav_return_white"), for: .normal)
        button.addTarget(self, action: #selector(buttonBackAction(sender:)), for: .touchUpInside)
        navigationBarView.addSubview(button)
        
        button.snp.makeConstraints { (ls) in
            ls.left.equalTo(0)
            ls.centerY.equalTo(backBtnCenterY)
            ls.width.equalTo(35)
            ls.height.equalTo(35)
        }
        
        searchTextfield.borderStyle = .none
        searchTextfield.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-60, height: 34))
        searchTextfield.placeholder = "输入手机号搜索"
        searchTextfield.leftViewMode = .always
        searchTextfield.returnKeyType = .search
        searchTextfield.clearButtonMode = .whileEditing
        searchTextfield.delegate = self
        searchTextfield.backgroundColor = UIColor.white
        searchTextfield.layer.cornerRadius = 17
        searchTextfield.clipsToBounds = true
        searchTextfield.font = UIFont.systemFont(ofSize: 14)
        searchTextfield.textColor = kSetRGBColor(r: 96, g: 96, b: 96)
        let attrString = NSMutableAttributedString.init(string: "输入手机号搜索")
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 96)], range: NSMakeRange(0, "输入手机号搜索".count))
        searchTextfield.attributedPlaceholder = attrString
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 12, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "Shape")
        view.addSubview(leftImage)
        searchTextfield.leftView = view
        searchTextfield.centerX = backBtnCenterY
        navigationBarView.addSubview(searchTextfield)
        
        searchTextfield.snp.makeConstraints { (ls) in
            ls.left.equalTo(backBtn.snp.right).offset(8)
            ls.right.equalToSuperview().offset(-30)
            ls.centerY.equalTo(backBtnCenterY)
            ls.height.equalTo(34)
        }
        
        numLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: 40))
        numLabel.textAlignment = .center
        numLabel.textColor = UIColor.white
        numLabel.font = UIFont.systemFont(ofSize: 12)
        numLabel.backgroundColor = kSetRGBColor(r: 247, g: 56, b: 90)
        numLabel.text = "团队人数：0位"
        self.view.addSubview(numLabel)
        numLabel.snp.makeConstraints { (ls) in
            ls.left.bottom.right.equalToSuperview()
            ls.height.equalTo(40)
        }
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: viewHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-viewHeight), style: .plain, vc: self)
        mainTableView.register(UINib(nibName: "LNShowMyTeamCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        self.automaticallyAdjustsScrollViewInsets = false
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.backgroundColor = kGaryColor(num: 245)
        self.view.addSubview(mainTableView)
        
        mainTableView.snp.makeConstraints { (ls) in
            ls.left.right.equalToSuperview()
            ls.top.equalTo(navigationBarView.snp.bottom)
            ls.bottom.equalTo(numLabel.snp.top)
        }
//        rightBtn1.setImage(UIImage.init(named: "more_icon"), for: .normal)
//        
//        //        气泡
//        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: ["直属粉丝","推荐粉丝","团队粉丝"], icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
//        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
//        showView.delegate = self
    }
    
//    override func rightAction(sender: UIButton) {
//        showView.presentView(sender)
//    }
    @objc func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    
    override func refreshFooterAction() {
        currentPage += 1
        requestData()
    }
    override func requestData() {
        let request = SKRequest.init()
//        if searchLevel.count > 0 {
//            request.setParam(searchLevel as NSObject, forKey: "level")
//        }
        request.setParam("1" as NSObject, forKey: "level")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        if searchTextfield.text != "" {
            request.setParam(searchTextfield.text! as NSObject, forKey: "phone")
        }
        if inviter_id != "" {
            request.setParam(inviter_id as NSObject, forKey: "inviter_id")
        }
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kFriends) { (response) in
            if !(response?.success)! {
                return
            }
            kDeBugPrint(item: response?.data)
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                weakSelf?.numLabel.text = "团队人数：" + JSON((response?.data)!)["data"]["meta"]["total"].stringValue + "位"
                if datas.count>=0 {
                    let pages = JSON((response?.data)!)["data"]["meta"]["last_page"].intValue

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
                        weakSelf?.resource.append(LNMyFansModel.setupValues(json: datas[index]))
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

extension LNTeamDetailViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resource.count == 0 {
            self.mainTableView.addSubview(emptyView)
        }else{
            emptyView.removeFromSuperview()
        }
        return resource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNShowMyTeamCell
//        if resource[indexPath.row].freinds_count > 0{
//            cell.accessoryType = .disclosureIndicator
//        }
        cell.selectionStyle = .none
        cell.model = resource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.xiaji == "2" {
            return
        }
        if resource[indexPath.row].freinds_count > 0{
//            inviter_id = resource[indexPath.row].inviter_id
//            refreshHeaderAction()
            let vc = LNTeamDetailViewController()
            vc.inviter_id = resource[indexPath.row].id
            vc.xiaji = "2"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LNTeamDetailViewController:MenuViewControllerDelegate{
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
        switch tag {
        case 0:
            searchLevel = "1"
        case 1:
            searchLevel = "2"
        default:
            searchLevel = "4"
        }
        refreshHeaderAction()
    }
}
extension LNTeamDetailViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentPage = 1
        requestData()
        textField.resignFirstResponder()
        return true
    }
}
