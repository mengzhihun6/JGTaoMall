 //
//  LNMainPageViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/28.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON
import MJRefresh


class LNMainPageViewController: LNBaseViewController {

//    顶部导航栏
    fileprivate var navigationView:UIView!
    //    顶部选择栏
    fileprivate var topView = LNTopScrollView()
    fileprivate var topBGView = UIView()
    //    点击更多之后headView滑动的高度
    fileprivate var currentHeight = CGFloat()

    //    当前选择的下标
    fileprivate var currentIndex = 0

    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = 269
    //    数据源
    fileprivate var resource = [LNYHQListModel]()
    //    推荐数据请求参数
    fileprivate var params = [String:String]()
    fileprivate var currentType = "1"
    
    fileprivate var banners = [LNBannersModel]()
    
    fileprivate var headCell = LNMainHeadCell()
    fileprivate var centerView : LNMainCenterReusableView?

    fileprivate var selectSort_id = String()
    
    fileprivate var select_type = "id"
    fileprivate var sortedBy = "desc"

    let identyfierTable1  = "identyfierTable1"

    let topOptions = ["全部","食品","母婴","女孩","彩妆","洗护","内衣","百货","家电","家居"]

    let offsetY = 548
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()
        requestTopSelectList()
    }
    
    override func addHeaderRefresh() {
        weak var weakSelf = self
        mainCollectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            weakSelf?.refreshHeaderAction()
        })
    }
    
    ///下拉刷新事件
    override func refreshHeaderAction() {
        currentPage = 1
        requestData()
    }
    
    
    override func addFooterRefresh() {
        weak var weakSelf = self
        mainCollectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            weakSelf?.refreshFooterAction()
        })
    }
    
    override func refreshFooterAction() {
        currentPage = currentPage+1
        requestData()
    }

    override func configSubViews() {
        
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: CGFloat(navHeight)+30, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - CGFloat(navHeight) - 44), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainHeadCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)

        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        addAllOptionView()
        
        navigationView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: navHeight+32))
        let bgImage = UIImageView.init(frame: navigationView.bounds)
        bgImage.image = UIImage.init(named: "蒙版组 1")
        navigationView.addSubview(bgImage)
        
        
        topView = LNTopScrollView.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: 30))
//        topView.setTopView(titles: topOptions, selectIndex: currentIndex)
        
        weak var weakSelf = self
        topView.callBackBlock { (index,model) in
            if index == 10086 {
                if weakSelf?.BGView.alpha == 0 {
                    weakSelf?.showAllOptionsView()
                }else{
                    weakSelf?.hiddenViews()
                }
            }else{
                
                if model.cat.count == 0 {
                    weakSelf?.currentIndex = index
                    weakSelf?.selectSort_id = ""
                    weakSelf?.refreshHeaderAction()
                }else{
                    weakSelf?.currentIndex = index
                    weakSelf?.selectSort_id = model.cat
                    weakSelf?.refreshHeaderAction()
                }
                
                DispatchQueue.main.async {
                    weakSelf?.mainCollectionView?.setContentOffset(CGPoint(x: 0, y: (weakSelf?.offsetY)!), animated: true)
                }

            }
        }
        
        topView.backgroundColor = UIColor.clear
        navigationView.addSubview(topView)

        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (ls) in
            ls.top.left.right.equalToSuperview()
            ls.height.equalTo(navHeight+35)
        }
        
        topView.snp.makeConstraints { (ls) in
            ls.left.right.equalToSuperview()
            ls.bottom.equalToSuperview().offset(-5)
            ls.height.equalTo(30)
        }
        
        let searchButton = UIButton.init()
        searchButton.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton.layer.cornerRadius = 16
        searchButton.setImage(UIImage.init(named: "路径 268"), for: .normal)
        searchButton.setTitle("搜索淘宝优惠券", for: .normal)
        if #available(iOS 11.0, *) {
            searchButton.contentHorizontalAlignment = .leading
        } else {
            // Fallback on earlier versions
        }
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        searchButton.addTarget(self, action: #selector(pushToSearch), for: .touchUpInside)
        searchButton.backgroundColor = kSetRGBAColor(r: 245, g: 93, b: 75, a: 0.75)
        navigationView.addSubview(searchButton)
        
        let noticeButton = UIButton.init()
        noticeButton.setImage(UIImage.init(named: "路径 267"), for: .normal)
        noticeButton.addTarget(self, action: #selector(pushToMessage), for: .touchUpInside)
        navigationView.addSubview(noticeButton)
        
        noticeButton.snp.makeConstraints { (ls) in
            ls.right.equalToSuperview()
            ls.width.height.equalTo(35)
            ls.bottom.equalToSuperview().offset(-34)
        }
        
        searchButton.snp.makeConstraints { (ls) in
            ls.left.equalToSuperview().offset(16)
            ls.right.equalTo(noticeButton.snp.left).offset(-6)
            ls.height.equalTo(33)
            ls.centerY.equalTo(noticeButton)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            weakSelf?.mainCollectionView!.setContentOffset(CGPoint(x: 0, y: 1), animated: true)
        }

    }
    
    
    fileprivate func requestTopSelectList() {
        var request = SKRequest.init()
        request.setParam("type:1;tag:banner;status:1" as NSObject, forKey: "search")
        request.setParam("sort" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kBanner) { (response) in
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                weakSelf?.banners.removeAll()
                for index in 0..<datas.count{
                    weakSelf?.banners.append(LNBannersModel.setupValues(json: datas[index]))
                }
                weakSelf?.headCell.buildUrlData(models: (weakSelf?.banners)!)
            }
        }
        
        request = SKRequest.init()
        request.setParam("type:1" as NSObject, forKey: "search")
        request.setParam("id" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.callGET(withUrl: LNUrls().kCategory) { (response) in
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                var listModels = [LNTopListModel]()
                for index in 0..<datas.count{
                    listModels.append(LNTopListModel.setupValues(json: datas[index]))
                }
                //        根据选择栏的数量确定位置
                let count = listModels.count
                let kHeight:CGFloat = viewHeight
                let line = CGFloat((count)%4)
                
                if line == 0 {
                    weakSelf?.currentHeight = CGFloat((count)/4)*kHeight + CGFloat(count/4)+(CGFloat((count)/4)+1)*10+15
                }else{
                    weakSelf?.currentHeight = CGFloat((count)/4+1)*kHeight+(CGFloat((count)/4)+1)*10+15
                }

                weakSelf?.topView.setTopView(titles: listModels, selectIndex: (weakSelf?.currentIndex)!)
               weakSelf?.allOptionsView.setupValues(titles: listModels, images: [], selectIndex: (weakSelf?.currentIndex)!, isUrl: false)

                if listModels.count>0 {
                    weakSelf?.topView.setSelectIndex(index: (weakSelf?.currentIndex)!, animation: false)
                }
            }
        }

    }
    
    
    override func requestData() {
        let request = SKRequest.init()
        
        weak var weakSelf = self
        if selectSort_id.count>0 {
            request.setParam("cat:"+selectSort_id+";type:1;shop_type:1"as NSObject, forKey: "search")
        }else{
            request.setParam("type:1;shop_type:1"as NSObject, forKey: "search")
        }
        
        request.setParam(select_type as NSObject, forKey: "orderBy")
        request.setParam(sortedBy as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")

        request.setParam(String(currentPage) as NSObject, forKey: "page")

        LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: LNUrls().kSwhow_coupon) { (response) in
            LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                
                if !(response?.success)! {
                    weakSelf?.mainCollectionView?.mj_footer.endRefreshing()
                    weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                    return
                }

                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                if datas.count>=0 {
                    let pages = JSON((response?.data["data"])!)["meta"]["pagination"]["total_pages"].intValue
                    
                    if weakSelf?.currentPage == 1 {
                        weakSelf?.resource.removeAll()
                        if weakSelf?.currentPage == pages {
                            weakSelf?.mainCollectionView?.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.mainCollectionView?.mj_footer.resetNoMoreData()
                        }
                    }else{
                        if (weakSelf?.currentPage)! >= pages {
                            weakSelf?.mainCollectionView?.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            weakSelf?.mainCollectionView?.mj_footer.endRefreshing()
                        }
                    }
                    
                    for index in 0..<datas.count{
                        let json = datas[index]
                        let model = LNYHQListModel.setupValues(json: json)
                        weakSelf?.resource.append(model)
                    }
                    
                    if (weakSelf?.mainCollectionView?.mj_header.isRefreshing)! {
                        weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                    }
                }else{
                    if weakSelf?.mainCollectionView?.mj_footer != nil {
                        weakSelf?.mainCollectionView?.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                weakSelf?.mainCollectionView?.reloadSections(IndexSet.init(integer: 1))
            }
        }
    }
    
    
//    MARK:顶部点击方法
    
    @objc func pushToMessage() {
        self.navigationController?.pushViewController(LNSystemNoticeViewController(), animated: true)
    }
    
    
    override func setNavigaView() {
        
    }
    
    
    @objc func pushToSearch() {

        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
        search.hidesBottomBarWhenPushed = true
        search.isPresent = true
        let root = LNNavigationController.init(rootViewController: search)
        self.present(root, animated: true, completion: nil)
    }
    
    //    背景，遮布
    var BGView = UIView()
    //    选择视图
    var allOptionsView = LQShowAllOptionsView()
    
    @objc func showChooseCondi(tap:UITapGestureRecognizer) -> Void {
        if tap.view?.alpha == 1 {
            
            topView.setSelectIndex(index:currentIndex, animation: true)
            allOptionsView.hiddenView()
            
            weak var weakSelf = self
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf?.topBGView.alpha = 0
                tap.view?.alpha = 0
            })
        }
    }
    //    显示选择栏，同时更新按钮位置
    func showAllOptionsView() -> Void {
        
        allOptionsView.setSelectIndex(index:currentIndex)
        allOptionsView.showView()
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf?.BGView.alpha = 1
            weakSelf?.topBGView.alpha = 1
            weakSelf?.topBGView.snp.updateConstraints({ (ls) in
                ls.height.equalTo((weakSelf?.currentHeight)!)
            })

        })
    }

    //    视图TagView
    fileprivate func addAllOptionView() {
        //        弹出视图弹出来之后的背景蒙层
        BGView = UIView.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-CGFloat(navHeight)))
        BGView.backgroundColor = kSetRGBAColor(r: 5, g: 5, b: 5, a: 0.5)
        BGView.alpha = 0
        
        let tapGes1 = UITapGestureRecognizer.init(target: self, action: #selector(showChooseCondi(tap:)))
        tapGes1.numberOfTouchesRequired = 1
        BGView.addGestureRecognizer(tapGes1)
        self.view.addSubview(BGView)
        
        topBGView.backgroundColor = UIColor.white
        self.view.addSubview(topBGView)
        
        topBGView.snp.makeConstraints { (ls) in
            ls.height.equalTo(44)
            ls.top.equalTo(navHeight+30)
            ls.left.right.equalToSuperview()
        }
        
        allOptionsView.frame = CGRect(x: 0, y: navHeight+30, width: kSCREEN_WIDTH, height: 44)
        weak var weakSelf = self
        allOptionsView.callBackBlock { (index,model) in
            kDeBugPrint(item: index)
            
            //如果index=10086，则说明点击的不是选项，是更多的图标
            if index != 10086 {

                weakSelf?.selectSort_id = model.cat
                weakSelf?.currentIndex = index
                weakSelf?.topView.setSelectIndex(index:index, animation: true)
                weakSelf?.refreshHeaderAction()
            }
            weakSelf?.hiddenViews()
        }
        
        topBGView.addSubview(allOptionsView)
        topBGView.alpha = 0
        
        allOptionsView.snp.makeConstraints { (ls) in
            ls.height.equalToSuperview()
            ls.left.right.top.equalToSuperview()
        }
        
    }
    
    func hiddenViews() {
        //隐藏选择栏的时候，要更新其他选择栏的按钮位置
        topView.setSelectIndex(index:currentIndex, animation: true)
        allOptionsView.hiddenView()
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.topBGView.alpha = 0
            weakSelf?.BGView.alpha = 0
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.navigationController?.navigationBar.isHidden = true
            weakSelf?.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        kDeBugPrint(item: scrollView.contentOffset.y)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}


extension LNMainPageViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return resource.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            headCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainHeadCell
            weak var weakSelf = self
            headCell.callBackPhoneNum(block: { (index) in
                switch index {
                case 0:
                    weakSelf?.select_type = ""
                    weakSelf?.sortedBy = ""
                case 1:
                    weakSelf?.select_type = "coupon_price"
                    weakSelf?.sortedBy = "desc"
                case 11:
                    weakSelf?.select_type = "coupon_price"
                    weakSelf?.sortedBy = "desc"
                case 2:
                    weakSelf?.select_type = "volume"
                    weakSelf?.sortedBy = "desc"
                case 21:
                    weakSelf?.select_type = "volume"
                    weakSelf?.sortedBy = "desc"
                case 3:
                    weakSelf?.select_type = "price"
                    weakSelf?.sortedBy = "asc"
                case 4:
                    weakSelf?.select_type = "price"
                    weakSelf?.sortedBy = "asc"
                default:
                    break
                }
                
                DispatchQueue.main.async {
                    weakSelf?.mainCollectionView?.setContentOffset(CGPoint(x: 0, y: weakSelf!.offsetY), animated: true)
                    weakSelf?.refreshHeaderAction()
                }
            })

            return headCell
        }else{
            let cell:LNMainFootCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! LNMainFootCell
            cell.cornerRadius = 5
            cell.model2 = resource[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            return
        }
        let detailVc = SZYGoodsViewController()
        if Defaults[kIsSuper_VIP] == "true" {
//            detailVc.isSuper_VIP = true
        }
        detailVc.good_item_id = resource[indexPath.row].item_id
        detailVc.coupone_type = resource[indexPath.row].type
        navigationController?.pushViewController(detailVc, animated: true)
    }
    
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: kSCREEN_WIDTH, height: 595)
        }else{
            return CGSize(width: (kSCREEN_WIDTH-kSpace-22)/2, height: kHeight)
        }
        
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 11, bottom: 10, right: 11)
    }
    
}
