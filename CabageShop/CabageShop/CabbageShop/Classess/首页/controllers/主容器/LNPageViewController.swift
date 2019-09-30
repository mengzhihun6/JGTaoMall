//
//  LNPageViewController.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/22.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON

class LNPageViewController: LNBaseViewController {

    //    顶部导航栏
    fileprivate var navigationView:UIView!
//    fileprivate var bgImage:UIImageView!
    
    //    顶部选择栏
    fileprivate var topView = LNTopScrollView()

    let identyfierTable1  = "identyfierTable1"
    //    collectionView
    fileprivate var collectionView:UICollectionView!
    
    var resource = [UIViewController]()
    
    //    当前选择的下标
    fileprivate var currentIndex = 0
//    渐变
    fileprivate var headBgImage = UIImageView()
//    弧形的图案
    var headBottomImage = UIImageView()
    
    fileprivate var lastAlpha:CGFloat = 0
    
//    首页推荐控制器
    let mainVc = SZYMainViewController()
    
    //    点击更多之后headView滑动的高度
    fileprivate var currentHeight = CGFloat()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configSubViews()
        
        requestTopSelectList()
        mainVc.scrollDelegate = self
        addAllOptionView()
        beijingViewClick()
    }
    
    override func configSubViews()  {
        
        navigaView.isHidden = true

//        模拟导航栏
        navigationView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: navHeight+169-50))
        
//        这里是主页所看到哪个弧形的图案
        headBottomImage.frame = CGRect(x: 0, y: 0, width: navigationView.width, height: navigationView.height)
//        headBottomImage.backgroundColor = kGaryColor(num: 80)
        navigationView.addSubview(headBottomImage)
        headBottomImage.image = UIImage.init(named: "scroll_head_bg")

//        这里是控制器滑动时候，颜色在渐变的就是他
        headBgImage.frame = CGRect.zero
//        headBgImage.image = getNavigationIMG(60, fromColor: kGaryColor(num: 51), toColor: kGaryColor(num: 17))
        headBgImage.contentMode = .scaleToFill
        headBgImage.alpha = 0
        navigationView.addSubview(headBgImage)
        
//        顶部的选择栏
        topView = LNTopScrollView.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: 50))
        weak var weakSelf = self
        topView.callBackBlock { (index,model) in
//            大于100的时候就是点击了最右边的图标，反之则是选择分类。
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
                
                if weakSelf?.currentIndex != 0 {
                    weakSelf?.headBgImage.alpha = 1
                }else{
                    weakSelf?.headBgImage.alpha = (weakSelf?.lastAlpha)!
                }
            }
        }
        
        topView.backgroundColor = UIColor.clear
        navigationView.addSubview(topView)
        
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (ls) in
            ls.top.left.right.equalToSuperview()
            ls.height.equalTo(navHeight+169-30)
        }
        
        topView.snp.makeConstraints { (ls) in
            ls.left.right.equalToSuperview()
            ls.top.equalTo(navHeight)
            ls.height.equalTo(50)
        }
        headBgImage.snp.makeConstraints { (ls) in
            ls.left.right.top.equalToSuperview()
            ls.bottom.equalTo(topView)
        }

        let searchButton = UIButton.init()
        searchButton.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton.layer.cornerRadius = 16
        searchButton.setImage(UIImage.init(named: "search_icon_default"), for: .normal)
        searchButton.setTitle("搜索商品名称或宝贝标题", for: .normal)
//        if #available(iOS 11.0, *) {
//            searchButton.contentHorizontalAlignment = .leading
//        } else {
//            // Fallback on earlier versions
//        }
//        searchButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        searchButton.setTitleColor(kGaryColor(num: 69), for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        searchButton.addTarget(self, action: #selector(pushToSearch), for: .touchUpInside)
        searchButton.backgroundColor = UIColor.white
        navigationView.addSubview(searchButton)
        
//        消息按钮，没用到
        let noticeButton = UIButton.init()
        noticeButton.setImage(UIImage.init(named: "main_page_right"), for: .normal)
        noticeButton.addTarget(self, action: #selector(pushToMessage), for: .touchUpInside)
        navigationView.addSubview(noticeButton)
        
//        签到按钮，没用到
        let dateBtn = UIButton.init()
        dateBtn.setImage(UIImage.init(named: "main_page_left"), for: .normal)
        dateBtn.addTarget(self, action: #selector(pushToDate), for: .touchUpInside)
        navigationView.addSubview(dateBtn)

        self.view.addSubview(navigationView)
        var backBtnCenterY = navHeight/2+10
        
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navHeight/2+20
        }
        
        noticeButton.snp.makeConstraints { (ls) in
            ls.right.equalToSuperview().offset(-6)
            
            ls.width.height.equalTo(0)
            ls.centerY.equalTo(backBtnCenterY)
        }

        dateBtn.snp.makeConstraints { (ls) in
            ls.left.equalToSuperview().offset(6)
            ls.width.height.equalTo(0)
            ls.centerY.equalTo(backBtnCenterY)
        }

        searchButton.snp.makeConstraints { (ls) in
            ls.left.equalTo(dateBtn.snp.right).offset(6)
            ls.right.equalTo(noticeButton.snp.left).offset(-6)
            ls.height.equalTo(33)
            ls.centerY.equalTo(noticeButton)
        }

        
        let layout =  UICollectionViewFlowLayout()
        //布局属性 大小 滚动方向  间距
        layout.itemSize = (self.view.bounds.size)//使用[weak self] in 后: self.bounds.size => (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: CGFloat(navHeight)+30, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - CGFloat(navHeight) - 44), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identyfierTable1)
//        collectionView.frame = self.view.bounds

        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        
        self.view.backgroundColor = kBGColor()
        
        collectionView.snp.makeConstraints { (ls) in
            ls.bottom.left.equalToSuperview()
            ls.width.equalTo(kSCREEN_WIDTH)
            ls.top.equalTo(topView.snp.bottom)
        }
        
//        请求那个首页的广告
//        let request = SKRequest.init()
//        request.callGET(withUrl: BaseUrl+"/taoke/diy/ads?search=status:1&searchJoin=and") { (response) in
//            if !(response?.success)! {
//                return
//            }
//            let data = JSON((response?.data)!)["data"]["data"].arrayValue
//            if data.count == 0 {
//                return
//            }
//            let randomNumber:Int = Int(arc4random() % UInt32(data.count))
//
//            let topModel = LNMainAdsModel1.setupValues(json: data[randomNumber])
//            if topModel.type == "2" {
//                OCTools.init().presnetSearchVc(self.tabBarController, andModel: topModel)
//            }else{
//                OCTools().presnetMainADs(self.tabBarController, withAdModel: topModel)
//            }
//        }
        

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
//                    let guessVc = LNGuessLikeViewController()
//                    guessVc.superViewController = self
//                    weakSelf?.resource.append(guessVc)

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

    
    override func setNavigaView() {
        
    }
    
    
    @objc func pushToSearch() {
//        跳转到搜索
//        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
//        search.hidesBottomBarWhenPushed = true
//        search.isPresent = true
//        let root = LNNavigationController.init(rootViewController: search)
//        self.present(root, animated: false, completion: nil)
        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
        search.hidesBottomBarWhenPushed = true
        search.isPresent = false
        search.typeString = "1"
        self.navigationController?.pushViewController(search, animated: false)
    }

//    滑动的时候要做的事，如果滑动幅度小于屏幕宽度（在推荐页），则渐变，大于的话（不在推荐页）就是直接变黑色。
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.mj_offsetX <= kSCREEN_WIDTH {
            if lastAlpha == 0 {
                headBgImage.alpha = scrollView.mj_offsetX/kSCREEN_WIDTH
            }else{
                
                if lastAlpha<scrollView.mj_offsetX/kSCREEN_WIDTH {
                    headBgImage.alpha = scrollView.mj_offsetX/kSCREEN_WIDTH
                }
            }
        }
    }
    
//    滑动结束，该变的变一下。选中的按钮也要变。
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x/kSCREEN_WIDTH
        print(offsetX)
        
//        let button = UIButton.init()
//        button.tag = 130+Int(offsetX)
//        topView.goodAtProject(sender: button)
        currentIndex = Int(offsetX)
        topView.setSelectIndex(index: currentIndex, animation: true)
        allOptionsView.setSelectIndex(index:currentIndex)

        if currentIndex != 0 {
            headBgImage.alpha = 1
        }else{
            headBgImage.alpha = lastAlpha
        }
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
    
}

extension LNPageViewController : LNMainPageDidScrollDelegate {
    func didScroll(_ offSetY: CGFloat) {
//        print(offSetY)
//        if offSetY>=0 && offSetY<300 {
//            headBottomImage.y = -offSetY/1.5
//        }
        if offSetY>5 {
            headBgImage.alpha = offSetY/100
            lastAlpha = offSetY/100
        }else{
            headBgImage.alpha = 0
        }
    }
}
extension LNPageViewController : SZYMainViewControllerDelegate {
    func delegateScroll(_ offSetY: CGFloat) {
        //        print(offSetY)
        
//        if offSetY>=0 && offSetY<300 {
//            headBottomImage.y = -offSetY/1.5
//        }
        if offSetY>5 {
            headBgImage.alpha = offSetY/100
            lastAlpha = offSetY/100
        }else{
            headBgImage.alpha = 0
        }
        
        
        
        
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
