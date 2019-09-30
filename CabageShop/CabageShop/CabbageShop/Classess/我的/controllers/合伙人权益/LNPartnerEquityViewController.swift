//
//  LNPartnerEquityViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/1.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNPartnerEquityViewController: LNBaseViewController {

    let identyfierTable1  = "identyfierTable1"

    var resoruce = [LNPartnerModel]()
    var resoruce2 = [LNTaskModel]()
    var headView = UIView()
    var selectModel : LNPartnerModel?
    
    //    当前选择的下标
    fileprivate var currentIndex = 0
    //    下划线
    fileprivate var underLine = UIView()

    var model = LNMemberModel()    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configSubViews() {
        
        navigationTitle = "会员等级"
        titleLabel.textColor = UIColor.white
        navigaView.backgroundColor = UIColor.clear
        
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: navHeight+50, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight-50), style: .plain, vc: self)
        
        mainTableView.register(UINib(nibName: "LNNewPartnerCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        self.automaticallyAdjustsScrollViewInsets = false
        
        mainTableView.tableHeaderView?.isHidden = true
        mainTableView.backgroundColor = UIColor.clear
        
        mainTableView.separatorStyle = .none
        self.view.addSubview(mainTableView)
        btnTitle = "FAQ"
        
        let bgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH+80, height: kSCREEN_HEIGHT+100))
        bgView.image = getNavigationIMGVertical(NSInteger(self.view!.height+100), fromColor: kSetRGBColor(r: 255, g: 135, b: 82), toColor: kSetRGBColor(r: 255, g: 82, b: 84))
        bgView.contentMode = .scaleToFill
        self.view.insertSubview(bgView, at: 0)
    }
    
    override func addHeaderRefresh() {
        
    }
    
    func setHeadView() {
        if resoruce.count == 0 {
            return
        }
        headView.removeFromSuperview()
        headView = UIView.init(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: 50))
        headView.backgroundColor = UIColor.clear
        
        for index in 0..<resoruce.count {
            let selectBtn = UIButton.init(frame: CGRect(x: kSCREEN_WIDTH/CGFloat(resoruce.count)*CGFloat(index), y: 0, width: kSCREEN_WIDTH/CGFloat(resoruce.count), height: 50))
            selectBtn.setTitle(resoruce[index].name, for: .normal)
            selectBtn.addTarget(self, action: #selector(goodAtProject(sender:)), for: .touchUpInside)
            selectBtn.tag = 130+index
            selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            selectBtn.setTitleColor(UIColor.white, for: .normal)
            headView.addSubview(selectBtn)
        }
        
        let selectButton = headView.viewWithTag(130+currentIndex) as! UIButton
        underLine = UIView.init(frame: CGRect(x: 0, y: 40, width: getLabWidth(labelStr: resoruce[currentIndex].name, font: UIFont.systemFont(ofSize: 12), height: 1) - 5, height: 2))
        underLine.center.x = selectButton.center.x
        
        underLine.backgroundColor = kGaryColor(num: 255)
        underLine.layer.cornerRadius = 1
        underLine.clipsToBounds = true
        headView.addSubview(underLine)
        
        self.view.addSubview(headView)
        
        selectModel = resoruce[currentIndex]
        mainTableView.reloadData()
    }
    
    
    //MARK:   顶部选择栏选择事件
    @objc func goodAtProject(sender:UIButton) {
        
        let lastButton = self.view.viewWithTag(currentIndex+130) as! UIButton
        
        if lastButton == sender {
            return
        }
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.underLine.bounds.size.width = getLabWidth(labelStr: (sender.titleLabel?.text)!, font: UIFont.systemFont(ofSize: 12), height: 2)-5
            
            weakSelf?.underLine.center = CGPoint(x:  sender.center.x, y:  (weakSelf?.underLine.center.y)!)
            
        })
        currentIndex = sender.tag - 130

        UIView.performWithoutAnimation {
            self.selectModel = resoruce[currentIndex]
            self.mainTableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        }
    }

    
    override func refreshHeaderAction() {
        requestData()
    }
    
    override func requestData() {
        let request = SKRequest.init()
        weak var weakSelf = self
        request.setParam("level" as NSObject, forKey: "orderBy")
        request.setParam("asc" as NSObject, forKey: "sortedBy")
        request.setParam("status:1" as NSObject, forKey: "search")
        request.callGET(withUrl: LNUrls().kUserLevel) { (response) in
            
            DispatchQueue.main.async {
                
                if !(response?.success)! {
                    return
                }
                
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                weakSelf?.resoruce.removeAll()
                for index in 0..<datas.count {
                    if datas[index]["level"].stringValue == weakSelf?.model.level.level {
                        weakSelf?.currentIndex = datas[index]["level"].intValue-1
                    }
                    weakSelf?.resoruce.append(LNPartnerModel.setupValues(json: datas[index]))
                }
                weakSelf?.setHeadView()
            }
        }
    }
    
    
    override func rightAction(sender: UIButton) {
        self.navigationController?.pushViewController(LNPartnerDetailViewController(), animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        navigaView.backgroundColor = kSetRGBAColor(r: 240, g: 137, b: 93, a: scrollView.contentOffset.y/navHeight)
    }
    
}

extension LNPartnerEquityViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNNewPartnerCell
        if selectModel != nil {
            selectModel!.memberModel = model
            cell.model = selectModel!
        }
        cell.selectionStyle = .none
        return cell

    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
