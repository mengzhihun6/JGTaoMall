//
//  LNGuessLikeViewController.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/22.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SwiftyUserDefaults

class LNGuessLikeViewController: LNBaseViewController {

    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 8
    //    cell的高度
    fileprivate let kHeight:CGFloat = 255
    fileprivate var mainCollectionView:UICollectionView?
    //    数据源
    fileprivate var resource = [LNYHQListModel]()
    var GoodsInformationModel = [SZYGoodsInformationModel]() //商品信息

    var superViewController : UIViewController?
    
    var item_id = String()
    
    let str = "566488024762"
    var topBun = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        addFooterRefresh()

        // Do any additional setup after loading the view.
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
        
        var top = navHeight+20
        //        if kSCREEN_HEIGHT>700 {
        //            top = navHeight+10
        //        }
        if kSCREEN_HEIGHT>800 {
            top = navHeight+35
        }

        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: top-3, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight-10-64), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        if Defaults[kGetTheRandomItemId] != nil {
            item_id = Defaults[kGetTheRandomItemId]!
        } else {
            item_id = str
        }
        
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

    override func requestData() {
        let request = SKRequest.init()
        
        weak var weakSelf = self
        
//        if resource.count>0 {
//            let randomNumber:Int = Int(arc4random() % UInt32(resource.count))
//            if randomNumber+1>resource.count || randomNumber <= 0 {
//                item_id = str
//            }else{
//                item_id = resource[randomNumber].item_id
//            }
//        }
        if GoodsInformationModel.count > 0 {
            let randomNumber:Int = Int(arc4random() % UInt32(GoodsInformationModel.count))
            if randomNumber + 1 > GoodsInformationModel.count || randomNumber <= 0 {
                item_id = str
            } else {
                item_id = GoodsInformationModel[randomNumber].item_id
            }
        }
        request.setParam(item_id as NSObject, forKey: "itemid")
        
        LQLoadingView().SVPwillShowAndHideNoText()
        request.callGET(withUrl: LNUrls().kGuess_like) { (response) in
            LQLoadingView().SVPHide()
            DispatchQueue.main.async {
                weakSelf?.mainCollectionView?.mj_header.endRefreshing()
                weakSelf?.mainCollectionView?.mj_footer.endRefreshing()
                
                if !(response?.success)! {
                    return
                }
                
                let datas =  JSON((response?.data["data"])!).arrayValue
                
                if weakSelf?.currentPage == 1 {
//                    weakSelf?.resource.removeAll()
                    weakSelf?.GoodsInformationModel.removeAll()
                }
                for index in 0..<datas.count{
                    let json = datas[index]
                    let model = LNYHQListModel.setupValues(json: json)
                    weakSelf?.resource.append(model)
                    weakSelf?.GoodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: json))
                }
                weakSelf?.mainCollectionView?.reloadData()
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.mj_offsetY > 600 {
            topBun.isHidden = false
        } else {
            topBun.isHidden = true
        }
    }
}

extension LNGuessLikeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return resource.count
        return GoodsInformationModel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainFootCell
//        cell.model2 = resource[indexPath.row]
        cell.model1 = GoodsInformationModel[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = GoodsInformationModel[indexPath.row].item_id
        detailVc.coupone_type = GoodsInformationModel[indexPath.row].type
        detailVc.goodsUrl = GoodsInformationModel[indexPath.row].pic_url
        detailVc.GoodsInformationModel = GoodsInformationModel[indexPath.row]
        superViewController?.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (kSCREEN_WIDTH-kSpace-22)/2, height: kHeight)
    }

    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 11, left: 11, bottom: 10, right: 11)
    }

}
