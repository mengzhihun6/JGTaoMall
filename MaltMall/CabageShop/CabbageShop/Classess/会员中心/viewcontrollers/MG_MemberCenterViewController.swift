//
//  MG_MemberCenterViewController.swift
//  CabbageShop
//
//  Created by 赵马刚 on 2018/12/23.
//  Copyright © 2018 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults
import MJRefresh

public let kSignin = BaseUrl + "/user/signin"

class MG_MemberCenterViewController: LNBaseViewController {

    
    var currentLevel:Int = 1
    var maxLevel:Int = 1
    //    数据源
    fileprivate var resourceArray = [LNYHQListModel]()
    var memberModel = LNMemberModel()
    var resoruce = [LNPartnerModel]()
    fileprivate var navigationView:UIView!
    fileprivate var bgImage:UIImageView!
    //    collectionView
    @objc public var mainCollectionView:UICollectionView?
    @objc public var selectIndex = NSInteger()
    @objc public var currentIndex = 100
    fileprivate var footer : UICollectionReusableView?
//    fileprivate var headView : UIView!
//    fileprivate var selectView : UIView!
//    fileprivate var topView:LNTopScrollView4!
    let FooterCollectionReusableView = "FooterCollectionReusableView"
    
    let NextLevelCollectionViewCell  = "NextLevelCollectionViewCellID"
    let LevelCollectionViewCellID  = "LevelCollectionViewCellID"
    let UpgradeCollectionViewCell  = "UpgradeCollectionViewCellID"
    let superCollectionViewCellID  = "superCollectionViewCellID"
    
    let LNMainFootCell  = "LNMainFootCellID"
   let EquityheadCollectionReusableView = "EquityheadCollectionReusableView"
   let HotRecommendCollectionReusableView = "HotRecommendCollectionReusableView"
    
    
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = 100
    
    var headView = TKShowVideoReusableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = kBGColor()
        self.navigaView.isHidden  = true
        requestUserData()

        let head = mainCollectionView?.mj_header as! MJRefreshNormalHeader
        head.lastUpdatedTimeLabel.textColor = UIColor.white
        head.stateLabel.textColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        weak var weakSelf = self
        DispatchQueue.main.async {
            if Defaults[kUserToken] == nil{
                
                weakSelf?.present(loginOut(), animated: true) {
                    let tabbar = UIApplication.shared.keyWindow?.rootViewController as? LNMainTabBarController
                    tabbar?.selectedIndex = 0
                }
            }
        }
    }
    
    override func configSubViews() {
        navigaView.isHidden = true
        
        navigationView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: navHeight+169-64))
        navigationView.backgroundColor = UIColor(red: 0.96, green: 0.29, blue: 0.31, alpha: 1)
        self.view.addSubview(navigationView)
        
        let navtitleLabel = UILabel()
        //navtitleLabel.backgroundColor = UIColor.blue
        navtitleLabel.frame = CGRect(x: 0, y: kSCREEN_HEIGHT>800 ? 44:20, width: Int(kSCREEN_WIDTH), height: 44)
        navtitleLabel.text = "会员中心"
        navtitleLabel.textColor = .white
        navtitleLabel.textAlignment = .center
        navtitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navigationView.addSubview(navtitleLabel)
        navigationView.snp.makeConstraints { (ls) in
            ls.top.left.right.equalToSuperview()
            ls.height.equalTo(163)
        }
                
                //        配置UICollectionView
                let layout = UICollectionViewFlowLayout.init()
                //        滑动方向
                layout.scrollDirection = .vertical
             //        最小列间距
            layout.minimumInteritemSpacing = kSpace
             //        最小行间距
            layout.minimumLineSpacing = kSpace
        
                mainCollectionView = UICollectionView.init(
                    frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), collectionViewLayout: layout)
                mainCollectionView?.delegate = self
                mainCollectionView?.dataSource = self
        
                mainCollectionView?.register(UINib.init(nibName: "NextLevelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NextLevelCollectionViewCell)
        mainCollectionView?.register(UINib.init(nibName: "LevelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:LevelCollectionViewCellID)
          mainCollectionView?.register(UINib.init(nibName: "UpgradeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: UpgradeCollectionViewCell)
        //权益
        //mainCollectionView?.register(UINib.init(nibName: "LNSuperOptionsCell", bundle: nil), forCellWithReuseIdentifier: LNSuperOptionsCell)
        mainCollectionView?.register(superCollectionViewCell.self, forCellWithReuseIdentifier: superCollectionViewCellID)
        //推荐
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: LNMainFootCell)

              mainCollectionView?.register(UINib.init(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView)
        mainCollectionView?.register(UINib.init(nibName: "EquityheadCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: EquityheadCollectionReusableView)
        mainCollectionView?.register(UINib.init(nibName: "HotRecommendCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HotRecommendCollectionReusableView)
                self.view.addSubview(mainCollectionView!)
        
                mainCollectionView?.backgroundColor = .clear

        mainCollectionView?.snp.makeConstraints { (ls) in
            ls.width.bottom.left.equalToSuperview()
            ls.top.equalTo(navHeight)
        }
        
                self.view.isUserInteractionEnabled = true
        
        mainCollectionView?.showsVerticalScrollIndicator = false
        
    }
    
    func requestUserLevel(){
        let request = SKRequest.init()
        weak var weakSelf = self
        //LQLoadingView().SVPwillShowAndHideNoText1()
        request.setParam("level" as NSObject, forKey: "orderBy")
        request.setParam("asc" as NSObject, forKey: "sortedBy")
        request.setParam("status:1" as NSObject, forKey: "search")
        request.callGET(withUrl: LNUrls().kUserLevel) { (response) in
            
            DispatchQueue.main.async {
                LQLoadingView().SVPHide()
                if !(response?.success)! {
                    return
                }
                
                weakSelf?.maxLevel = JSON((response?.data["data"])!)["meta"]["pagination"]["total"].intValue
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                weakSelf?.resoruce.removeAll()
                for index in 0..<datas.count {
                    weakSelf?.resoruce.append(LNPartnerModel.setupValues(json: datas[index]))
                    
                    weakSelf?.mainCollectionView?.reloadData()
                }
            }
            
        }
    }
    
    func requestUserData(){
        let request = SKRequest.init()
        weak var weakSelf = self
        LQLoadingView().SVPwillShowAndHideNoText1()
        request.callGET(withUrl: LNUrls().kMember) { (response) in
            
            
            DispatchQueue.main.async {
                //LQLoadingView().SVPHide()
                //weakSelf?.mainTableView.mj_header.endRefreshing()
                if !(response?.success)! {
                    if (response?.code) == 4002 {
                        //weakSelf?.isPresented = false
                    }
                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"]
                weakSelf?.memberModel = LNMemberModel.setupValues(json: datas)
                weakSelf?.currentLevel = Int(weakSelf?.memberModel.level.level ?? "") ?? 1
                UserDefaults.standard.set(weakSelf?.memberModel.credit3, forKey: "credit3")
                // 同步
                UserDefaults.standard.synchronize()
                weakSelf?.requestUserLevel()
                weakSelf?.mainCollectionView?.reloadData()
            }
        }
    }
    
    override func requestData() {
        let request = SKRequest.init()

        weak var weakSelf = self

        request.setParam("557401664914" as NSObject, forKey: "itemid")

        //LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: LNUrls().kGuess_like) { (response) in
            //LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                weakSelf?.mainCollectionView?.mj_header.endRefreshing()

                if !(response?.success)! {
                    return
                }

                let datas =  JSON((response?.data["data"])!).arrayValue

                if datas.count>=0 {

                    for index in 0..<datas.count{
                        let json = datas[index]
                        let model = LNYHQListModel.setupValues(json: json)
                        weakSelf?.resourceArray.append(model)
                    }

                    if (weakSelf?.mainCollectionView?.mj_header.isRefreshing)! {
                        weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                    }
                }
                weakSelf?.mainCollectionView?.reloadData()
            }
        }
    }

    func signIn(){
        //LQLoadingView().SVPwillShowAndHideNoText()
        let request = SKRequest.init()
        request.callGET(withUrl: kSignin) { (response) in
           // LQLoadingView().SVPHide()
            if !(response?.success)! {
               
                setToast(str: response?.message ?? "")
                return
            }
            setToast(str: response?.message ?? "")
           
        }
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
        requestUserData()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY =  scrollView.contentOffset.y
                if offSetY>0  {
                     navigationView.isHidden = true
                     navigaView.isHidden = false
                     backBtn.isHidden = true
                     titleLabel.textColor = .white
                     titleLabel.text = "会员中心"
                }else{
                     navigationView.isHidden = false
                     navigaView.isHidden = true
        }

    }

}
extension MG_MemberCenterViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.resoruce.count == 0 {
            return 0
        }else{
           return 4
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section==1 {
            if self.resoruce.count>=self.currentLevel{
                if currentIndex == 100 {
                    return self.resoruce[currentLevel-1].privileges.count
                }else{
                    return self.resoruce[currentIndex].privileges.count
                }
            }else{
                return 0
            }
            
            
        }else if(section==3){
            return self.resourceArray.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section==0 {
            let cell:LevelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCollectionViewCellID, for: indexPath) as! LevelCollectionViewCell
            if currentIndex == 100 {
                cell.setValues(models: resoruce, current: self.currentLevel-1, memberModel: memberModel)
            }else{
                cell.setValues(models: resoruce, current: self.currentIndex, memberModel: memberModel)
            }
//            cell.setValues(models: resoruce, current: self.currentLevel, memberModel: memberModel)
            let maskPath1 = UIBezierPath.init(roundedRect: cell.bounds, byRoundingCorners: [UIRectCorner.bottomRight,UIRectCorner.bottomLeft], cornerRadii:CGSize(width: 12, height: 12))
            let maskLayer1 = CAShapeLayer.init()
            maskLayer1.frame = cell.bounds
            maskLayer1.path = maskPath1.cgPath
            cell.layer.mask = maskLayer1
            cell.clipsToBounds = true

            weak var weakSelf = self
            cell.callBackBlock { (tag) in
                print(weakSelf?.resoruce[tag].name as Any)
                weakSelf?.currentLevel = tag+1
                weakSelf?.mainCollectionView?.reloadData()
                weakSelf?.currentIndex = tag
            }
            return cell
        }else if(indexPath.section == 2){
            let cell:UpgradeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UpgradeCollectionViewCell, for: indexPath) as! UpgradeCollectionViewCell
            weak var weakSelf = self
            cell.callBackBlock { (tag) in
                if tag == 998{
                   //调用签到接口
//                    self.signIn()
                    weakSelf?.requestData()
                }else if(tag == 999){
                //跳转到首页
                    //self.navigationController?.pushViewController(LNPageViewController(), animated: true)
                    //self.tabBarController?.selectedIndex = 1;
                   //self.viewContainingController()!.tabBarController?.selectedIndex = 1
                    let tabbar = UIApplication.shared.keyWindow?.rootViewController as? LNMainTabBarController
                    tabbar?.selectedIndex = 0
                }else{
                 //跳转到个人中心邀请
                    let inviteVC = LQInvitesViewController()
                    inviteVC.inviteCode = self.memberModel.hashid
                    weakSelf?.navigationController?.pushViewController(inviteVC, animated: true)
                    //self.navigationController?.pushViewController(LQInvitesViewController(), animated: true)
                }
                print(tag)
            }
            return cell;
        }else if(indexPath.section == 1){
            let cell:superCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: superCollectionViewCellID, for: indexPath) as! superCollectionViewCell
            
//                for index1 in 0..<self.resoruce[self.currentLevel-1].privileges.count{
//                    let dic:Dictionary<String,Any>  = ["Privillogo":self.resoruce[self.currentLevel-1].privileges[index1].logo,
//                                                       "Privilname":self.resoruce[self.currentLevel-1].privileges[index1].name]
//
//
//                    cell.entranceDic = dic
//                    cell.tag = index1
//                }
            if currentIndex == 100 {
                let dic:Dictionary<String,Any>  = ["Privillogo":self.resoruce[self.currentLevel-1].privileges[indexPath.row].logo,
                                                   "Privilname":self.resoruce[self.currentLevel-1].privileges[indexPath.row].name]
                
                cell.entranceDic = dic
                cell.tag = indexPath.row
            }else{
                let dic:Dictionary<String,Any>  = ["Privillogo":self.resoruce[self.currentIndex].privileges[indexPath.row].logo,
                                                   "Privilname":self.resoruce[self.currentIndex].privileges[indexPath.row].name]
                
                cell.entranceDic = dic
                cell.tag = indexPath.row
            }

            return cell;
        }else{
            let cell:LNMainFootCell = collectionView.dequeueReusableCell(withReuseIdentifier: LNMainFootCell, for: indexPath) as! LNMainFootCell
            cell.model2 = resourceArray[indexPath.row]
            return cell;
        }
//        let cell:NextLevelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NextLevelCollectionViewCell, for: indexPath) as! NextLevelCollectionViewCell
//
//        if resoruce.count>0 {
//            if self.maxLevel == Int(self.memberModel.level.level){
//                print("当前级别最高")
//                cell.theNextLevelLabelStr(level:"当前等级已是最高级", lastModel: resoruce.last, member: memberModel)
//            }else{
//                if currentIndex == 100 {
//                    cell.setValues(model: resoruce[self.currentLevel], member: memberModel)
//                    cell.theNextLevelLabelStr(level:resoruce[self.currentLevel].name, lastModel: nil, member: memberModel)
//                }else{
//                    cell.setValues(model: resoruce[self.currentIndex], member: memberModel)
//                    cell.theNextLevelLabelStr(level:resoruce[self.currentIndex].name, lastModel: nil, member: memberModel)
//                }
//            }
//        }
//            return cell
 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section==0 {
            var height:CGFloat = 282
            if currentIndex == 100 {
                if Int(memberModel.level.level)! >= Int(resoruce[currentLevel-1].level)! {
                    height = 282-55
                }
            }else{
                if Int(memberModel.level.level)! >= Int(resoruce[currentIndex].level)! {
                    height = 282-55
                }
            }
         return CGSize(width: kSCREEN_WIDTH-20, height: height)
        }else if(indexPath.section == 1){
            return CGSize(width: kSCREEN_WIDTH/3, height: 130)
        }else if(indexPath.section==3){
            return CGSize(width: (kSCREEN_WIDTH-kSpace-22)/2, height: 273)
        }
        
        return CGSize(width: kSCREEN_WIDTH-20, height: 179)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader
        {
            if indexPath.section==1 {
               reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EquityheadCollectionReusableView, for: indexPath)
            
            }else if(indexPath.section==3){
                reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HotRecommendCollectionReusableView, for: indexPath)
            }
        }
        else if kind == UICollectionElementKindSectionFooter
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCollectionReusableView, for: indexPath)

        }
        
        return reusableview!
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kSCREEN_WIDTH, height: 19)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section==1 {
            return CGSize(width: kSCREEN_WIDTH, height: 44)
        }else if section == 3{
             return CGSize(width: kSCREEN_WIDTH, height: 45)
        }
        return CGSize(width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            collectionView.deselectItem(at: indexPath, animated: true)
            let detailVc = SZYGoodsViewController()
            detailVc.good_item_id = resourceArray[indexPath.row].item_id
            detailVc.coupone_type = resourceArray[indexPath.row].type
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 3 {
            return UIEdgeInsets(top: 0, left: 11, bottom: 10, right: 11)
        }
        if section == 1 {
            return UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
    }
}


