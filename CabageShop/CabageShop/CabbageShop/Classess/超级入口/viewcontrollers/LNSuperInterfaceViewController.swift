//
//  LNSuperInterfaceViewController.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/13.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class LNSuperInterfaceViewController: LNBaseViewController{

    //    collectionView
    @objc public var mainCollectionView:UICollectionView?
    @objc public var selectIndex = NSInteger()
    
    let identyfierTable1  = "identyfierTable1"
    let identyfierTable2  = "identyfierTable2"
    let identyfierTable3  = "identyfierTable3"

    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0.5
    //    cell的高度
    fileprivate let kHeight:CGFloat = 100
    
    var headView = TKShowVideoReusableView()

    fileprivate var selectIndexC = 0
    fileprivate var selectIndex2 = 0
    fileprivate var selectIndexSection = 0

    
    fileprivate var resource = [LNSuperMainModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView?.alwaysBounceVertical = true
        self.navigaView.isHidden = true
        
    }

    
    override func requestData() {
        let request = SKRequest.init()
        
        request.setParam("parent_id:0;status:1;type:1" as NSObject, forKey: "search")
        request.setParam("sort" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")

        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText1()
        request.callGET(withUrl: LNUrls().kSuperInterface) { (response) in
            
            DispatchQueue.main.async {
                LQLoadingView().SVPHide()
                weakSelf?.mainTableView.mj_header.endRefreshing()
                if !(response?.success)! {
                    return
                }
                weakSelf?.resource.removeAll()
                let data = JSON((response?.data)!)["data"]["data"].arrayValue
                for index in 0..<data.count {
                    let model = LNSuperMainModel.setupValues(json: data[index])
                    weakSelf?.resource.append(model)
                }
                weakSelf?.mainTableView.reloadData()
            }
        }
    }
    
    override func configSubViews() {
        
        let headIMage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 203))
        headIMage.image = UIImage.init(named: "super_head_back")
        headIMage.isUserInteractionEnabled = true
        
        let searchBtn = UIButton.init(frame: CGRect(x: 20, y: headIMage.height-55, width: kSCREEN_WIDTH-20*2, height: 37))
        searchBtn.setTitle("搜索商品名称或宝贝标题", for: .normal)
        searchBtn.setImage(UIImage.init(named: "search_icon_default"), for: .normal)
        searchBtn.backgroundColor = kGaryColor(num: 255)
        searchBtn.setTitleColor(kGaryColor(num: 181), for: .normal)
        searchBtn.cornerRadius = searchBtn.height/2
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.layoutButton(with: .left, imageTitleSpace: 5)
        searchBtn.clipsToBounds = true
        searchBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        headIMage.addSubview(searchBtn)
        
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-kStatusBarH-10), style: .grouped, vc: self)
        
        mainTableView.register(UINib(nibName: "LNSuperKindCell1", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.register(UINib(nibName: "LNSuperKindCell2", bundle: nil), forCellReuseIdentifier: identyfierTable1)
        mainTableView.backgroundColor = kGaryColor(num: 245)
        self.view.addSubview(mainTableView)
        mainTableView.separatorColor = kGaryColor(num: 255)
        mainTableView.tableHeaderView = headIMage
        
        self.view.isUserInteractionEnabled = true
    }
    override func backAction(sender: UIButton) {
        self.navigationController?.pushViewController(LNSuperKindViewController(), animated: true)
    }
    
    
    ///下拉刷新事件
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }

}

extension LNSuperInterfaceViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return resource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if resource[indexPath.section].children.count>0 
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable1, for: indexPath) as! LNSuperKindCell2
            cell.selectionStyle = .none
            if indexPath.section == 2 {
                cell.setTopViews(model: resource[indexPath.section], selecIndex: selectIndexC, index: indexPath.section)
            }else{
                cell.setTopViews(model: resource[indexPath.section], selecIndex: selectIndex2, index: indexPath.section)
            }
        
            cell.callBackBlock { (index) in

                if indexPath.section == 2 {
                    self.selectIndexC = index
                }else{
                    self.selectIndex2 = index
                }
                UIView.performWithoutAnimation {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNSuperKindCell1
            cell.selectionStyle = .none
            cell.setValues(model: resource[indexPath.section])
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
        }else{
            return 12
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if resource[indexPath.section].children.count == 0 {
            var lines = resource[indexPath.section].entrance.count/4
            if resource[indexPath.section].entrance.count%4>0{
                lines = lines+1
            }
            let height = 40+(kHeight+kSpace)*CGFloat(lines)
            return  height
        }else{
            var index = selectIndexC
            if indexPath.section == 3 {
                index = selectIndex2
            }
            var lines = resource[indexPath.section].children[index].entrance.count/4
            if resource[indexPath.section].children[index].entrance.count%4>0{
                lines = lines+1
            }
            let height = 40+40+(kHeight+kSpace)*CGFloat(lines)
            return  height
        }
    }
}
