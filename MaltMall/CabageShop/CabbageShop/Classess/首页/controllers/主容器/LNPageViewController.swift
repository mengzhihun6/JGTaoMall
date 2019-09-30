//
//  LNPageViewController.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/22.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class LNPageViewController: LNBaseViewController {
    
    //  渐变
    fileprivate var TopGradientBg = UIImageView()
    //    顶部导航栏
    fileprivate var navigationView:UIView!
    //    顶部选择栏
    fileprivate var topView = LNTopScrollView()
    //是否可改变颜色
    var isCanChange : Bool = true
    
    //    collectionView
    fileprivate var collectionView:UICollectionView!
    var resource = [UIViewController]()
    //    当前选择的下标
    fileprivate var currentIndex = 0

    fileprivate var lastAlpha:CGFloat = 0
    //    首页推荐控制器
    let mainVc = SZYMainViewController()
    //    点击更多之后headView滑动的高度
    fileprivate var currentHeight = CGFloat()
    
    private lazy var AuthorizedAlert: JGTaobaoAuthorizedAlert = {
        let alert = JGTaobaoAuthorizedAlert()
        return alert
    }()
    
      let identyfierTable1  = "identyfierTable1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSubViews()
        
        requestTopSelectList()
        mainVc.scrollDelegate = self
        addAllOptionView()
        beijingViewClick()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePageViewTopBg), name: NSNotification.Name(rawValue: "ChangePageViewTopBg"), object: nil)
    }
    
    
    
    /// 更换背景图片
    @objc func ChangePageViewTopBg(noti:NSNotification) {
    
//        JGLog("\(noti.object ?? "1111")")
        
        if !isCanChange {
            TopGradientBg.backgroundColor = UIColor.hex("#222222")
            topView.backgroundColor = UIColor.black
            return
        }
        
        if (noti.object != nil) {
        
//            let Image = OCTools.mostColor((noti.object as! UIImage))?.image()
//            TopGradientBg.image = UIImageView.blurryImage(Image, withBlurLevel: 0.2)
            
            TopGradientBg.backgroundColor = OCTools.mostColor((noti.object as! UIImage))
            topView.backgroundColor = UIColor.clear
        }else {
            TopGradientBg.backgroundColor = UIColor.hex("#222222")
            topView.backgroundColor = UIColor.black
        }
        
        
//        headBottomImage.sd_setImage(with: OCTools.getEfficientAddress((noti.object as! String)), placeholderImage: UIImage.init(named: "nav_head_bg"))
    }
    
     func setMyViewNavigaView() {
        
        navigaView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(kDeviceWidth), height: SJHeight))
        navigaView.backgroundColor = UIColor.clear
        view.addSubview(navigaView)
        
        let icon:UIImageView = UIImageView()
        icon.image = UIImage(named: "jg_logo_2");
        
        let TitleLbl:UILabel = UILabel()
        TitleLbl.text = "麦芽淘"
        TitleLbl.font = UIFont.boldFont(18)
        TitleLbl.textColor = UIColor.white
        
        navigaView.addSubview(icon)
        navigaView.addSubview(TitleLbl)
        
        icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(TitleLbl.snp_centerY)
        }
        
        TitleLbl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    
    
    
    override func configSubViews()  {
        
        self.view.backgroundColor = UIColor.white

//        let beffectView = UIVisualEffectView(effect:  UIBlurEffect(style: .extraLight))
//        TopGradientBg.addSubview(beffectView)
//        beffectView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        //渐变
        self.view.addSubview(TopGradientBg)
        TopGradientBg.backgroundColor = UIColor.hex("#222222")
        TopGradientBg.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(SJHeight + 180)
        }
        
        // 模拟导航栏
        navigationView = UIView()
        navigationView.backgroundColor = UIColor.clear
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (ls) in
            ls.top.left.right.equalToSuperview()
            ls.height.equalTo(SJHeight + 105)
        }
        
         setMyViewNavigaView()
        
        let searchButton = UIButton.init()
        searchButton.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton.layer.cornerRadius = 10
        searchButton.setImage(UIImage.init(named: "search_icon_default"), for: .normal)
        searchButton.setTitle("请输入关键字搜索", for: .normal)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.titleLabel?.font = UIFont.font(14)
        searchButton.addTarget(self, action: #selector(pushToSearch), for: .touchUpInside)
        searchButton.backgroundColor = UIColor.hex("#363636").withAlphaComponent(0.5)
        navigationView.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(SJHeight + 5)
            make.height.equalTo(35)
        }

        
        //  顶部的选择栏
        topView = LNTopScrollView.init(frame: CGRect(x: 0, y: 0, width: kDeviceWidth, height: 50))
        topView.backgroundColor = UIColor.black
        navigationView.addSubview(topView)
        topView.snp.makeConstraints { (ls) in
            ls.left.right.equalToSuperview()
            ls.bottom.equalToSuperview()
            ls.height.equalTo(50)
        }
        
        weak var weakSelf = self
        topView.callBackBlock { (index,model) in
            //            大于100的时候就是点击了最右边的图标，反之则是选择分类。

            JGLog("\(index)")

            if index > 100 {
                //                if weakSelf?.BGView.alpha == 0 {
                //                    weakSelf?.showAllOptionsView()
                //                }else{
                //                    weakSelf?.hiddenViews()
                //                }

                let superKind = LNSuperKindViewController()

                weakSelf?.navigationController?.pushViewController(superKind, animated: true)
            }else{
                weakSelf?.currentIndex = index
                weakSelf?.collectionView.setContentOffset(CGPoint(x: kSCREEN_WIDTH*CGFloat(index), y: 0), animated: true)

//                if weakSelf?.currentIndex != 0 {
//                    weakSelf?.headBgImage.alpha = 1
//                }else{
//                    weakSelf?.headBgImage.alpha = (weakSelf?.lastAlpha)!
//                }
            }
        }
        
        

        let layout =  UICollectionViewFlowLayout()
        //布局属性 大小 滚动方向  间距
        layout.itemSize = (self.view.bounds.size)//使用[weak self] in 后: self.bounds.size => (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identyfierTable1)
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationView.snp_bottom)
            make.bottom.equalToSuperview()
        }
        
        
        if Defaults[kUserToken] == nil {
            AuthorizedAlert.isHidden = true
        }else {
            AuthorizedAlert.isHidden = (ALBBSession.sharedInstance()?.isLogin())!
        }
        self.view.addSubview(AuthorizedAlert)
        AuthorizedAlert.ActionClosure {
            if !(ALBBSession.sharedInstance()?.isLogin())! {
                ALBBSDK.sharedInstance().setAppkey(LQTools().TAOBAOAppKey)
                ALBBSDK.sharedInstance().setAuthOption(NormalAuth)
                ALBBSDK.sharedInstance().auth(self, successCallback: { (session) in
                    let user = session?.getUser()
                    JGLog("\(user?.nick ?? "===")")
                    weakSelf?.AuthorizedAlert.CloseBtnClick()
                }, failureCallback: { (session, error) in
                })
            }
        }
        
        AuthorizedAlert.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(10)
//            make.top.equalToSuperview().inset(kDeviceHight - CGFloat(IphoneXTabbarH) - CGFloat(SJHeight))
        }
    }
    
    
    //    顶部选择栏数据
    fileprivate func requestTopSelectList() {
        let request = SKRequest.init()
        request.setParam("parent_id:0;status:1" as NSObject, forKey: "search")
        request.setParam("sort" as NSObject, forKey: "orderBy")
        request.setParam("desc" as NSObject, forKey: "sortedBy")
        request.setParam("and" as NSObject, forKey: "searchJoin")
        request.setParam("1" as NSObject, forKey: "type")
        
        weak var weakSelf = self
        request.callGET(withUrl: LNUrls().kCategory) { (response) in
            if !(response?.success)! {
                weakSelf?.view.addSubview((weakSelf?.beijingView)!)
                return
            }
            weakSelf?.beijingView.removeFromSuperview()
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                
                var listModels = [LNTopListModel]()
                for index in 0..<datas.count{
                    listModels.append(LNTopListModel.setupValues(json: datas[index]))
                }
                
                weakSelf?.topView.setTopView(titles: listModels, selectIndex: (weakSelf?.currentIndex)!)
                weakSelf?.allOptionsView.setupValues(titles: listModels, images: [], selectIndex: (weakSelf?.currentIndex)!, isUrl: false)
                
                //根据选择栏的数量确定位置高度
                let count = listModels.count+2
                let kHeight:CGFloat = viewHeight
                let line = CGFloat((count)%4)
                
                if line == 0 {
                    weakSelf?.currentHeight = CGFloat((count)/4)*kHeight + CGFloat(count/4)+(CGFloat((count)/4)+1)*10+15+40
                }else{
                    weakSelf?.currentHeight = CGFloat((count)/4+1)*kHeight+(CGFloat((count)/4)+1)*10+15+40
                }
                
                //                把子控制器添加一下，除了首页推荐e和猜你喜欢，其他的都一样
                DispatchQueue.main.async {
                    
                    weakSelf?.mainVc.superViewController = self
                    
                    self.resource.append((weakSelf?.mainVc)!)

                    for index in 0..<listModels.count {
                        let otherVc = LNMainOtherViewController()
                        otherVc.model = listModels[index]
                        otherVc.superViewController = self
                        weakSelf?.resource.append(otherVc)
                    }
                    weakSelf?.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //    MARK:顶部点击方法
    
    @objc func pushToMessage() {
        self.navigationController?.pushViewController(LNSystemNoticeViewController(), animated: true)
    }
    
    @objc func pushToDate() {
        self.navigationController?.pushViewController(LNSystemNoticeViewController(), animated: true)
    }
    
    

    
    @objc func pushToSearch() {
        //        跳转到搜索
        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
        search.hidesBottomBarWhenPushed = true
        search.isPresent = false
        search.typeString = "1"
        self.navigationController?.pushViewController(search, animated: false)
    }
    
    

    
    
    //    点击显示全部分类时候的视图
    //    背景，遮布
    var BGView = UIView()
    //    选择视图
    var allOptionsView = LQShowAllOptionsView()
    fileprivate var topBGView = UIView()
    
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
        BGView = UIView.init(frame: CGRect(x: 0, y: topView.y+topView.height, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT))
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
            ls.top.equalTo(topView)
            ls.left.right.equalToSuperview()
        }
        
        allOptionsView.frame = CGRect(x: 0, y: navHeight+30, width: kSCREEN_WIDTH, height: 44)
        allOptionsView.isHidden = true
        weak var weakSelf = self
        allOptionsView.callBackBlock { (index,model) in
            kDeBugPrint(item: index)
            
            //如果index=10086，则说明点击的不是选项，是更多的图标
            if index != 10086 {
                
                weakSelf?.collectionView.setContentOffset(CGPoint(x: kSCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
                weakSelf?.currentIndex = index
                weakSelf?.topView.setSelectIndex(index:index, animation: true)
            }
            weakSelf?.hiddenViews()
        }
        
        topBGView.addSubview(allOptionsView)
        topBGView.alpha = 0
        
        //        显示全部分类其实是加在topBGView上，这样一来你可以在topBGView的顶部添加一些东西，如果不需要的话，那就直接盖到顶部。
        allOptionsView.snp.makeConstraints { (ls) in
            ls.height.equalToSuperview()
            ls.left.right.equalToSuperview()
            ls.top.equalToSuperview().offset(40)
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
        //        页面消失，定时器关闭
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LNresetTheTimer_Notification"), object: self, userInfo: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        页面打开，定时器开启
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LNInvalidateTheTimer_Notification"), object: self, userInfo: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var beijingView = UIView()
    func beijingViewClick() {
        beijingView = UIView.init(frame: CGRect.init(x: 0, y: topView.y, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - topView.y - 49))
        beijingView.backgroundColor = UIColor.clear
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: beijingView.height / 2 - 20, width: kSCREEN_WIDTH, height: 40))
        button.setTitle("刷新", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(refreshButtonClick), for: .touchUpInside)
        beijingView.addSubview(button)
    }
    @objc func refreshButtonClick() {
        kDeBugPrint(item: "刷新事件!")
        requestTopSelectList()
    }
}


extension LNPageViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable1, for: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let childVc = resource[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            return
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentIndex = scrollView.contentOffset.x/kDeviceWidth

        if currentIndex > 0 {
            isCanChange = false
            TopGradientBg.backgroundColor = UIColor.hex("#222222")
            topView.backgroundColor = UIColor.black
        }else {
            isCanChange = true
            topView.backgroundColor = UIColor.clear
        }
        
    }
    
    
    //    滑动的时候要做的事，如果滑动幅度小于屏幕宽度（在推荐页），则渐变，大于的话（不在推荐页）就是直接变黑色。
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetX = scrollView.contentOffset.x/kSCREEN_WIDTH
//        let offsetY = scrollView.contentOffset.y
//
//        JGLog("\(offsetX)")
//        JGLog("\(offsetY)")
//
//        if scrollView.mj_offsetX <= kSCREEN_WIDTH {
//            //            if lastAlpha == 0 {
//            //                headBgImage.alpha = scrollView.mj_offsetX/kSCREEN_WIDTH
//            //            }else{
//            //
//            //                if lastAlpha<scrollView.mj_offsetX/kSCREEN_WIDTH {
//            //                    headBgImage.alpha = scrollView.mj_offsetX/kSCREEN_WIDTH
//            //                }
//            //            }
//        }
//    }
    
    //    滑动结束，该变的变一下。选中的按钮也要变。
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x/kDeviceWidth

        currentIndex = Int(offsetX)
        topView.setSelectIndex(index: currentIndex, animation: true)
        allOptionsView.setSelectIndex(index:currentIndex)
    }

}

extension LNPageViewController : LNMainPageDidScrollDelegate {
    func didScroll(_ offSetY: CGFloat) {
        
        //        if offSetY>=0 && offSetY<300 {
        //            headBottomImage.y = -offSetY/1.5
        //        }
//        if offSetY>5 {
//            headBgImage.alpha = offSetY/100
//            lastAlpha = offSetY/100
//        }else{
//            headBgImage.alpha = 0
//        }
    }
}
extension LNPageViewController : SZYMainViewControllerDelegate {
    func delegateScroll(_ offSetY: CGFloat) {
//        JGLog("\(offSetY)")

        if (offSetY > 180 || offSetY < 0) {
            isCanChange = false
            TopGradientBg.backgroundColor = UIColor.hex("#222222")
            topView.backgroundColor = UIColor.black
        }else {
            isCanChange = true
            topView.backgroundColor = UIColor.clear
        }
        
        
        //        if offSetY>=0 && offSetY<300 {
        //            headBottomImage.y = -offSetY/1.5
        //        }
//        if offSetY>5 {
//            headBgImage.alpha = offSetY/100
//            lastAlpha = offSetY/100
//        }else{
//            headBgImage.alpha = 0
//        }
        
        
        
        
        //        if offSetY>=0 && offSetY<300 {
        //            headBottomImage.y = -offSetY/1.5
        //        }
        //        if offSetY>5 {
        //            headBgImage.alpha = offSetY/100
        //            lastAlpha = offSetY/100
        //
        //            if 1 - lastAlpha > 0 {
        //                topView.backgroundColor = kSetRGBAColor(r: 255, g: 255, b: 255, a: 1 - lastAlpha)
        //
        //            } else {
        //                topView.backgroundColor = kSetRGBAColor(r: 255, g: 255, b: 255, a: 0)
        //                topView.textColor = kGaryColor(num: 255)
        //            }
        //
        //        } else {
        //            topView.textColor = kGaryColor(num: 45)
        //
        //            topView.alpha = 1
        //            headBgImage.alpha = 0
        //        }
        
    }
}
