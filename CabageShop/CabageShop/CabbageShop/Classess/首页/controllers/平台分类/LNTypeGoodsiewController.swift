//
//  LNTypeGoodsiewController.swift
//  TaoKeThird
//
//  Created by 付耀辉 on 2018/11/19.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import MJRefresh
import DeviceKit

class LNTypeGoodsiewController: LNBaseViewController {
    //    顶部导航栏
    fileprivate var navigationView:UIView!
    
    //气泡
    fileprivate var showView = ArrowheadMenu()
    
    //    搜索框
    fileprivate var searchTextfield = UITextField()
    @objc var keyword = String()
    //    @objc var searchtype = String()
    @objc var type = String()
    
    fileprivate var isCollect = false
    //    顶部选择栏
    fileprivate var topView = LNTopScrollView2_1()
    
    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = 269
    
    //    数据源
    fileprivate var resource = [LNYHQModel]()
    
    let identyfierTable1  = "identyfierTable1"
    
    fileprivate var currentType = "1"
    var changeBtn = UIButton()
    
    var selecType = 0
    
    fileprivate var selectSort_id = String()
    
    fileprivate var select_type = String()
    fileprivate var sortedBy = String()
    
    //    当前选择的下标
    fileprivate var currentIndex = 0
    
    //    回调
    typealias swiftBlock = (_ keyword:String) -> Void
    var willClick : swiftBlock? = nil
    @objc func callKeywordBlock(block: @escaping ( _ keyword:String) -> Void ) {
        willClick = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestYopListData()
        addFooterRefresh()
        addImageWhenEmpty()
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
    
    
    func getValues(keywords:String) {
        keyword = keywords
    }
    
    override func configSubViews() {
        
        navigationView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: navHeight))
        navigationView.backgroundColor = kMainColor1()
        self.view.addSubview(navigationView)
        
        //    返回按钮
        let backBtn = UIButton()
        backBtn.setImage(UIImage.init(named: "nav_return_white"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        navigationView.addSubview(backBtn)
        
        var backBtnCenterY = navigationView.centerY+10
        
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navigationView.centerY+20
        }
        backBtn.snp.makeConstraints { (ls) in
            ls.left.equalTo(0)
            ls.centerY.equalTo(backBtnCenterY)
            ls.width.equalTo(35)
            ls.height.equalTo(30)
        }
        
        //  更改布局
        changeBtn.setImage(UIImage.init(named: "show_horizontal"), for: .normal)
        changeBtn.addTarget(self, action: #selector(rightAction(sender:)), for: .touchUpInside)
        changeBtn.tintColor = UIColor.white
        navigationView.addSubview(changeBtn)
        
        changeBtn.snp.makeConstraints { (ls) in
            ls.right.equalTo(-5)
            ls.centerY.equalTo(backBtnCenterY)
            ls.width.equalTo(35)
            ls.height.equalTo(30)
        }
        
        searchTextfield.borderStyle = .none
        searchTextfield.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-60, height: 26))
        searchTextfield.placeholder = "输入关键词查券"
        searchTextfield.textColor = UIColor.white
        searchTextfield.leftViewMode = .always
        searchTextfield.returnKeyType = .search
        searchTextfield.clearButtonMode = .whileEditing
        searchTextfield.delegate = self
        searchTextfield.layer.cornerRadius = 17
        searchTextfield.clipsToBounds = true
        searchTextfield.font = UIFont.systemFont(ofSize: 14)
        searchTextfield.textColor = UIColor.white
        searchTextfield.backgroundColor = kSetRGBAColor(r: 245, g: 93, b: 75, a: 0.75)
        searchTextfield.tintColor = UIColor.white
        searchTextfield.text = keyword
        let attrString = NSMutableAttributedString.init(string: "输入关键词查券")
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 251)], range: NSMakeRange(0, "输入关键词查券".count))
        searchTextfield.attributedPlaceholder = attrString;
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 17))
        let leftImage = UIImageView.init(frame: CGRect(x: 12, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "earch_路径 269")
        view.addSubview(leftImage)
        searchTextfield.leftView = view
        searchTextfield.centerX = navigationView.centerX
        navigationView.addSubview(searchTextfield)
        
        searchTextfield.snp.makeConstraints { (ls) in
            ls.left.equalTo(backBtn.snp.right).offset(8)
            ls.right.equalTo(changeBtn.snp.left).offset(-8)
            ls.centerY.equalTo(backBtnCenterY)
            ls.height.equalTo(34)
        }
        
        topView = LNTopScrollView2_1.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: 40))
        topView.backgroundColor = kMainColor1()
        weak var weakSelf = self
        topView.callBackBlock { (index,model ) in
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
        
        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: ["综合","销量","券额","佣金","价格升序","价格降序",], icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        showView.delegate = self
    }
    
    override func setNavigaView() {
        
    }
    
    @objc fileprivate func searchBegin() {
        
        if (searchTextfield.text?.count)! == 0 {
            setToast(str: "请输入关键词")
            
            return
        }
        
        let ressult = LQSearchResultViewController()
        ressult.keyword = searchTextfield.text!
        ressult.type  = type
        self.navigationController?.pushViewController(ressult, animated: true)
    }
    
    
    @objc override func rightAction(sender: UIButton) {
        isCollect = !isCollect
        
        if isCollect {
            changeBtn.setImage(UIImage.init(named: "show_vertical"), for: .normal)
        }else{
            changeBtn.setImage(UIImage.init(named: "show_horizontal"), for: .normal)
        }
        mainCollectionView?.reloadData()
    }
    
    override func addHeaderRefresh() {
        mainCollectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            
            self.refreshHeaderAction()
        })
    }
    
    ///下拉刷新事件
    override func refreshHeaderAction() {
        requestData()
        //        requestYopListData()
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
    
    func requestYopListData() {
        
        let request = SKRequest.init()
        
        weak var weakSelf = self
        var typeCoupon = type
        if typeCoupon == "10" {
            typeCoupon = "1"
        }
        request.setParam("type:"+type+";parent_id:0;status:1" as NSObject, forKey: "search")
        request.setParam("sort" as NSObject, forKey: "orderBy")
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
            }
        }
    }
    
    override func requestData() {
        
        LQLoadingView().SVPwillShowAndHideNoText()
        
        let request = SKRequest.init()
        weak var weakSelf = self
        
        let requestUrl = LNUrls().kSwhow_coupon
        
        if selectSort_id.count>0 {
            var params = "cat:"+selectSort_id+";type:"+type
            if type == "1" {
                params = params+";shop_type:1"
            }else if type == "10" {
                params = "cat:"+selectSort_id+";type:1;shop_type:2"
            }
            request.setParam(params as NSObject, forKey: "search")
        }else{
            if type == "1" {
                request.setParam("type:1;shop_type:1" as NSObject, forKey: "search")
            }else if type == "10" {
                request.setParam("type:1;shop_type:2" as NSObject, forKey: "search")
            }else{
                request.setParam("type:"+type as NSObject, forKey: "search")
            }
        }
        
        if select_type.count>0 {
            request.setParam(select_type as NSObject, forKey: "orderBy")
        }
        if sortedBy.count>0 {
            request.setParam(sortedBy as NSObject, forKey: "sortedBy")
        }
        request.setParam(String(currentPage) as NSObject, forKey: "page")

        request.setParam("and" as NSObject, forKey: "searchJoin")
        
        request.callGET(withUrl: requestUrl) { (response) in
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
//        DispatchQueue.main.async {
//            UIApplication.shared.statusBarStyle = .lightContent
//        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}


extension LNTypeGoodsiewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
            cell.setValues(model: resource[indexPath.row], type: type)
            return cell
        }else{
            let cell:LNShowGoodsHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! LNShowGoodsHorizontalCell
            cell.setValues(model: resource[indexPath.row], type: type)
            return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = resource[indexPath.row].item_id
        
        detailVc.coupone_type = type
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
    
    //    //    区头的尺寸
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: kSCREEN_WIDTH, height: 40)
    //    }
}

extension LNTypeGoodsiewController:UITextFieldDelegate{
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchBegin()
        return true
    }
    
}
extension LNTypeGoodsiewController:MenuViewControllerDelegate{
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

//        if isSearching {
//            switch tag {
//            case 0:
//                selecType = 0
//                break
//            case 1:
//                selecType = 2
//                break
//            case 2:
//                selecType = 7
//                break
//            case 3:
//                selecType = 6
//                break
//            case 4:
//                selecType = 4
//                break
//            case 5:
//                selecType = 5
//                break
//            default:
//                break
//            }
//        }else{
//        }
        refreshHeaderAction()
    }
}
