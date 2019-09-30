//
//  SZYModuleViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/2.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class SZYModuleViewController: LNBaseViewController {
    
    var SZYTypeString = ""
    var titleString = ""
    
    var typeInt = 0
    
    
    var goodsInformationModel = [SZYGoodsInformationModel]()  //商品信息
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        requestYopListData()   //导航栏 信息
        addFooterRefresh()
//        addImageWhenEmpty()    //没有数据时显示
        
    }
    override func configSubViews() {
        navigationTitle = titleString
        titleLabel.textColor = UIColor.white
//        navigationBgImage = UIImage.init(named: "Rectangle")
        
        mainTableView = getTableView(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT), style: .plain, vc: self)
        mainTableView.register(UINib.init(nibName: "LNMiaoshaCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tag = 100
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalTo(navigaView.snp.bottom)
        }
    }
    fileprivate var emptyView = UIView()
    //    当数据为空的时候，显示提示
    func addImageWhenEmpty() {
        
        emptyView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 46))
        emptyView.backgroundColor = kBGColor()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 233 * kSCREEN_SCALE, height: 160 * kSCREEN_SCALE))
        imageView.image = UIImage.init(named: "")
        imageView.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 200 * kSCREEN_SCALE)
        emptyView.addSubview(imageView)
        
        let label1 = UILabel.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 18))
        label1.textAlignment = .center
        label1.textColor = kGaryColor(num: 143)
        label1.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY-20)
        label1.font = kFont28
        label1.numberOfLines = 2
        label1.text = "正在为您查找，请稍后~~"
        emptyView.addSubview(label1)
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
        var urlRequest = LNUrls().kSwhow_coupon
        
        if typeInt == 2 {
            urlRequest = LNUrls().kSwhow_coupon + "?\(SZYTypeString)"
        } else {
            request.setParam("id" as NSObject, forKey: "orderBy")
            request.setParam("desc" as NSObject, forKey: "sortedBy")
            if SZYTypeString == "1" {
                request.setParam("ytpe:1;tag:2" as NSObject, forKey: "search")
            } else if SZYTypeString == "2" {
                request.setParam("type:1" as NSObject, forKey: "search")
                request.setParam("9.9" as NSObject, forKey: "max_price")
            }
            request.setParam("and" as NSObject, forKey: "searchJoin")
        }
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        kDeBugPrint(item: "请求参数 \(urlRequest)")
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: urlRequest) { (response) in
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.goodsInformationModel.removeAll()
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
                        weakSelf?.goodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: datas[index]))
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
    
    
    
}
//tableView代理
extension SZYModuleViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if goodsInformationModel.count == 0 {
            self.mainTableView.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
        return goodsInformationModel.count
//        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNMiaoshaCell
        cell.model2 = goodsInformationModel[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVc = SZYGoodsViewController()
        detailVc.coupone_type = "1"
        detailVc.good_item_id = goodsInformationModel[indexPath.row].item_id
        detailVc.goodsUrl = goodsInformationModel[indexPath.row].pic_url
        detailVc.GoodsInformationModel = goodsInformationModel[indexPath.row]
        navigationController?.pushViewController(detailVc, animated: true)
    }
}
