//
//  LNMainLayoutCell2.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit
import SwiftyJSON
class LNMainLayoutCell2: UITableViewCell {

    
    @IBOutlet weak var theTitle: UILabel!
    
    @IBOutlet weak var showMore: UIButton!
    
    @IBOutlet weak var goodsView: UIView!
    
    @IBOutlet weak var bgImage: UIImageView!
    
    
    fileprivate var mainCollectionView:UICollectionView?
    let identyfierTable  = "identyfierTable1"
    
    let kSpace:CGFloat = 6
    
    
    fileprivate var resource = [LNYHQListModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        showMore.layoutButton(with: .right, imageTitleSpace: 5)
        
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .horizontal
        
        //        最小列间距
        layout.minimumInteritemSpacing = kSpace
        //        最小行间距
        layout.minimumLineSpacing = kSpace
        
        mainCollectionView = UICollectionView.init(
            frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-49), collectionViewLayout: layout)
        //        mainCollectionView?.height = kSCREEN_HEIGHT-CGFloat(navHeight)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
        
        mainCollectionView?.register(UINib.init(nibName: "LNMainShowHotCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        
        goodsView.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = UIColor.clear
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false
        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })

        
    }

    var myModel = LNNewMainLayoutModel()
    
    func setTitle(model:LNNewMainLayoutModel) {
        myModel = model
        
        bgImage.sd_setImage(with: OCTools.getEfficientAddress(model.bgimg), placeholderImage: UIImage.init(named: "goodImage_1"))
        
        theTitle.text = model.name
        if resource.count>0 {
            return
        }
        let request = SKRequest.init()
        weak var weakSelf = self
        request.setParam(model.limit as NSObject, forKey: "limit")
        request.callGET(withUrl: LNUrls().kSwhow_coupon+"?"+model.params) { (response) in
            DispatchQueue.main.async {
                if !(response?.success)! {
                    return
                }
                let datas =  JSON((response?.data["data"])!)["data"].arrayValue
                weakSelf?.resource.removeAll()
                for index in 0..<datas.count{
                    let json = datas[index]
                    let model = LNYHQListModel.setupValues(json: json)
                    weakSelf?.resource.append(model)
                }
                weakSelf?.mainCollectionView!.reloadData()
            }
        }
    }
    
    
    @IBAction func showMoreAction(_ sender: UIButton) {
        let vc = viewContainingController() as? LNNewMainViewController
        
        if myModel.layout2 == "1" {
            let listVc = LNOtherListViewController2()
            listVc.model = myModel
            vc?.superViewController?.navigationController?.pushViewController(listVc, animated: true)
        }else{
            let listVc = LNOtherListViewController()
            listVc.model = myModel
            vc?.superViewController?.navigationController?.pushViewController(listVc, animated: true)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension LNMainLayoutCell2:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LNMainShowHotCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainShowHotCell
        cell.model = resource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = viewContainingController() as? LNNewMainViewController

        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = resource[indexPath.row].item_id
        detailVc.coupone_type = resource[indexPath.row].type
        vc?.superViewController?.navigationController?.pushViewController(detailVc, animated: true)

    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (kSCREEN_WIDTH)/3-10, height: goodsView.height)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    }
    
}
