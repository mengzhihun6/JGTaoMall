//
//  LNNewHeadCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

class LNNewHeadCell: UITableViewCell {

    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var theBgView: UIView!
    
    @IBOutlet weak var zhishiView: UIView!
    @IBOutlet weak var locationView: UIView!
    fileprivate var theView = UIView.init()
    @IBOutlet weak var noticeView: UIView!
    
    @IBOutlet weak var bannerView2: UIView!
    
    fileprivate var banner = ADView()
    fileprivate var banner2 = ADView()
    fileprivate var banners = [LNBannersModel]()
    fileprivate var banners2 = [LNBannersModel]()

    fileprivate var resource = [LNSuperDetailModel]()

    @IBOutlet weak var adsView: GYRollingNoticeView!
    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    let identyfierTable  = "identyfierTable1"

    
    fileprivate var adsModels = [LNMainAdsModel]()

//    var itmeArray = [[String](),[String]()]
    var itmeImageArray = [String]()
    var itmeTitleArray = [String]()
    
    
    @IBOutlet weak var bobaoViewTop: NSLayoutConstraint!
    @IBOutlet weak var bobaoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var guanggaoViewTop: NSLayoutConstraint!
    @IBOutlet weak var guanggaoViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itmeImageArray = ["", "", "", "", "", "", "", ""]
        itmeTitleArray = ["淘宝", "天猫", "聚划算", "淘宝超市", "天猫国际", "淘抢购", "限时秒杀", "飞猪旅行"]
        
        bobaoViewTop.constant = 0
        bobaoViewHeight.constant = 0
        guanggaoViewTop.constant = 0
        guanggaoViewHeight.constant = 0
        
        zhishiView.cornerRadius = zhishiView.height/2
        zhishiView.clipsToBounds = true
        locationView.removeFromSuperview()
//        locationView.cornerRadius = locationView.height/2
//        locationView.clipsToBounds = true

        noticeView.cornerRadius = noticeView.height/2
        noticeView.clipsToBounds = true
        
        theBgView.cornerRadius = 8
        theBgView.clipsToBounds = true
        
        bannerView2.cornerRadius = 8
        bannerView2.clipsToBounds = true
        
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .horizontal
        
        //        最小列间距
        layout.minimumInteritemSpacing = 0.5
        //        最小行间距
        layout.minimumLineSpacing = 0.5
        
        mainCollectionView = UICollectionView.init(
            frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-49), collectionViewLayout: layout)
        //        mainCollectionView?.height = kSCREEN_HEIGHT-CGFloat(navHeight)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNSuperOptionsCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        
        buttonsView.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = UIColor.white
        
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false

        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })
        buildUrlData(models: banners)
//        let request = SKRequest.init()   //获取轮播图
//        request.setParam("tag:banner;status:1" as NSObject, forKey: "search")
//        request.setParam("sort" as NSObject, forKey: "orderBy")
//        request.setParam("desc" as NSObject, forKey: "sortedBy")
//        request.setParam("and" as NSObject, forKey: "searchJoin")
        weak var weakSelf = self
//        request.callGET(withUrl: LNUrls().kBanner) { (response) in
//            if !(response?.success)! {
//                return
//            }
//            DispatchQueue.main.async {
//                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
//                weakSelf?.banners.removeAll()
//                for index in 0..<datas.count{
//                    weakSelf?.banners.append(LNBannersModel.setupValues(json: datas[index]))
//                }
//                weakSelf?.buildUrlData(models: (weakSelf?.banners)!)
//            }
//        }
        
        let request2 = SKRequest.init()
        request2.callGET(withUrl: BaseUrl+"/taoke/entrance?search=status:1;is_home:1&searchJoin=and&sortedBy=desc&orderBy=sort") { (response) in
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"]
                weakSelf?.resource.removeAll()
//                for index in 0..<datas.count{
//                    weakSelf?.resource.append(LNSuperDetailModel.setupValues(json: datas[index]))
//                }
                 weakSelf?.resource = LNSuperDetailModel.setValue(json: datas)
                weakSelf?.zhishi()
                weakSelf?.mainCollectionView?.reloadData()
            }
        }


        
        let request3 = SKRequest.init()
        request3.callGET(withUrl: BaseUrl+"/image/banner?search=tag:ads;status:1&searchJoin=and&orderBy=sort&sortedBy=desc") { (response) in
            if !(response?.success)! {
                return
            }
            DispatchQueue.main.async {
                let datas =  JSON((response?.data["data"])!)["data"]
                
                var bannerArr = [LNBannersModel]()
                
                for index in 0..<datas.count{
                    bannerArr.append(LNBannersModel.setupValues(json: datas[index]))
                }
                weakSelf?.buildBannerUrlData(models: bannerArr)
            }
        }
        
        self.contentView.backgroundColor = kSetRGBAColor(r: 0, g: 0, b: 0, a: 0)

        
//        adsView.reloadDataAndStartRoll()
        
//        weakSelf?.adsView.reloadDataAndStartRoll()
        
//        let request4 = SKRequest.init()
//        request4.callGET(withUrl: LNUrls().kRandom) { (response) in
//            if !(response?.success)! {
//                return
//            }
//            DispatchQueue.main.async {
//                let datas =  JSON((response?.data["data"])!)["user"].arrayValue
//
//                for index in 0..<datas.count{
//                    let model = LNMainAdsModel()
//                    model.nickname = datas[index]["nickname"].stringValue
//                    model.id = datas[index]["id"].stringValue
//                    weakSelf?.adsModels.append(model)
//                }
//                weakSelf?.adsView.delegate = self
//                weakSelf?.adsView.dataSource = self
//                weakSelf?.adsView.stayInterval = 4
//                weakSelf?.adsView.register(UINib.init(nibName: "GYNoticeViewCell", bundle: nil), forCellReuseIdentifier: "GYNoticeViewCell")
//                weakSelf?.adsView.reloadDataAndStartRoll()
//            }
//        }
    }
    
    func zhishi() {
        let count = resource.count
        var row = count / 2
        if count % 2 > 0 {
            row = count / 2 + 1
        }
        let scale = 4 / CGFloat(row)
        theView.frame = CGRect(x: 0, y: 0, width: zhishiView.width * scale, height: 5)
        theView.backgroundColor = kGaryColor(num: 85)
        theView.cornerRadius = theView.height / 2
        theView.clipsToBounds = true
        zhishiView.addSubview(theView)
    }
    
    func buildUrlData(models:[LNBannersModel]) {
        banner.removeFromSuperview()
        
        var imageUrls =  NSMutableArray.init()
//
//        for model in models {
//            imageUrls.add(model.image)
//        }
        imageUrls = ["http://keezan.iwxapp.com/banner3.jpg", /*"http://keezan.iwxapp.com/banner2.png",*/ "http://keezan.iwxapp.com/fdhfdhdhdfhdfhdfh.png"]
        banner = ADView.init(
            frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: bannerView.height),
            andImageURLArray: imageUrls)
        
        weak var weakSelf = self
        banner.block = {
            kDeBugPrint(item: $0)
            
            let index = Int($0!)!-1
//            let model = models[index]
//
//            let WebVC = LQWebViewController()
//            WebVC.webTitle = "详情"
//            WebVC.webUrl = model.url
//            let vc = weakSelf?.viewContainingController() as? LNNewMainViewController
//            vc?.superViewController?.navigationController?.pushViewController(WebVC, animated: true)
            let nvc = SZYBannerViewController()
            if index == 0 {
                nvc.titleString = "母婴专场"
                nvc.SZYTypeString = "母婴"
            } else if index == 1 {
                nvc.titleString = "吃货专场"
                nvc.SZYTypeString = "零食"
            }
            let vc = weakSelf?.viewContainingController() as? LNNewMainViewController
            vc?.superViewController?.navigationController?.pushViewController(nvc, animated: true)
        }
        
//        banner.changeBlock = {
////            这个是d轮播图定时器再运行的时候的回调，用于改变首页背景色
//            let index = Int($0!)!-1
//            if models.count>index && index>=0{
//                let model = models[index]
//
//                let vc = weakSelf?.viewContainingController() as? LNNewMainViewController
//
//                UIView.animate(withDuration: 0.5) {
//                    vc?.superViewController!.headBottomImage.backgroundColor = OCTools.color(withHexString: model.color)
//                }
//            }
//        }
        
        bannerView.addSubview(banner)
        
        banner.snp.makeConstraints { (ls) in
            ls.left.right.top.bottom.equalToSuperview()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func buildBannerUrlData(models:[LNBannersModel]) {
        banner2.removeFromSuperview()
        
        let imageUrls =  NSMutableArray.init()
        
        for model in models {
            imageUrls.add(model.image)
        }
        
        banner2 = ADView.init(frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: bannerView2.height), andImageURLArray: imageUrls, andIsRunning: false)
        
        weak var weakSelf = self
        banner2.block = {
            kDeBugPrint(item: $0)
            
            let index = Int($0!)!-1
            let model = models[index]

            let WebVC = LQWebViewController()
            WebVC.webTitle = "详情"
            WebVC.webUrl = model.url
            let vc = weakSelf?.viewContainingController() as? LNNewMainViewController
            vc?.superViewController?.navigationController?.pushViewController(WebVC, animated: true)

        }
        bannerView2.addSubview(banner2)
        
        banner2.snp.makeConstraints { (ls) in
            ls.left.right.top.bottom.equalToSuperview()
        }
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = (scrollView.mj_offsetX)/(mainCollectionView?.contentSize.width)!
//        print(offsetY)
        
        theView.x = offsetY*zhishiView.width
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension LNNewHeadCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LNSuperOptionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNSuperOptionsCell
        cell.setValues(model: resource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = viewContainingController() as? LNNewMainViewController

        if resource[indexPath.row].type == "1" {
//            let WebVC = CSStoreWebViewController()
//            WebVC.webTitle = resource[indexPath.row].title
//            WebVC.webUrl = resource[indexPath.row].url
//            vc?.superViewController?.navigationController?.pushViewController(WebVC, animated: true)
            var pageUrl = resource[indexPath.row].url
            if Defaults[kUserToken] != nil && Defaults[kUserToken] != "" {
                if !pageUrl.contains(Defaults[kUserToken]!) {
                    if !pageUrl.contains("?") {
                        pageUrl = "\(pageUrl)?token=\(Defaults[kUserToken]!)"
                    } else {
                        pageUrl = "\(pageUrl)&token=\(Defaults[kUserToken]!)"
                    }
                }
            }
            
            let page = AlibcTradePageFactory.page(pageUrl)
            let taoKeParams = AlibcTradeTaokeParams.init()
            taoKeParams.pid = nil
            let showParam = AlibcTradeShowParams.init()
            showParam.openType = .auto
            let myView = SZYwebViewViewController.init()
            myView.webTitle = resource[indexPath.row].title
            let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
                kDeBugPrint(item: "======11111=======")
            }, tradeProcessFailedCallback: { (error) in
                kDeBugPrint(item: error)
            })
            if (ret == 1) {
                vc?.superViewController?.navigationController?.pushViewController(myView, animated: true)
            }
        }else{
//            这里也问牛哥，他知道具体的逻辑
            switch resource[indexPath.row].url {
            case "qianggou":
                vc?.superViewController?.navigationController?.pushViewController(LNMiaoshaViewController(), animated: true)
            case "taobao":
                let resultVc = LNTypeGoodsiewController()
                resultVc.type = "1"
                vc?.superViewController?.navigationController?.pushViewController(resultVc, animated: true)
            case "jingdong":
                let resultVc = LNTypeGoodsiewController()
                resultVc.type = "2"
                vc?.superViewController?.navigationController?.pushViewController(resultVc, animated: true)
            case "pinduoduo":
                let resultVc = LNTypeGoodsiewController()
                resultVc.type = "3"
                vc?.superViewController?.navigationController?.pushViewController(resultVc, animated: true)
            default:
                break
            }
        }
        
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (buttonsView.width)/4, height: buttonsView.height/2-0.5)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var bottom :CGFloat = 0
        if section > 0 {
            bottom = 5
        }
        return UIEdgeInsets(top: bottom, left: 0, bottom: 0, right: 0)
    }
    
}


extension LNNewHeadCell : GYRollingNoticeViewDataSource,GYRollingNoticeViewDelegate {
    func numberOfRows(for rollingView: GYRollingNoticeView!) -> Int {
        if adsModels.count == 0 {
            return 1
        }else{
            return adsModels.count
        }
    }
    
    func rollingNoticeView(_ rollingView: GYRollingNoticeView!, cellAt index: UInt) -> GYNoticeViewCell! {
        let cell = rollingView.dequeueReusableCell(withIdentifier: "GYNoticeViewCell")
        let randomNumber:Int = Int(arc4random() % 8) + 1
        
        let randomNumber2:Int = Int(arc4random() % 5) + 1
        let randomNumber3:Int = Int(arc4random() % 100) + 1
        
        let str1 = String(randomNumber2)
        let str2 = String(randomNumber3)
        
        var name = "我有一颗糖"
        if adsModels.count>0 {
            name = adsModels[Int(index)].nickname
        }
        let min = " "+String(randomNumber) + "分钟前获得分享佣金 "
        let money = str1+"."+str2+"元"

        cell?.textLabel.text = name
        cell?.textLabel2.text = min
        cell?.textLabel3.text = money

//        cell?.setValues(name, andText: min, andMoney: money)
//
//        let content =  name + min + money
//
//        let attributeText1 = NSMutableAttributedString.init(string: content)
//        attributeText1.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11)], range: NSMakeRange(0, content.count))
//        attributeText1.addAttributes([NSAttributedStringKey.foregroundColor: kMainColor()], range: NSMakeRange(0, name.count))
//        attributeText1.addAttributes([NSAttributedStringKey.foregroundColor: kGaryColor(num: 100)], range: NSMakeRange(name.count, min.count))
//        attributeText1.addAttributes([NSAttributedStringKey.foregroundColor: kMainColor()], range: NSMakeRange((name+min).count, money.count))
//        cell?.textLabel.attributedText = attributeText1
        return cell
    }
}

class LNMainAdsModel: NSObject {
    var nickname = String()
    var id = String()
}
