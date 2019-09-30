//
//  LNOtherListViewController2.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/25.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh


class LNOtherListViewController2: LNBaseViewController {
    
    //气泡
    fileprivate var showView = ArrowheadMenu()
    

    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = 273
    fileprivate var mainCollectionView:UICollectionView?
    //    数据源
    fileprivate var resource = [LNYHQModel]()
    
    fileprivate var header : UICollectionReusableView?
    fileprivate var headView : UIView!
    fileprivate var headImage : UIImageView!
    fileprivate var topView:LNTopScrollView!
    fileprivate let identyfierTableHeader = "identyfierTableHeader"
    fileprivate let identyfierTable1 = "identyfierTable1"
    
    fileprivate var selectSort_id = String()
    //    当前选择的下标
    fileprivate var currentIndex = 0

    var selecType = 1
    var searchtype = "2"
    
    var model = LNNewMainLayoutModel()
    
    weak var superViewController : LNPageViewController?
    
    
    fileprivate var select_type = "id"
    fileprivate var sortedBy = "desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()
    }
    
    override func addHeaderRefresh() {
        mainCollectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.refreshHeaderAction()
        })
    }
    
    ///下拉刷新事件
    override func refreshHeaderAction() {
        currentPage = 1
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
    
    override func configSubViews() {

        navigationTitle = model.name
        changeStyle()

        topView = LNTopScrollView.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: 40))
        topView.textColor = kGaryColor(num: 80)
        topView.rightWidth = 0
        weak var weakSelf = self
        topView.callBackBlock { (index,model) in
            if model.cat.count == 0 {
                weakSelf?.currentIndex = index
                weakSelf?.selectSort_id = ""
                weakSelf?.refreshHeaderAction()
            }else{
                weakSelf?.currentIndex = index
                weakSelf?.selectSort_id = model.cat
                weakSelf?.refreshHeaderAction()
            }
        }
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        headView = UIView.init(frame: CGRect(x: 0, y: navHeight+topView.height, width: kSCREEN_WIDTH, height: 204))
        headImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 204))
        headImage.sd_setImage(with: OCTools.getEfficientAddress(model.list_thumb), placeholderImage: UIImage.init(named: "goodImage_1"))
//        headImage.image = UIImage.init(named: "placeholder_2")
        headImage.contentMode = .scaleToFill
        headView.addSubview(headImage)
        self.view.addSubview(headView)
        
        
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: navHeight+topView.height, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(UINib.init(nibName: "LNShowGoodsHorizontalCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        mainCollectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identyfierTableHeader)
        
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = UIColor.clear
        self.view.backgroundColor = kBGColor()
        requestTopSelectList()
        
        rightBtn1.setImage(UIImage.init(named: "Sizer_black_icon"), for: .normal)
        
        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: ["综合","销量","券额","佣金","价格升序","价格降序"], icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        showView.delegate = self

    }
    
    override func rightAction(sender: UIButton) {
        showView.presentView(sender)
    }
    
    fileprivate func requestTopSelectList() {
        let request = SKRequest.init()
        request.setParam("type:1;parent_id:0;status:1" as NSObject, forKey: "search")
        request.setParam("sort" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kCategory) { (response) in
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                var listModels = [LNTopListModel]()
                
                let model = LNTopListModel()
                model.name = "全部"
                listModels.append(model)
                
                for index in 0..<datas.count{
                    listModels.append(LNTopListModel.setupValues(json: datas[index]))
                }
                weakSelf?.topView.setTopView(titles: listModels, selectIndex: 0)
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func chooseOptions(sender:UIButton)  {
        
        let searchVc = LQSearchResultViewController()
        searchVc.keyword = model.children[sender.tag-10].name
        searchVc.type = "1"
        superViewController?.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    
    override func requestData() {
        let request = SKRequest.init()
        
        weak var weakSelf = self
//        var search = model.params
//        if search.contains("search=") {
//           search = OCTools().replaceEnStr("search=", withCHStr: "", inDateStr: search)
//        }
//        if selectSort_id.count>0 {
//            request.setParam(search+"cat:"+selectSort_id as NSObject, forKey: "search")
//        }else{
//            request.setParam(search as NSObject, forKey: "search")
//        }

        request.setParam(select_type as NSObject, forKey: "orderBy")

        
        let arr = model.params.components(separatedBy: "&")
        for item in arr {
            let strs = item.components(separatedBy: "=")
            if strs.count == 2 {
                if strs[0] == "search" {
                    if selectSort_id.count>0{
                        request.setParam(strs[1]+";cat:"+selectSort_id as NSObject, forKey: strs[0])
                    }else{
                        request.setParam(strs[1] as NSObject, forKey: strs[0])
                    }
                }else{
                    if strs[0] != "orderBy" {
                        request.setParam(strs[1] as NSObject, forKey: strs[0])
                    }
                }
            }
        }
        
        request.setParam(sortedBy as NSObject, forKey: "sortedBy")

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
                        let model = LNYHQModel.setupValues(json: json)
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
                weakSelf?.mainCollectionView?.reloadData()
            }
        }
    }
}


extension LNOtherListViewController2:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return resource.count
        return resource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:LNShowGoodsHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! LNShowGoodsHorizontalCell
        cell.setModel(model: resource[indexPath.row], index: indexPath.row)
        if indexPath.row == 0 {
            let maskPath = UIBezierPath.init(roundedRect: cell.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topRight.rawValue)|UInt8(UIRectCorner.topLeft.rawValue))), cornerRadii: CGSize(width: 10, height: 10))
            
            let maskLayer = CAShapeLayer.init()
            maskLayer.frame = cell.bounds
            maskLayer.path = maskPath.cgPath
            cell.layer.mask = maskLayer
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = resource[indexPath.row].item_id
        detailVc.coupone_type = resource[indexPath.row].type
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: kSCREEN_WIDTH-16, height: 120)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 114, left: 8, bottom: 10, right: 8)
    }
    
}

extension LNOtherListViewController2:MenuViewControllerDelegate{
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
        
        weak var weakSelf = self
        switch tag {
        case 0:
            weakSelf?.select_type = "id"
            weakSelf?.sortedBy = ""
        case 1:
            weakSelf?.sortedBy = "desc"
            weakSelf?.select_type = "volume"
            
        case 2:
            weakSelf?.sortedBy = "desc"
            weakSelf?.select_type = "coupon_price"
        case 3:
            weakSelf?.sortedBy = "desc"
            weakSelf?.select_type = "commission_rate"
        case 4:
            weakSelf?.sortedBy = "desc"
            weakSelf?.select_type = "price"
        case 5:
            weakSelf?.sortedBy = "asc"
            weakSelf?.select_type = "price"
        default:
            break
        }
        
        refreshHeaderAction()
    }
}
