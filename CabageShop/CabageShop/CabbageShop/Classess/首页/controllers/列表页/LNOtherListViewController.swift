//
//  LNOtherListViewController.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/25.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh


class LNOtherListViewController: LNBaseViewController {

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
    fileprivate var topView:LNTopScrollView4!
    fileprivate let identyfierTableHeader = "identyfierTableHeader"
    fileprivate let identyfierTable1 = "identyfierTable1"
    
    var selecType = 1
    var searchtype = "2"
    
    var model = LNNewMainLayoutModel()
    
    var superViewController : UIViewController?
    
    
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

        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        var top = navHeight+20
        //        if kSCREEN_HEIGHT>700 {
        //            top = navHeight+10
        //        }
        if kSCREEN_HEIGHT>800 {
            top = navHeight+35
        }
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(UINib.init(nibName: "LNShowGoodsHorizontalCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        mainCollectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identyfierTableHeader)
        
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        //        self.automaticallyAdjustsScrollViewInsets = false
        
        headView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 182+10+49))
        headImage = UIImageView.init(frame: CGRect(x: 0, y: 10, width: kSCREEN_WIDTH, height: 182))
        headImage.sd_setImage(with: OCTools.getEfficientAddress(model.list_thumb), placeholderImage: UIImage.init(named: "goodImage_1"))
        headView.addSubview(headImage)
        
        topView = LNTopScrollView4.init(frame: CGRect(x: 0, y: headImage.height+10, width: kSCREEN_WIDTH, height: 49))
        topView.backgroundColor = UIColor.white
        weak var weakSelf = self
        topView.callBackBlock { (index,flag ) in
            weakSelf?.setParams(index: index, flag: flag)
        }
        topView.setTopView(selectIndex: 0)
//        topView.changerStyle()

        headView.addSubview(topView)
        headView.backgroundColor = kGaryColor(num: 245)
        
        topView.isUserInteractionEnabled = true
        headView.isUserInteractionEnabled = true
        
        navigationTitle = model.name
        changeStyle()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            UIApplication.shared.statusBarStyle = .default
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    fileprivate var isCollect = false
    
    func setParams(index:NSInteger, flag:Bool) {
        weak var weakSelf = self
        
        switch index {
        case 0:
            weakSelf?.select_type = "id"
            weakSelf?.sortedBy = ""
        case 1:
            if !flag {
                weakSelf?.sortedBy = "asc"
            }else{
                weakSelf?.sortedBy = "desc"
            }
            weakSelf?.select_type = "volume"
            
        case 2:
            if !flag {
                weakSelf?.sortedBy = "asc"
            }else{
                weakSelf?.sortedBy = "desc"
            }
            weakSelf?.select_type = "coupon_price"
        case 3:
            isCollect = flag
            
            mainCollectionView?.reloadData()
            return
        default:
            break
        }
        
        refreshHeaderAction()
    }
    
    override func requestData() {
        let request = SKRequest.init()
        
        weak var weakSelf = self
        
        let arr = model.params.components(separatedBy: "&")
        for item in arr {
            let strs = item.components(separatedBy: "=")
            if strs.count == 2 {
                if strs[0] != "orderBy" {
                    request.setParam(strs[1] as NSObject, forKey: strs[0])
                }
            }
        }
        request.setParam(select_type as NSObject, forKey: "orderBy")
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


extension LNOtherListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return resource.count
        return resource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !isCollect {
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
        detailVc.good_item_id = resource[indexPath.row].item_id
        detailVc.coupone_type = resource[indexPath.row].type
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isCollect {
            return CGSize(width: kSCREEN_WIDTH-16, height: 120)
        }else{
            return CGSize(width: (kSCREEN_WIDTH-kSpace-16)/2, height: kHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if header != nil {
            return header!
        }
        if kind == UICollectionElementKindSectionHeader {
            let headView1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identyfierTableHeader, for: indexPath)
            headView1.addSubview(headView)
            headView1.isUserInteractionEnabled = true
            header = headView1
            
            return header!
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kSCREEN_WIDTH, height: 49+12+182)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    }
    
}
