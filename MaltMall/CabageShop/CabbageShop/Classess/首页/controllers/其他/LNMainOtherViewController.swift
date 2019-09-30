//
//  LNMainOtherViewController.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/22.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class LNMainOtherViewController: LNBaseViewController {

    //    cell之间的距离
    fileprivate var kSpace:CGFloat = 8
    //    cell的高度
    fileprivate let kHeight:CGFloat = 255
    fileprivate var mainCollectionView:UICollectionView?
    //    数据源
    fileprivate var resource = [LNYHQModel]()
    var GoodsInformationModel = [SZYGoodsInformationModel]() //商品信息
    
    fileprivate var header : UICollectionReusableView?
    fileprivate var headView : UIView!
    fileprivate var selectView : UIView!
    fileprivate var topView:LNTopScrollView4!
    fileprivate let identyfierTableHeader = "identyfierTableHeader"
    fileprivate let identyfierTable1 = "identyfierTable1"
    fileprivate var zongChooseView = LNOtherZongSelectView()
    fileprivate var bgView = UIButton()

    var selecType = 1
    var searchtype = "2"

    var model = LNTopListModel()
    
    weak var superViewController : LNPageViewController?

    fileprivate var select_type = "id"
    fileprivate var sortedBy = "desc"
    var topBun = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()
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
        navigaView.isHidden = true
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
         let top = CGFloat(105)
        //        if kSCREEN_HEIGHT>700 {
        //            top = navHeight+10
        //        }
//        if kSCREEN_HEIGHT>800 {
//            top = navHeight+35
//        }
        
        headView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 243))
        headView.backgroundColor = UIColor.white
//        let  selectViewBg = UIImageView(frame: CGRect(x: 0, y: 0, width: kDeviceWidth, height: 182))
//        selectViewBg.image = getNavigationIMGVertical(NSInteger(182), fromColor: JGMainColor, toColor: UIColor.hex("#202126"))
//        headView.addSubview(selectViewBg)
        
        selectView = UIView.init(frame: CGRect(x: 10, y: 3, width: kSCREEN_WIDTH - 20, height: 182))
        selectView.cornerRadius = 5
        selectView.clipsToBounds = true
        setUpValues(models: model.children)
        headView.addSubview(selectView)

        topView = LNTopScrollView4.init(frame: CGRect(x: 0, y: selectView.height+7, width: kSCREEN_WIDTH, height: 49))
        topView.backgroundColor = UIColor.black
        
        weak var weakSelf = self
        topView.callBackBlock { (index,flag ) in
            if index != 0 {
                weakSelf?.setParams(index: index, flag: flag)
                weakSelf?.hiddenView()
            }else{
                
                weakSelf?.zongChooseView.y = (weakSelf?.headView.height)!
                weakSelf?.bgView.y = (weakSelf?.headView.height)!
                if (weakSelf?.zongChooseView.isHidden)! {
                    UIView.animate(withDuration: 0.1, animations: {
                        weakSelf?.zongChooseView.isHidden = false
                        weakSelf?.bgView.isHidden = false
                    })
                }else{
                    weakSelf?.hiddenView()
                }
            }
        }
        topView.setTopView(selectIndex: 0)
        
        headView.addSubview(topView)
        headView.backgroundColor = UIColor.white
        
        topView.isUserInteractionEnabled = true
        headView.isUserInteractionEnabled = true
        

        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: top-3, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight-10-64), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
//        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(cellType: JGHomeMainOtherVCCell.self)
        
//        mainCollectionView?.register(UINib.init(nibName: "LNShowGoodsHorizontalCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        
        mainCollectionView?.register(cellType: JGHomeMainOtherHCCell.self)
        
        mainCollectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identyfierTableHeader)
        
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
//        self.automaticallyAdjustsScrollViewInsets = false
        
        
        bgView = UIButton.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT))
        bgView.addTarget(self, action: #selector(hiddenView), for: .touchUpInside)
        bgView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a:0.6)
        bgView.isHidden = true
        mainCollectionView?.addSubview(bgView)
        
        zongChooseView = LNOtherZongSelectView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 50*5))
        zongChooseView.isHidden = true
        zongChooseView.callBackBlock { (index) in
            weakSelf?.setZongHeParams(index: index)
            weakSelf?.hiddenView()
        }
        mainCollectionView?.addSubview(zongChooseView)
        
        topBun = UIButton.init(frame: CGRect.init(x: kSCREEN_WIDTH - 55, y: kSCREEN_HEIGHT - 165, width: 45, height: 45));
        topBun.backgroundColor = UIColor.red
        topBun.setImage(UIImage.init(named: "返回顶部"), for: .normal)
        topBun.addTarget(self, action: #selector(topBunClick), for: .touchUpInside)
        topBun.cornerRadius = topBun.height / 2.0
        topBun.clipsToBounds = true
        topBun.isHidden = true
        self.view.addSubview(topBun)
    }
    @objc func topBunClick() {
        let indexPat = IndexPath.init(row: 0, section: 0)
        mainCollectionView?.scrollToItem(at: indexPat as IndexPath, at: .bottom, animated: true)
    }
    
    @objc func hiddenView() {
        if zongChooseView.isHidden {
            return
        }
        weak var weakSelf = self
        UIView.animate(withDuration: 0.15) {
            weakSelf?.bgView.isHidden = true
            weakSelf?.zongChooseView.isHidden = true
            weakSelf?.topView.hiddenView()
        }
    }
    
//    根据该分类下的子分类进行布局，t如果子分类数量为0，就不要显示 了。
    func setUpValues(models:[LNSuperChildrenModel]) {
        
        var total = models.count
        if total > 8 {
            total = 8
        }
        
        let lines = 4
        let kWidth:CGFloat = selectView.width/CGFloat(lines)
        let height = selectView.height/2
        
        for index in 0..<total {
            let row =  CGFloat(index%lines)
            
            let optionBtn = UIButton.init(frame: CGRect(x:kWidth * row, y:height*CGFloat(index/lines), width: kWidth, height: height))
            optionBtn.addTarget(self, action: #selector(chooseOptions(sender:)), for: .touchUpInside)
            optionBtn.tag = index+10
            optionBtn.backgroundColor = UIColor.clear
            print(optionBtn.frame)
            selectView.addSubview(optionBtn)
            
            let buttonImage = UIImageView.init(frame: CGRect(x: optionBtn.width/4-5, y:5, width: optionBtn.width/2+10, height: optionBtn.width/2+10))
            buttonImage.backgroundColor = UIColor.clear
            buttonImage.sd_setImage(with: OCTools.getEfficientAddress(models[index].logo), placeholderImage: UIImage.init(named: "goodImage_1"))

            buttonImage.isUserInteractionEnabled = false
            optionBtn.addSubview(buttonImage)
            
            let buttonTitle = UILabel.init(frame: CGRect(x: 0, y: buttonImage.height+buttonImage.y, width: optionBtn.width, height: optionBtn.height-buttonImage.height-5))
            buttonTitle.textColor = kGaryColor(num: 179)
            buttonTitle.font = UIFont.systemFont(ofSize: 12)
            buttonTitle.text = models[index].name
            buttonTitle.textAlignment = .center
            buttonTitle.isUserInteractionEnabled = false
            optionBtn.addSubview(buttonTitle)
        }
        selectView.backgroundColor = UIColor.clear
    }
    
    @objc func chooseOptions(sender:UIButton)  {
        
        let searchVc = LQSearchResultViewController()
        searchVc.keyword = model.children[sender.tag-10].name
        searchVc.type = "1"
        superViewController?.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    
    fileprivate var isCollect = false

    
    //    这些参数是固定的，具体问后台
    func setZongHeParams(index:NSInteger) {
        weak var weakSelf = self
        
        switch index {
        case 0:
            weakSelf?.select_type = "id"
            weakSelf?.sortedBy = "desc"
        case 1:
            weakSelf?.sortedBy = "desc"
            weakSelf?.select_type = "coupon_price"
//        case 2:
//            weakSelf?.sortedBy = "desc"
//            weakSelf?.select_type = "commission_rate"
//        case 3:
//
//            weakSelf?.sortedBy = "asc"
//            weakSelf?.select_type = "commission_rate"
        case 2:
            
            weakSelf?.sortedBy = "asc"
            weakSelf?.select_type = "created_at"
        default:
            break
        }
        
        refreshHeaderAction()
    }
    
//    这些参数是固定的，具体问后台
    func setParams(index:NSInteger, flag:Bool) {
        weak var weakSelf = self

        switch index {
        case 0:
            weakSelf?.select_type = "id"
            weakSelf?.sortedBy = "desc"
            break
        case 1:
            if !flag {
                weakSelf?.sortedBy = "asc"
            }else{
                weakSelf?.sortedBy = "desc"
            }
            weakSelf?.select_type = "commission_rate" //佣金
            break
        case 2:
            if !flag {
                weakSelf?.sortedBy = "asc"
            }else{
                weakSelf?.sortedBy = "desc"
            }
            weakSelf?.select_type = "volume"    //销量
            break
        case 3:
            if !flag {
                weakSelf?.sortedBy = "asc"
            }else{
                weakSelf?.sortedBy = "desc"
            }
            weakSelf?.select_type = "final_price"   //价格
            break
        case 4:
            isCollect = flag
            if !isCollect {
                //设置横向间距
                (mainCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = kSpace
                //设置纵向间距-行间距
                (mainCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = kSpace
            }else {
                //设置横向间距
                (mainCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 0
                //设置纵向间距-行间距
                (mainCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 0
            }
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
        
        request.setParam("cat:"+model.taobao+";type:1"as NSObject, forKey: "search")
        
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
//                        weakSelf?.resource.removeAll()
                        weakSelf?.GoodsInformationModel.removeAll()
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
//                        let model = LNYHQModel.setupValues(json: json)
//                        weakSelf?.resource.append(model)
                        weakSelf?.GoodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: json))
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hiddenView()
        if scrollView.mj_offsetY > 600 {
            topBun.isHidden = false
        } else {
            topBun.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hiddenView()
    }
    
}


extension LNMainOtherViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return resource.count
        return GoodsInformationModel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !isCollect {
//            let cell:LNMainFootCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainFootCell
//            cell.clipsToBounds = true
//            cell.model1 = GoodsInformationModel[indexPath.row]
////            cell.model = resource[indexPath.row]
//            return cell
            
            let cell : JGHomeMainOtherVCCell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGHomeMainOtherVCCell.self)
            cell.model1 = GoodsInformationModel[indexPath.row]
            return cell
            
            
        }else{
//            let cell:LNShowGoodsHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! LNShowGoodsHorizontalCell
////            cell.model = resource[indexPath.row]
//            cell.model1 = GoodsInformationModel[indexPath.row]
//            return cell
            
            let cell : JGHomeMainOtherHCCell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGHomeMainOtherHCCell.self)
            cell.model1 = GoodsInformationModel[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        hiddenView()
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = GoodsInformationModel[indexPath.row].item_id
        detailVc.coupone_type = GoodsInformationModel[indexPath.row].type
        detailVc.goodsUrl = GoodsInformationModel[indexPath.row].pic_url
        detailVc.GoodsInformationModel = GoodsInformationModel[indexPath.row]
        superViewController?.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isCollect {
            return CGSize(width: kDeviceWidth, height: 150)
        }else{
            
            let width = (kDeviceWidth - 8 - 8 - 5) / 2.0
            return CGSize(width: width, height: kWidthScale(168) + 106)
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
//        如果子分类数量为0，就不要显示了。
        if model.children.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: kSCREEN_WIDTH, height: 49+12+182)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if isCollect {
            return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        }else{
            
            return UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        }
        
    }

    
    //设置子视图上下之间的距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isCollect {
            return 0.5
        }else{
            return 5
        }
    }
    
    //设置子视图左右之间的距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if isCollect {
            return 0
        }else{
            return 5
        }
    }
    
    
    
}
