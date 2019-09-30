//
//  LNShowKindViewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/10/29.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import MJRefresh
import DeviceKit

class LNShowKindViewController: LNBaseViewController {
    
    
    fileprivate var isCollect = false
    //    顶部选择栏
    fileprivate var topView = LNTopScrollView2_1()
    //气泡
    fileprivate var showView = ArrowheadMenu()

    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = 275
    
    //    数据源
    fileprivate var resource = [LNYHQModel]()
    
    let identyfierTable1  = "identyfierTable1"
    
    //    推荐数据请求参数
    fileprivate var params = [String:String]()
    fileprivate var currentType = "1"
    
    let topOptions = ["全部","食品","母婴","女孩","彩妆","洗护","内衣","百货","家电","家居"]
    
    fileprivate var selectSort_id = String()

    fileprivate var select_type = String()
    fileprivate var sortedBy = String()
    //    当前选择的下标
    fileprivate var currentIndex = 0

     var tagStr = String()
    //    回调
    typealias swiftBlock = (_ keyword:String) -> Void
    var willClick : swiftBlock? = nil
    @objc func callKeywordBlock(block: @escaping ( _ keyword:String) -> Void ) {
        willClick = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()
        addImageWhenEmpty()
        
        let request = SKRequest.init()
        weak var weakSelf = self
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
                weakSelf?.topView.setTopView(titles: listModels, selectIndex: (weakSelf?.currentIndex)!)
                weakSelf?.topView.changeStyle()
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
//        label1.text = "“正在为您查找，请稍后~~”"
        emptyView.addSubview(label1)
    }
        
    
    override func configSubViews() {
        
        navigationTitle = self.title!
        titleLabel.textColor = UIColor.white
        
        topView = LNTopScrollView2_1.init(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: 40))
        topView.lineColor = kGaryColor(num: 179)
        topView.textColor = kGaryColor(num: 69)
        topView.changeStyle()
        topView.backgroundColor = UIColor.white
        weak var weakSelf = self

        topView.callBackBlock { (index,model) in
            if index == 10086 {
                let touchButton = weakSelf?.topView.viewWithTag(10086)
                weakSelf?.showView.presentView(touchButton!)
            }else{
                weakSelf?.currentIndex = index
                weakSelf?.selectSort_id = model.cat
                weakSelf?.refreshHeaderAction()
            }
        }

        self.view.addSubview(topView)
        
        
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: CGFloat(navHeight)+40, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - CGFloat(navHeight) - 40), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(UINib.init(nibName: "LNShowGoodsHorizontalCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        btnImage = "show_horizontal"

//        气泡
        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: ["综合","销量","券额","佣金","价格升序","价格降序",], icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        showView.delegate = self
    }
    
    
    @objc override func rightAction(sender: UIButton) {
        isCollect = !isCollect
        
        if isCollect {
            btnImage = "show_vertical"
        }else{
            btnImage = "show_horizontal"
        }
        self.navigationItem.rightBarButtonItem?.tintColor = kSetRGBColor(r: 255, g: 255, b: 255)
        mainCollectionView?.reloadData()
    }
    
    override func addHeaderRefresh() {
        mainCollectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.refreshHeaderAction()
        })
    }
    
    ///下拉刷新事件
    override func refreshHeaderAction() {
        mainCollectionView?.mj_header.endRefreshing()
        requestData()
    }
    
    
    override func addFooterRefresh() {
        mainCollectionView?.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            self.refreshFooterAction()
        })
    }
    
    override func refreshFooterAction() {
        currentPage = currentPage+1
        requestData()
    }
    
    override func requestData() {
        let request = SKRequest.init()
        weak var weakSelf = self
        
        LQLoadingView().SVPwillShowAndHideNoText()
        if selectSort_id.count>0 {
            if tagStr.contains("9.9") {
                request.setParam("cat:"+selectSort_id as NSObject, forKey: "search")
                request.setParam("9.9" as NSObject, forKey: "max_price")
            }else{
                request.setParam("cat:"+selectSort_id+";"+tagStr as NSObject, forKey: "search")
            }
        }else{
            if tagStr.contains("9.9") {
                request.setParam("9.9" as NSObject, forKey: "max_price")
            }else{
                request.setParam(tagStr as NSObject, forKey: "search")
            }
        }

        request.setParam("1" as NSObject, forKey: "type")
        if select_type.count>0 {
            request.setParam(select_type as NSObject, forKey: "orderBy")
        }
        if sortedBy.count>0 {
            request.setParam(sortedBy as NSObject, forKey: "sortedBy")
        }
        
        request.setParam("and" as NSObject, forKey: "searchJoin")

        request.callGET(withUrl: LNUrls().kSwhow_coupon) { (response) in
            LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                
                if !(response?.success)! {
                    if !(response?.success)! {
                        weakSelf?.mainCollectionView?.mj_footer.endRefreshing()
                        weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                        return
                    }
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
                        weakSelf?.resource.append(LNYHQModel.setupValues(json: datas[index]))
                    }
                    
                    if (weakSelf?.mainCollectionView?.mj_header.isRefreshing)! {
                        weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                    }
                }else{
                    if weakSelf?.mainCollectionView?.mj_footer != nil {
                        weakSelf?.mainCollectionView?.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                weakSelf?.mainCollectionView?.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}


extension LNShowKindViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if resource.count == 0 {
            self.mainCollectionView?.addSubview(emptyView)
        }else{
            emptyView.removeFromSuperview()
        }
        return resource.count

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCollect {
            let cell:LNMainFootCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainFootCell
            cell.clipsToBounds = true
            cell.model = resource[indexPath.row]
            return cell
        }else{
            let cell:LNShowGoodsHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! LNShowGoodsHorizontalCell
            cell.model = resource[indexPath.row]
            return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
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
        
        if !isCollect {
            return CGSize(width: kSCREEN_WIDTH-16, height: 120)
        }else{
            return CGSize(width: (kSCREEN_WIDTH-kSpace-16)/2, height: kHeight)
        }
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    }
}

extension LNShowKindViewController:MenuViewControllerDelegate{
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
        
        switch tag {
        case 0:
            select_type = ""
            sortedBy = ""
        case 1:
            select_type = "volume"
            sortedBy = "desc"
        case 2:
            select_type = "coupon_price"
            sortedBy = "desc"
        case 3:
            select_type = "commission_rate"
            sortedBy = "desc"
        case 4:
            select_type = "price"
            sortedBy = "asc"
        case 5:
            select_type = "price"
            sortedBy = "desc"
        default:
            break
        }
        refreshHeaderAction()
    }
}
