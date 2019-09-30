//
//  LNLikeTheItemViewController.swift
//  CabbageShop
//
//  Created by 宋宗宇 on 2019/3/12.
//  Copyright © 2019 付耀辉. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SwiftyUserDefaults

class LNLikeTheItemViewController: LNBaseViewController {
    
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 8
    //    cell的高度
    fileprivate let kHeight:CGFloat = 255
    fileprivate var mainCollectionView:UICollectionView?
    //    数据源
    var GoodsInformationModel = [SZYGoodsInformationModel]() //商品信息
    
    var superViewController : UIViewController?
    
    var item_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addFooterRefresh()
    }
    override func configSubViews() {
        navigationTitle = "猜你喜欢"
        titleLabel.textColor = UIColor.white
//        navigationBgImage = UIImage.init(named: "Rectangle")
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: navHeight, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-navHeight), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        
        self.view.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
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
        if GoodsInformationModel.count > 0 {
            let randomNumber:Int = Int(arc4random() % UInt32(GoodsInformationModel.count))
            if randomNumber + 1 > GoodsInformationModel.count || randomNumber <= 0 {
                
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
                    weakSelf?.GoodsInformationModel.removeAll()
                }
                for index in 0..<datas.count{
                    let json = datas[index]
                    weakSelf?.GoodsInformationModel.append(SZYGoodsInformationModel.setupValues(json: json))
                }
                weakSelf?.mainCollectionView?.reloadData()
            }
        }
    }
    
    
    
    
}
extension LNLikeTheItemViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GoodsInformationModel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainFootCell
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
