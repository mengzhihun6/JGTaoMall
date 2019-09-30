//
//  LNMiaoshaViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/15.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNMiaoshaViewController: LNBaseViewController {

    //    顶部选择栏
    fileprivate var topView = LNTopScrollView3()

    //    数据源
    fileprivate var resource = [LNMiaoshaModel]()
    var GoodsInformationModel = [SZYGoodsInformationModel]() //商品信息

    fileprivate var selectIndex1 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFooterRefresh()
        addImageWhenEmpty()
        changeStyle()
        
        if self.navigationController?.childViewControllers.count == 1 {
            backBtn.setImage(nil, for: .normal)
            backBtn.isEnabled = false
        }

    }

    
    override func configSubViews() {
        navigaView.backgroundColor = UIColor.clear
        //        navigaView.isHid-*den = true
        let titleMark = UIButton.init(frame: CGRect.zero)
//        titleMark.setImage(UIImage.init(named: "miaosha"), for: .normal)
        titleMark.backgroundColor = UIColor.clear
        titleMark.setTitle("限时秒杀", for: .normal)
        titleMark.setTitleColor(UIColor.black, for: .normal)
        titleMark.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        navigaView.addSubview(titleMark)
        
        var backBtnCenterY = navigaView.centerY+10
        
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navigaView.centerY+20
        }
        titleMark.snp.makeConstraints { (ls) in
            ls.centerX.equalToSuperview()
            ls.width.equalTo(100)
            ls.height.equalTo(50)
            ls.centerY.equalTo(backBtnCenterY)
        }
        
        var height:CGFloat = 115
        if kSCREEN_HEIGHT>800 {
            height += 24
        }
        let headImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: height))
//        headImage.image = getNavigationIMGVertical(NSInteger(headImage.height), fromColor: kGaryColor(num: 83), toColor: kGaryColor(num: 27))
        headImage.backgroundColor = UIColor.white
        headImage.isUserInteractionEnabled = true
        topView = LNTopScrollView3.init(frame: CGRect(x: 0, y: height-43-8, width: kSCREEN_WIDTH, height: 58))
        setTopView()
        weak var weakSelf = self
        topView.callBackBlock { (index, title) in
            weakSelf?.selectIndex1 = index+1
            weakSelf?.refreshHeaderAction()
        }
        headImage.addSubview(topView)
        self.view.insertSubview(headImage, at: 0)
        
        mainTableView = getTableView(frame: CGRect(x: 0, y: topView.height+navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-topView.height-navHeight), style: .plain, vc: self)
        mainTableView.register(UINib.init(nibName: "LNMiaoshaCell", bundle: nil), forCellReuseIdentifier: identyfierTable)
        mainTableView.tag = 100
        self.view.addSubview(mainTableView)
    }
    
    func setTopView() {
        var selectIndex = 0
        
        let dateFamater = DateFormatter.init()
        dateFamater.dateFormat = "HH"
        let time = Int(dateFamater.string(from: Date.init()))
        
//        判断当前时间属于哪一个阶段
        if time! >= 0 && time! < 10 {
            selectIndex = 5
        }
        
        if time! >= 10 && time! < 12 {
            selectIndex = 6
        }
        
        if time! >= 12 && time! < 15 {
            selectIndex = 7
        }
        
        if time! >= 15 && time! < 20 {
            selectIndex = 8
        }
        
        if time! >= 20 {
            selectIndex = 9
        }
        selectIndex1 = selectIndex+1
        topView.setTopView(titles: ["00:00","10:00","12:00","15:00","20:00","00:00","10:00","12:00","15:00","20:00","00:00","10:00","12:00","15:00","20:00"], selectIndex: selectIndex)
        
        topView.setSelectIndex(index: selectIndex, animation: true)
        topView.backgroundColor = kGaryColor(num: 90)
        
    }
    
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func refreshFooterAction() {
        currentPage = currentPage+1
        requestData()
    }
    

    
    override func requestData() {
        let request = SKRequest.init()
        request.setParam("hour_type:"+String(selectIndex1) as NSObject, forKey: "search")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: LNUrls().kKuaiqiang) { (response) in
            kDeBugPrint(item: response?.data)
            LQLoadingView().SVPHide()
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentPage == 1 {
//                        weakSelf?.resource.removeAll()
                        weakSelf?.GoodsInformationModel.removeAll()
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
//                        weakSelf?.resource.append(LNMiaoshaModel.setupValues(json: datas[index]))
                        weakSelf?.GoodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: datas[index]))
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
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 247 * kSCREEN_SCALE, height: 123 * kSCREEN_SCALE))
//        imageView.image = UIImage.init(named: "collect_empty_icon")
        imageView.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 200 * kSCREEN_SCALE)
        emptyView.addSubview(imageView)
        
        let label1 = UILabel.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 18))
        label1.textAlignment = .center
        label1.textColor = kGaryColor(num: 143)
        label1.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY-20)
        label1.font = kFont28
        label1.numberOfLines = 2
//        label1.text = "“暂无秒杀商品，先随便看看吧~~”"
        emptyView.addSubview(label1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.navigationController?.childViewControllers.count)! == 1 {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

//tableView代理
extension LNMiaoshaViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if resource.count == 0 {
//            self.mainTableView.addSubview(emptyView)
//        }else{
//            emptyView.removeFromSuperview()
//        }
//        return resource.count
        if GoodsInformationModel.count == 0 {
            self.mainTableView.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
        return GoodsInformationModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identyfierTable, for: indexPath) as! LNMiaoshaCell
//        cell.model = resource[indexPath.row]
        cell.model1 = GoodsInformationModel[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVc = SZYGoodsViewController()
        detailVc.coupone_type = "1"
//        detailVc.good_item_id = resource[indexPath.row].itemid
        detailVc.good_item_id = GoodsInformationModel[indexPath.row].itemid
        detailVc.goodsUrl = GoodsInformationModel[indexPath.row].pic_url
        detailVc.GoodsInformationModel = GoodsInformationModel[indexPath.row]
        navigationController?.pushViewController(detailVc, animated: true)
    }
}
