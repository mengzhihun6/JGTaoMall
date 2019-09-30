//
//  SZYItemSelectedViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/1/27.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import DeviceKit
import SwiftyUserDefaults
import SwiftyJSON
import MJRefresh


class SZYItemSelectedViewController: LNBaseViewController {
    
    var mainCollectionView : UICollectionView!
    var model = LNSuperMainModel()
    
    var type : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigaView.isHidden = true
    }
    override func configSubViews() {
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = 0.5
        //        最小行间距
        layout.minimumLineSpacing = 0.5
        
        var heght = navHeight
        kDeBugPrint(item: kSCREEN_HEIGHT)
        kDeBugPrint(item: Device())
        if kSCREEN_HEIGHT >= 812 {
            heght = navHeight + 30
        }
        
        mainCollectionView = getCollectionView(frame: CGRect(x: 0, y: 50, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - 50 - heght - 49), style: layout, vc: self)
        mainCollectionView.backgroundColor = UIColor.white
        mainCollectionView.register(UINib.init(nibName: "LNSuperOptionsCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        view.addSubview(mainCollectionView)
        glt_scrollView = mainCollectionView
        
        if #available(iOS 11.0, *) {
            glt_scrollView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}



extension SZYItemSelectedViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.entrance.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LNSuperOptionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNSuperOptionsCell
        cell.setValues(model: model.entrance[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        let WebVC = CSStoreWebViewController()
//        WebVC.webTitle = model.entrance[indexPath.row].title
//        WebVC.webUrl = model.entrance[indexPath.row].url
//        self.navigationController?.pushViewController(WebVC, animated: true)
        var pageUrl = model.entrance[indexPath.row].url
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
        myView.webTitle = model.entrance[indexPath.row].title
        
        
        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.open(byUrl: pageUrl, identity: "trade", webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (back) in
            
        }, tradeProcessFailedCallback: { (error) in
            
        })
        
//        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.open(byBizCode: "shop", page: page, webView: myView.webView, parentController: myView, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (back) in
//
//        }, tradeProcessFailedCallback: { (error) in
//
//        })
        
        
        
//        let ret = AlibcTradeSDK.sharedInstance()?.tradeService()?.show(myView, webView: myView.webView, page: page, showParams: showParam, taoKeParams: taoKeParams, trackParam: nil, tradeProcessSuccessCallback: { (ls) in
//            kDeBugPrint(item: "======11111=======")
//        }, tradeProcessFailedCallback: { (error) in
//            kDeBugPrint(item: error)
//        })
        
        
        
        if (ret == 1) {
            self.navigationController?.pushViewController(myView, animated: true)
        }
        
    }
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kSCREEN_WIDTH-0.5*5)/4, height: 100)
    }
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
