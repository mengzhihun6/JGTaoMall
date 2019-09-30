//
//  LNShowMyTeamViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/31.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNShowMyTeamViewController: LNBaseViewController {

    @IBOutlet weak var top_space: NSLayoutConstraint!
    
    //气泡
    fileprivate var showView = ArrowheadMenu()
    
    
    @IBOutlet weak var headHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchbar: UITextField!
    @IBOutlet weak var fansCount: UILabel!
    @IBOutlet weak var inviteCode: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var kindCount: UILabel!
    
    @IBOutlet weak var selectBtn1: UIButton!
    @IBOutlet weak var selectBtn2: UIButton!
    @IBOutlet weak var selectBtn3: UIButton!
    @IBOutlet weak var underLine: UIView!

    @IBOutlet weak var chooseBtn1: UIButton!
    @IBOutlet weak var chooseBtn2: UIButton!
    @IBOutlet weak var chooseBtn3: UIButton!
    
    
    //    数据源
    fileprivate var resource = [LNMyFansModel]()
    
    fileprivate var inviter_id = String()
    fileprivate var searchLevel = "1"
    
    fileprivate var selectIndex = NSInteger()
    fileprivate var selectIndex2 = NSInteger()

    var inviteCodeStr = String()
    
    @IBOutlet weak var selectView: UIView!
    //    顶部选择
    fileprivate var topView = LNTopSelectView()

    @IBAction func _back(_ sender: Any) {
//        if self.tabBarController?.presentingViewController != nil {
//            self.tabBarController?.dismiss(animated: true, completion: nil)
//        }else{
//            self.tabBarController?.navigationController?.popViewController(animated: true)
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.clipsToBounds = true
        searchbar.cornerRadius = searchbar.height/2
        searchbar.delegate  = self
        addImageWhenEmpty()
        searchbar.backgroundColor = kSetRGBColor(r: 255, g: 123, b: 115)
        inviteCode.text = "我的邀请码："+inviteCodeStr
        
        let attrString = NSMutableAttributedString.init(string: "搜索用户名")
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 255)], range: NSMakeRange(0, "搜索用户名".count))
        let smileImage = UIImage(named: "search_路径 269")
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = smileImage
        textAttachment.bounds = CGRect(x: 0, y: -4, width: 22, height: 22)
        let ss = NSAttributedString.init(attachment: textAttachment)
//        attrString.insert(ss, at: 0)
        
        searchbar.attributedPlaceholder = attrString;

        addFooterRefresh()
    }
    
    override func configSubViews() {
        
        top_space.constant = 16
        
        headHeight.constant = 204-64+navHeight
        bottomView.backgroundColor = kGaryColor(num: 245)
        kindCount.isHidden = true
        navigaView.isHidden = true
        navigationTitle = "我的团队"
        titleLabel.textColor = UIColor.white
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight+52, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight-52), style: .plain, vc: self)
        
        mainTableView.register(UINib(nibName: "LNShowMyTeamCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 0.001))
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.backgroundColor = kGaryColor(num: 245)
        
        self.view.addSubview(mainTableView)
        
        mainTableView.snp.makeConstraints { (ls) in
            ls.top.equalTo(bottomView.snp.bottom)
//            ls.bottom.equalTo(kindCount.snp.top)
            ls.left.right.bottom.equalToSuperview()
        }
                
        //        气泡
        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: ["直属粉丝","推荐粉丝","团队粉丝"], icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        showView.delegate = self
        searchbar.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        searchbar.backgroundColor = kSetRGBColor(r: 255, g: 186, b: 183)
        
        
        mainTableArr = NSMutableArray.init(array: ["直属粉丝",
                                                   "团队粉丝",
                                                   "推荐粉丝"])
        topView = LNTopSelectView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 50))
        topView.theFont = kFont34
        topView.setTopView(titles: mainTableArr as! [String], selectIndex: 0)
        topView.setSelectColor(color: kMainColor1())
        weak var weakSelf = self
        topView.callBackBlock { (index) in
            DispatchQueue.main.async(execute: { () -> Void in
                weakSelf?.selectIndex = Int(index)!
                kDeBugPrint(item: index)
                switch index {
                case "0":
                    weakSelf?.searchLevel = "1"
                case "1":
                    weakSelf?.searchLevel = "4"
                default:
                    weakSelf?.searchLevel = "2"
                    break
                }
                weakSelf?.refreshHeaderAction()
            })
        }
        selectView.addSubview(topView)

    }
    @objc func textDidChanged() {
        if (searchbar.text?.count)! == 0 {
            refreshHeaderAction()
        }        
    }
    
    override func rightAction(sender: UIButton) {
        showView.presentView(sender)
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
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        if inviter_id.count > 0 {
            request.setParam(inviter_id as NSObject, forKey: "inviter_id")
        }
        if searchLevel.count > 0 {
            request.setParam(searchLevel as NSObject, forKey: "level")
        }
        if (self.searchbar.text?.count)!>0 {
            request.setParam(self.searchbar.text! as NSObject, forKey: "phone")
        }
        LQLoadingView().SVPwillShowAndHideNoText()

        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kFriends) { (response) in
            DispatchQueue.main.async {
                LQLoadingView().SVPHide()

                if !(response?.success)! {
                    return
                }

                if weakSelf?.mainTableView.mj_footer != nil {
                    weakSelf?.mainTableView.mj_footer.endRefreshingWithNoMoreData()
                }
                if (weakSelf?.mainTableView.mj_header.isRefreshing)! {
                    weakSelf?.mainTableView.mj_header.endRefreshing()
                }
                
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
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
                    weakSelf?.fansCount.text = String((weakSelf?.resource.count)!)
                    var kind = ""
                    if weakSelf?.searchLevel == "1" {
                        kind = "直属粉丝:"
                    } else if weakSelf?.searchLevel == "4" {
                        kind = "团队粉丝:"
                    }else  if weakSelf?.searchLevel == "2"{
                        kind = "推荐粉丝:"
                    }
                    weakSelf?.kindCount.text = kind+String((weakSelf?.resource.count)!)
                }
//                if weakSelf?.lastSender != nil {
//                    weakSelf?.underLine.centerX = (weakSelf?.lastSender!.centerX)!
//                }
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

    var lastSender : UIButton?
    
    @IBAction func selectAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            sender.isSelected = true
            UIView.animate(withDuration: 0.3) {
                self.underLine.centerX = sender.centerX
                if sender == self.selectBtn1 {
                    self.selectBtn2.isSelected = false
                    self.selectBtn3.isSelected = false
                    self.searchLevel = "1"
                }else if sender == self.selectBtn2 {
                    self.selectBtn1.isSelected = false
                    self.selectBtn3.isSelected = false
                    self.searchLevel = "4"
                }else{
                    self.selectBtn2.isSelected = false
                    self.selectBtn1.isSelected = false
                    self.searchLevel = "2"
                }
            }
            self.refreshHeaderAction()
            self.lastSender = sender
            self.selectIndex = sender.tag - 10
        }
    }
    
    
    @IBAction func chooseAction(_ sender: UIButton) {
   
    
    }
    
}

extension LNShowMyTeamViewController : UITableViewDelegate,UITableViewDataSource {
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
        if resource[indexPath.row].freinds_count > 0{
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.accessoryType = .none
        }
        cell.model = resource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if resource[indexPath.row].freinds_count > 0{
             let vc = LNTeamDetailViewController()
            vc.inviter_id = resource[indexPath.row].id
            vc.userName = resource[indexPath.row].nickname
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LNShowMyTeamViewController:MenuViewControllerDelegate{
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {

        switch tag {
        case 0:
            searchLevel = "1"
        case 1:
            searchLevel = "4"
        default:
            searchLevel = "2"
        }
        refreshHeaderAction()
    }
}
extension LNShowMyTeamViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        requestData()
        return true
    }
    
}
