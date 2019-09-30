//
//  LNDetailGuessLikeCell.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/23.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNDetailGuessLikeCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //    cell之间的距离
    fileprivate let kSpace:CGFloat = 0
    //    cell的高度
    fileprivate let kHeight:CGFloat = 260

    fileprivate var mainCollectionView:UICollectionView?
    let identyfierTable  = "identyfierTable1"
    
    fileprivate var resource = [LNYHQListModel]()
    var newResourct = [SZYGoodsInformationModel]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
//        layout.scrollDirection = .vertical
        layout.scrollDirection = .horizontal
        //        最小列间距
        layout.minimumInteritemSpacing = 10
        //        最小行间距
        layout.minimumLineSpacing = 5
        
        mainCollectionView = UICollectionView.init(
            frame: CGRect(x: 0, y: -kStatusBarH, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT+kStatusBarH-49), collectionViewLayout: layout)
        mainCollectionView?.delegate = self
        mainCollectionView?.dataSource = self
//        mainCollectionView?.isScrollEnabled = false
        mainCollectionView?.register(UINib.init(nibName: "LNMainFootCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
//        mainCollectionView?.isScrollEnabled = false
        bgView.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false
        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setGuessLikeData(models:[LNYHQListModel]) {
        
        var lines = models.count/2
        if models.count%2 != 0{
            lines = lines+1
        }
        viewHeight.constant = CGFloat(lines)*(kHeight+kSpace)+20
        resource = models
        mainCollectionView?.reloadData()
    }
    func setUpData(models:[SZYGoodsInformationModel]) {
        var lines = models.count / 2
        if models.count % 2 != 0{
            lines = lines+1
        }
        viewHeight.constant = kHeight //CGFloat(lines)*(kHeight+kSpace)+20
        newResourct = models
        mainCollectionView?.reloadData()
    }
}
    
extension LNDetailGuessLikeCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return resource.count
        return newResourct.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNMainFootCell
//        cell.model2 = resource[indexPath.row]
        cell.model1 = newResourct[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailVc = SZYGoodsViewController()
        detailVc.good_item_id = newResourct[indexPath.row].item_id
        detailVc.coupone_type = newResourct[indexPath.row].type
        detailVc.goodsUrl = newResourct[indexPath.row].pic_url
        detailVc.GoodsInformationModel = newResourct[indexPath.row]
        viewContainingController()?.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        return CGSize(width: (kSCREEN_WIDTH-kSpace-22)/2, height: kHeight)
        return CGSize.init(width: (kSCREEN_WIDTH - 50) / 2, height: kHeight)
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 11, left: 11, bottom: 10, right: 11)
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

}
