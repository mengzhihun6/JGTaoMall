//
//  JTHtaoBaoViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/4/2.
//  Copyright © 2019 HT. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class JTHtaoBaoViewController: LNBaseViewController {
    
    //    顶部导航栏
    fileprivate var navigationView:UIView!
    //    顶部选择栏
    fileprivate var topView = LNTopScrollView()
    let identyfierTable1  = "identyfierTable1"
    fileprivate var collectionView:UICollectionView!
    var resource = [UIViewController]()
    //    当前选择的下标
    fileprivate var currentIndex = 0
    //    弧形的图案
    var headBottomImage = UIImageView()
    //    点击更多之后headView滑动的高度
    fileprivate var currentHeight = CGFloat()
    
    //    点击显示全部分类时候的视图
    //    背景，遮布
    var BGView = UIView()
    //    选择视图
    var allOptionsView = LQShowAllOptionsView()
    fileprivate var topBGView = UIView()
    var superViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        requestTopSelectList()
        addAllOptionView()
    }
    override func configSubViews()  {
        navigaView.isHidden = true
        
        var topHeight = navHeight
        if kSCREEN_HEIGHT >= 812 {
            topHeight = navHeight + 20
        }
        navigationView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: topHeight))
        
        headBottomImage.frame = CGRect(x: 0, y: 0, width: navigationView.width, height: navigationView.height)
        headBottomImage.backgroundColor = kGaryColor(num: 246)
        navigationView.addSubview(headBottomImage)
//        顶部的选择栏
        topView = LNTopScrollView.init(frame: CGRect(x: 0, y: CGFloat(navHeight), width: kSCREEN_WIDTH, height: 50))
        topView.textColor = kGaryColor(num: 45)
        topView.rightWidth = 0
        topView.backgroundColor = UIColor.white
        weak var weakSelf = self
        topView.callBackBlock { (index,model) in
            if index > 100 { //            大于100的时候就是点击了最右边的图标，反之则是选择分类。
                if weakSelf?.BGView.alpha == 0 {
                    weakSelf?.showAllOptionsView()
                }else{
                    weakSelf?.hiddenViews()
                }
            }else{
                weakSelf?.currentIndex = index
                weakSelf?.collectionView.setContentOffset(CGPoint(x: kSCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
            }
        }
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
        
        let searchButton = UIButton.init()
        searchButton.layoutButton(with: .left, imageTitleSpace: 5)
        searchButton.layer.cornerRadius = 5
        searchButton.setImage(UIImage.init(named: "search_icon_default"), for: .normal)
        searchButton.setTitle("立即查找独家优惠券", for: .normal)
        searchButton.setTitleColor(kGaryColor(num: 69), for: .normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        searchButton.addTarget(self, action: #selector(pushToSearch), for: .touchUpInside)
        searchButton.backgroundColor = UIColor.white
        navigationView.addSubview(searchButton)
        
//        消息按钮，没用到   右边
        let noticeButton = UIButton.init()
        noticeButton.setImage(UIImage.init(named: "通知"), for: .normal)
        noticeButton.addTarget(self, action: #selector(pushToMessage), for: .touchUpInside)
        navigationView.addSubview(noticeButton)
//        签到按钮，没用到  左边
        let dateBtn = UIButton.init()
        dateBtn.setImage(UIImage.init(named: "icon_return_gray"), for: .normal)
        dateBtn.addTarget(self, action: #selector(pushToDate), for: .touchUpInside)
        navigationView.addSubview(dateBtn)
        self.view.addSubview(navigationView)
        
        var backBtnCenterY = navHeight/2+10
        if kSCREEN_HEIGHT == 812 {
            backBtnCenterY = navHeight/2+20
        }
        
        noticeButton.snp.makeConstraints { (ls) in
            ls.right.equalToSuperview().offset(-6)
            ls.width.height.equalTo(35)
            ls.centerY.equalTo(backBtnCenterY)
        }
        dateBtn.snp.makeConstraints { (ls) in
            ls.left.equalToSuperview().offset(6)
            ls.width.height.equalTo(35)
            ls.centerY.equalTo(backBtnCenterY)
        }
        searchButton.snp.makeConstraints { (ls) in
            ls.left.equalTo(dateBtn.snp.right).offset(6)
            ls.right.equalTo(noticeButton.snp.left).offset(-6)
            ls.height.equalTo(33)
            ls.centerY.equalTo(noticeButton)
        }
        
        let layout =  UICollectionViewFlowLayout()
        // 布局属性 大小 滚动方向  间距
        layout.itemSize = (self.view.bounds.size)  // 使用[weak self] in 后: self.bounds.size => (self?.bounds.size)!
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
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        self.view.backgroundColor = kBGColor()
        
        collectionView.snp.makeConstraints { (ls) in
            ls.bottom.left.equalToSuperview()
            ls.width.equalTo(kSCREEN_WIDTH)
            ls.top.equalTo(topView.snp.bottom)
        }
        
    }
//      #MARK:  跳转到搜索
    @objc func pushToSearch() {
        let search = UIStoryboard(name:"CXShearchStoryboard",bundle:nil).instantiateViewController(withIdentifier: "CXSearchController") as! CXSearchController
        search.hidesBottomBarWhenPushed = true
        search.isPresent = false
        search.typeString = "1"
        self.navigationController?.pushViewController(search, animated: false)
        
    }
//   #MARK: 左 右按钮事件
    @objc func pushToMessage() { //右
//        self.navigationController?.pushViewController(LNSystemNoticeViewController(), animated: true)
        
  
    }
    @objc func pushToDate() {  //左
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
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
//                weakSelf?.view.addSubview((weakSelf?.beijingView)!)   //没数据添加一个刷新按钮
                return
            }
//            weakSelf?.beijingView.removeFromSuperview()   //移除刷新按钮
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                var listModels = [LNTopListModel]()
                for index in 0..<datas.count{
                    listModels.append(LNTopListModel.setupValues(json: datas[index]))
                }
                weakSelf?.topView.setTopView(titles: listModels, selectIndex: (weakSelf?.currentIndex)!)
                weakSelf?.allOptionsView.setupValues(titles: listModels, images: [], selectIndex: (weakSelf?.currentIndex)!, isUrl: false)
                
                //根据选择栏的数量确定位置高度
                let count = listModels.count + 2
                let kHeight:CGFloat = viewHeight
                let line = CGFloat((count) % 4)
                
                if line == 0 {
                    weakSelf?.currentHeight = CGFloat((count) / 4) * kHeight + CGFloat(count / 4) + (CGFloat((count) / 4) + 1) * 10 + 15 + 40
                } else {
                    weakSelf?.currentHeight = CGFloat((count) / 4 + 1) * kHeight + (CGFloat((count) / 4) + 1) * 10 + 15 + 40
                }
//                把子控制器添加一下，除了首页推荐e和猜你喜欢，其他的都一样
                let other = JTHtaoBao()
                other.model = LNTopListModel()
                other.superViewController = weakSelf?.superViewController
                self.resource.append(other)
                
                for index in 0..<listModels.count {
                    let otherVc = JTHtaoBao()
                    otherVc.model = listModels[index]
                    otherVc.superViewController = weakSelf?.superViewController
                    weakSelf?.resource.append(otherVc)
                }
                weakSelf?.collectionView.reloadData()
            }
        }
    }
    
//     背景，遮布 点击事件  隐藏弹出的选择界面
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
    
//      视图TagView
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

            //如果index=10086，则说明点击的不是选项，是更多的图标
            if index != 10086 {
                weakSelf?.collectionView.setContentOffset(CGPoint(x: kSCREEN_WIDTH * CGFloat(index), y: 0), animated: true)
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
//      隐藏选择栏的时候，要更新其他选择栏的按钮位置
    func hiddenViews() {
        topView.setSelectIndex(index:currentIndex, animation: true)
        allOptionsView.hiddenView()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.topBGView.alpha = 0
            weakSelf?.BGView.alpha = 0
        })
    }
//    滑动结束，该变的变一下。选中的按钮也要变。
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x/kSCREEN_WIDTH
        print(offsetX)
        
        currentIndex = Int(offsetX)
        topView.setSelectIndex(index: currentIndex, animation: true)
        allOptionsView.setSelectIndex(index:currentIndex)
    }
    
}
extension JTHtaoBaoViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        let childVc = resource[indexPath.row]
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
    
    
    
    //zhegefangfameiyouyong
    func createTwoLabelAndView() {
        let label = UILabel()
        let attrString = NSMutableAttributedString(string: "投入(元）")
        label.frame = CGRect(x: 26, y: 130, width: 63.5, height: 21)
        label.numberOfLines = 0
        let attr: [NSAttributedString.Key : Any] = [.font: UIFont(name: "苹方-简 常规体", size: 15),.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
        label.attributedText = attrString
        view.addSubview(label)
        
        let label1 = UILabel()
        let attrString1 = NSMutableAttributedString(string: "打卡时间：06:28")
        label1.frame = CGRect(x: 41, y: 265.5, width: 111.5, height: 21)
        label1.numberOfLines = 0
        let attr1: [NSAttributedString.Key : Any] = [.font: UIFont(name: "苹方-简 常规体", size: 15),.foregroundColor: UIColor(red: 0.94, green: 0.33, blue: 0, alpha: 1)]
        attrString1.addAttributes(attr1, range: NSRange(location: 0, length: attrString.length))
        label1.attributedText = attrString
        view.addSubview(label1)
        
        let layerView = UIView()
        layerView.frame = CGRect(x: 0, y: 0, width: 375, height: 787.5)
        // fillCode
        let bgLayer1 = CALayer()
        bgLayer1.frame = layerView.bounds
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layerView.layer.addSublayer(bgLayer1)
        view.addSubview(layerView)
    }
    
}
