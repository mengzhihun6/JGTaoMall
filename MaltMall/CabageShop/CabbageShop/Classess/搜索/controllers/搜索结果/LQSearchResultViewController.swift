//
//  LQSearchResultViewController.swift
//  LingQuan
//
//  Created by RongXing on 2018/5/21.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import MJRefresh
import DeviceKit

class LQSearchResultViewController: LNBaseViewController {
    
//    //    顶部导航栏下
    fileprivate var navigationBottomView:UIView!

    //气泡
    fileprivate var showView = ArrowheadMenu()

    //    搜索框
    fileprivate var searchTextfield = UITextField()
    @objc var keyword = String()
//    @objc var searchtype = String()
    @objc var type = String()
    
    let titles = ["淘宝", "京东", "拼多多"]   // 气泡
    var searchBun = UIButton()

    fileprivate var isCollect = false
    //    顶部选择栏
    fileprivate var topView = LNTopScrollView2()

    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 8
    //    cell的高度
    fileprivate let kHeight:CGFloat = 255
    
    //    数据源
    fileprivate var resource = [LNYHQModel]()
    var GoodsInformationModel = [SZYGoodsInformationModel]()
    
    
    let identyfierTable1  = "identyfierTable1"

    fileprivate var currentType = "1"
    var changeBtn = UIButton()

    var selecType = 1
    var searchtype = "2"
    
    //    当前选择的下标
    fileprivate var currentIndex = 0

    fileprivate var is_coupon = false
    
    //    回调
    typealias swiftBlock = (_ keyword:String) -> Void
    var willClick : swiftBlock? = nil
    @objc func callKeywordBlock(block: @escaping ( _ keyword:String) -> Void ) {
        willClick = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        requestYopListData()
        addFooterRefresh()
        
        addImageWhenEmpty()

//        addMoreButton() //右下角的按钮
        NotificationCenter.default.addObserver(self, selector: #selector(LQReloadGoodInfo(notification:)), name: NSNotification.Name(rawValue: LQTools().LQReloadGoodInfo), object: nil)
    }
    
    
    @objc func LQReloadGoodInfo(notification:Notification) {
        
        keyword = notification.userInfo!["keyword"] as! String
        type = notification.userInfo!["type"] as! String
        searchTextfield.text = keyword
        if willClick != nil {
            willClick!(searchTextfield.text!)
        }
        refreshHeaderAction()
    }

    
    fileprivate var emptyView = UIView()
    //    当数据为空的时候，显示提示
    func addImageWhenEmpty() {
        _ = emptyView.subviews.map {
            $0.removeFromSuperview()
        }

        emptyView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 46))
        emptyView.backgroundColor = kBGColor()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 247 * kSCREEN_SCALE, height: 123 * kSCREEN_SCALE))
//        imageView.image = UIImage.init(named: "collect_empty_icon")
        imageView.center = CGPoint(x: emptyView.centerX, y: emptyView.centerY - 200 * kSCREEN_SCALE)
        emptyView.addSubview(imageView)
    }
    
    
    func getValues(keywords:String) {
        keyword = keywords
    }
    
    
    override func setNavigaView() {
        
        navigaView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(kDeviceWidth), height: SJHeight))
        navigaView.backgroundColor = UIColor.black
        view.addSubview(navigaView)
        
        //    返回按钮
        let backBtn = UIButton()
        backBtn.setImage(UIImage.init(named: "nav_return_white"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)

        
        let TitleLbl:UILabel = UILabel()
        TitleLbl.text = "麦芽淘"
        TitleLbl.font = UIFont.boldFont(18)
        TitleLbl.textColor = UIColor.white
        
        navigaView.addSubview(backBtn)
        navigaView.addSubview(TitleLbl)
        
        backBtn.snp.makeConstraints { (ls) in
            ls.left.equalTo(0)
            ls.width.equalTo(35)
            ls.height.equalTo(44)
            ls.bottom.equalToSuperview()
        }
        
        TitleLbl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    
    override func configSubViews() {

        
        navigationBottomView = UIView()
        navigationBottomView.backgroundColor = UIColor.white
        
        view.addSubview(navigationBottomView)
        navigationBottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(SJHeight)
            make.height.equalTo(50)
        }
        

        //  更改布局
        changeBtn.setImage(UIImage.init(named: "show_horizontal"), for: .normal)
        changeBtn.addTarget(self, action: #selector(rightAction(sender:)), for: .touchUpInside)
        changeBtn.tintColor = UIColor.white
        navigationBottomView.addSubview(changeBtn)
        
        changeBtn.snp.makeConstraints { (ls) in
            ls.right.equalTo(-5)
            ls.centerY.equalToSuperview()
            ls.width.equalTo(0)
            ls.height.equalTo(30)
        }
        
        searchTextfield.borderStyle = .none
        searchTextfield.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH-60, height: 34))
        searchTextfield.placeholder = "输入关键词查券"
        searchTextfield.leftViewMode = .always
        searchTextfield.returnKeyType = .search
        searchTextfield.clearButtonMode = .whileEditing
        searchTextfield.delegate = self
        searchTextfield.backgroundColor = UIColor.hex("#F7F7F7")
        searchTextfield.layer.cornerRadius = 17
        searchTextfield.clipsToBounds = true
//        searchTextfield.becomeFirstResponder()
        searchTextfield.font = UIFont.systemFont(ofSize: 14)
        searchTextfield.textColor = UIColor.hex("#666666")
        let attrString = NSMutableAttributedString.init(string: "输入关键词查券")
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.hex("#CCCCCC")], range: NSMakeRange(0, "输入关键词查券".count))
        searchTextfield.attributedPlaceholder = attrString;
        searchTextfield.text = keyword
        let leftImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        leftImage.image = UIImage.init(named: "search_shape")
        searchTextfield.leftViewMode = .always
        searchTextfield.leftView = leftImage
        
        
        searchBun = UIButton.init(type: .custom)
        searchBun.frame = CGRect.init(x: 0, y: 0, width: 80, height: 30)
        searchBun.setTitle(titles[Int(type)! - 1], for: .normal)
        
        searchBun.setImage(UIImage.init(named: "com_arrow_bottom"), for: .normal)
        searchBun.titleLabel?.font = UIFont.font(14)
        searchBun.setTitleColor(UIColor.hex("#CCCCCC"), for: .normal)
        searchBun.layoutButton(with: .right, imageTitleSpace: 3)
        searchBun.addTarget(self, action: #selector(searchBunClick(sender:)), for: .touchUpInside)
        searchTextfield.rightViewMode = .always
        searchTextfield.rightView = searchBun
        
        navigationBottomView.addSubview(searchTextfield)
        searchTextfield.snp.makeConstraints { (ls) in
            ls.left.right.equalToSuperview().inset(10)
            ls.centerY.equalToSuperview()
            ls.height.equalTo(30)
        }
        
        
        topView = LNTopScrollView2.init(frame: CGRect(x: 0, y: SJHeight + 100, width: Int(kSCREEN_WIDTH), height: 50))
        topView.backgroundColor = UIColor.white
        weak var weakSelf = self
        topView.callBackBlock { (index,flag ) in
            if index == 10086 {
                let touchButton = weakSelf?.topView.viewWithTag(10086)
                weakSelf?.showView.presentView(touchButton!)
            }else{
                weakSelf?.setParams(index: index, flag: flag)
            }
        }
        topView.setTopView(selectIndex: 0)
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBottomView.snp_bottom)
            make.height.equalTo(50)
        }
        
        
        
        let selectView = UIView.init(frame: CGRect(x: 0, y: navHeight+100, width: kSCREEN_WIDTH, height: 44))
        selectView.backgroundColor = UIColor.white
        
        let markButton = UIButton.init(frame: CGRect(x: 16, y: 0, width: 200, height: selectView.height))
        markButton.setTitle("仅显示有券商品", for: .normal)
        markButton.setImage(UIImage.init(named: "search_head_icon_switch"), for: .normal)
        markButton.layoutButton(with: .left, imageTitleSpace: 5)
        markButton.setTitleColor(UIColor.hex("#CCCCCC"), for: .normal)
        markButton.contentHorizontalAlignment = .left
        markButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        selectView.addSubview(markButton)
    
        
        let swichBtn = UISwitch.init(frame: CGRect(x: kSCREEN_WIDTH-40-16, y: 0, width: 40, height: selectView.height))
        swichBtn.centerY = markButton.centerY
        swichBtn.isOn = is_coupon
        swichBtn.addTarget(self, action: #selector(swichAction(sender:)), for: .valueChanged)
        selectView.addSubview(swichBtn)
        self.view.addSubview(selectView)
        
        
        
        
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: selectView.y+selectView.height + 1, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - CGFloat(navHeight) - 40 - 37), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        mainCollectionView?.register(UINib.init(nibName: "LNShowGoodsHorizontalCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable1)
        
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = UIColor.white//kBGColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
//        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: ["淘宝","京东","拼多多"], icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
//        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
//        showView.delegate = self
        
        showView = ArrowheadMenu.init(defaultArrowheadMenuWithTitle: titles, icon: nil, menuPlacements: MenuPlacements(rawValue: MenuPlacements.ShowAtBottom.rawValue)!)!
        showView.view.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0.5)
        showView.numInt = 100
        showView.delegate = self
        
    }
    
    @objc fileprivate func searchBunClick(sender:UIButton) {
        sender.isSelected = true
        showView.presentView(sender)
    }
    
    @objc fileprivate func swichAction(sender:UISwitch) {
        is_coupon = sender.isOn
        refreshHeaderAction()
    }
    

    
    func setParams(index:NSInteger, flag:Bool) { //1.综合，2.销量（高到低），3.销量（低到高），4.价格(低到高)，5.价格（高到低），6.佣金比例（高到低）   9佣金比例（低到高）   暂无 ：7. 卷额(从高到低) 8.卷额(从低到高)
        switch index {
        case 0:
            selecType = 1
            break
        case 1: //佣金
            if flag { // 高到低
                selecType = 6
            }else{
                selecType = 9
            }
            break
        case 2: //销量
            if flag {
                selecType = 2
            }else{
                selecType = 3
            }
            break
        case 3: //价格
            if flag {
                selecType = 5
            }else{
                selecType = 4
            }
            break
        case 4:
//            isCollect = !isCollect
//            mainCollectionView?.reloadData()
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
    
    @objc fileprivate func searchBegin() {
        if (searchTextfield.text?.count)! == 0 {
            setToast(str: "请输入关键词")
            return
        }
        
        if willClick != nil {
            willClick!(searchTextfield.text!)
        }
        
        keyword = searchTextfield.text!
        searchTextfield.resignFirstResponder()

        refreshHeaderAction()
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
        currentPage = 1
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
    }
    
    override func requestData() {
        DispatchQueue.main.async {
            LQLoadingView().SVPwillShowAndHideNoText()
        }

        let request = SKRequest.init()
        weak var weakSelf = self
        
        let requestUrl = LNUrls().kSearch
        request.setParam(type as NSObject, forKey: "type")
        request.setParam(keyword as NSObject, forKey: "q")
        request.setParam(searchtype as NSObject, forKey: "searchtype")
        request.setParam(String(currentPage) as NSObject, forKey: "page")
        request.setParam(String(selecType) as NSObject, forKey: "sort")

        if is_coupon {
            request.setParam("true" as NSObject, forKey: "is_coupon")
        }else{
            request.setParam("false" as NSObject, forKey: "is_coupon")
        }
        
        request.callGET(withUrl: requestUrl) { (response) in
            LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                if !(response?.success)! {
                    weakSelf?.mainCollectionView?.mj_footer.endRefreshing()
                    return
                }

                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                let pages = JSON((response?.data["data"])!)["meta"]["last_page"].intValue
                
                kDeBugPrint(item: "datasdatasdatasdatasdatas")
                kDeBugPrint(item: datas)
                
                if weakSelf?.currentPage == 1 {
//                    weakSelf?.resource.removeAll()
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
//                    let model = LNYHQModel.setupValues(json: datas[index])
//                    model.isSearching = true
//                    weakSelf?.resource.append(model)
                    weakSelf?.GoodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: datas[index]))
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
    
    var addButton = UIButton()
    var localButton = UIButton()
    var allButton = UIButton()
    let kWidth:CGFloat = 54
    var effe = UIVisualEffectView()
    func addMoreButton() {
        
        let blur = UIBlurEffect.init(style: .light)
        effe = UIVisualEffectView.init(effect: blur)
        effe.frame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 900)
        effe.layer.masksToBounds = true
        effe.layer.cornerRadius = 5;
        effe.alpha = 0;
        effe.isUserInteractionEnabled = true
        self.view.addSubview(effe)
        
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(identityAction))
        singleTap.numberOfTapsRequired = 1
        effe.addGestureRecognizer(singleTap)

        localButton = UIButton.init(frame: CGRect(x: kSCREEN_WIDTH-kWidth*2-16, y: kSCREEN_HEIGHT-kWidth-30, width: kWidth*2, height: kWidth))
        localButton.setImage(UIImage.init(named: "search_local"), for: .normal)
        localButton.alpha = 0
        localButton.addTarget(self, action: #selector(localButtonTouched(sender:)), for: .touchUpInside)
        localButton.setTitleColor(kGaryColor(num: 167), for: .normal)
        localButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        localButton.contentHorizontalAlignment = .right
        localButton.setTitle("搜本地", for: .normal)
        localButton.layoutButton(with: MKButtonEdgeInsetsStyle.right, imageTitleSpace: 6)
        self.view.addSubview(localButton)
        
        allButton = UIButton.init(frame: CGRect(x: kSCREEN_WIDTH-kWidth*2-16, y: kSCREEN_HEIGHT-kWidth-30, width: kWidth*2, height: kWidth))
        allButton.setImage(UIImage.init(named: "search_all"), for: .normal)
        allButton.alpha = 0
        allButton.addTarget(self, action: #selector(allButtonTouched(sender:)), for: .touchUpInside)
        allButton.setTitleColor(kGaryColor(num: 167), for: .normal)
        allButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        allButton.contentHorizontalAlignment = .right
        allButton.setTitle("搜全网", for: .normal)
        allButton.layoutButton(with: MKButtonEdgeInsetsStyle.right, imageTitleSpace: 6)

        self.view.addSubview(allButton)
        
        addButton = UIButton.init(frame: CGRect(x: kSCREEN_WIDTH-kWidth-16, y: kSCREEN_HEIGHT-kWidth-30, width: kWidth, height: kWidth))
        addButton.setBackgroundImage(UIImage.init(named: "search_add_bg"), for: .normal)
        addButton.setImage(UIImage.init(named: "search_add_icon"), for: .normal)
        //        addButton.backgroundColor = kMainColor1()
        addButton.clipsToBounds = true
        addButton.cornerRadius = kWidth/2
//        addButton.setTitleColor(kGaryColor(num: 167), for: .normal)
//        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        addButton.contentHorizontalAlignment = .right
//        addButton.layoutButton(with: MKButtonEdgeInsetsStyle.right, imageTitleSpace: 6)

        addButton.addTarget(self, action: #selector(addButtonTouched(sender:)), for: .touchUpInside)
        self.view.addSubview(addButton)
        
    }
    
    
    @objc func addButtonTouched(sender:UIButton) {
        
        if self.addButton.isSelected {
            
            identityAction()
        }else{
            UIView.animate(withDuration: 0.4) {
                
                self.effe.alpha = 1;

                self.addButton.isSelected = true
                self.localButton.alpha = 1
                self.allButton.alpha = 1
                
                self.addButton.transform = CGAffineTransform.init(rotationAngle: .pi/4)
                self.allButton.transform = CGAffineTransform.init(translationX: 0, y: -self.kWidth-10)
                self.localButton.transform = CGAffineTransform.init(translationX: 0, y: -self.kWidth*2-20)
            }
        }
    }
    
    
    @objc func localButtonTouched(sender:UIButton) {
        searchtype = "1"
        identityAction()
        refreshHeaderAction()
    }
    
    
    @objc func allButtonTouched(sender:UIButton) {
        searchtype = "2"
        identityAction()
        refreshHeaderAction()
    }
    
    @objc func identityAction()  {
        UIView.animate(withDuration: 0.4) {
            self.effe.alpha = 0;

            self.addButton.isSelected = false
            self.localButton.alpha = 0
            self.allButton.alpha = 0
            
            self.addButton.transform = .identity
            self.allButton.transform = .identity
            self.localButton.transform = .identity
        }
    }
    
}


extension LQSearchResultViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if resource.count == 0 {
//            self.mainCollectionView?.addSubview(emptyView)
//        }else{
//            emptyView.removeFromSuperview()
//        }
//        return resource.count
        if GoodsInformationModel.count == 0 {
            self.mainCollectionView?.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
        return GoodsInformationModel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isCollect {
            let cell:LNMainFootCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainFootCell
            
//            cell.model = resource[indexPath.row]
            cell.model1 = GoodsInformationModel[indexPath.row]

            return cell
        }else{
            let cell:LNShowGoodsHorizontalCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath) as! LNShowGoodsHorizontalCell
//            cell.setupValues(model: resource[indexPath.row])
//            if resource.count>0{
//                cell.model = resource[indexPath.row]
//            }
            if GoodsInformationModel.count > 0 {
                cell.model1 = GoodsInformationModel[indexPath.row]
            }
            return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailVc = SZYGoodsViewController()
        if Defaults[kIsSuper_VIP] == "true" {
//            detailVc.isSuper_VIP = true
        }
        detailVc.good_item_id = GoodsInformationModel[indexPath.row].item_id
        if GoodsInformationModel[indexPath.row].shop_type == "2" {
            detailVc.coupone_type = "10"
        }else{
            detailVc.coupone_type = GoodsInformationModel[indexPath.row].type
        }
        detailVc.goodsUrl = GoodsInformationModel[indexPath.row].pic_url
        detailVc.GoodsInformationModel = GoodsInformationModel[indexPath.row]
        navigationController?.pushViewController(detailVc, animated: true)
    }

    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if !isCollect {
            return CGSize(width: kSCREEN_WIDTH, height: 150)
        }else{
            return CGSize(width: (kSCREEN_WIDTH-kSpace-24)/2, height: kHeight)
        }
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 8, bottom: 10, right: 8)
    }
    
}

extension LQSearchResultViewController:UITextFieldDelegate{
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchBegin()
        return true
    }
    
}
extension LQSearchResultViewController:MenuViewControllerDelegate{
//    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
//
//        type = String(tag+1)
//        refreshHeaderAction()
//    }
    
    func menu(_ menu: BaseMenuViewController!, didClickedItemUnitWithTag tag: Int, andItemUnitTitle title: String!) {
        searchBun.setTitle(title, for: .normal)
        searchBun.layoutButton(with: .right, imageTitleSpace: 3)
        type = String(tag+1)
        refreshHeaderAction()
    }

}
