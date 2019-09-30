//
//  LNMainLayoutCell1.swift
//  CabbageShop
//
//  Created by 付耀辉 on 2018/12/20.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNMainLayoutCell1: UITableViewCell {

    @IBOutlet weak var goodsView: UIView!
    @IBOutlet weak var beView: UIImageView!
    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    //        配置UICollectionView
    let layout = UICollectionViewFlowLayout.init()

    let identyfierTable  = "identyfierTable1"
    
    let kSpace:CGFloat = 6
    
    fileprivate var resource = [LNMainChildreModel]()
    
    @IBOutlet weak var goodsHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
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
        
        mainCollectionView?.register(UINib.init(nibName: "LNLayout1SubCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identyfierTable)
        
        goodsView.addSubview(mainCollectionView!)
//        mainCollectionView?.backgroundColor = kSetRGBColor(r: 180, g: 45, b: 45)
        mainCollectionView?.backgroundColor = UIColor.clear

        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false

        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.equalToSuperview().offset(11)
            ls.right.equalToSuperview().offset(-11)
            ls.top.equalToSuperview().offset(11)
            ls.bottom.equalToSuperview().offset(-11)
        })
        mainCollectionView?.isScrollEnabled = false
    }

    func setDatas(model:LNNewMainLayoutModel) {
        resource = model.children
        
        if resource.count<3 {
            goodsHeight.constant = 258/2
        }else{
            goodsHeight.constant = 258
        }
        
        mainCollectionView?.reloadData()
        beView.sd_setImage(with: OCTools.getEfficientAddress(model.bgimg), placeholderImage: UIImage.init(named: "goodImage_1"))
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension LNMainLayoutCell1:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LNLayout1SubCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNLayout1SubCellCollectionViewCell
        cell.cornerRadius = 4
        cell.clipsToBounds = true
        cell.setImageValue(imageUrl: resource[indexPath.row].thumb)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
      
        let vc = viewContainingController() as? LNNewMainViewController

        if resource[indexPath.row].layout2 == "1" {
            let listVc = LNOtherListViewController2()
            let model = LNNewMainLayoutModel()
            model.list_thumb = resource[indexPath.row].list_thumb
            model.name = resource[indexPath.row].name
            model.params = resource[indexPath.row].params
            
            listVc.model = model
            vc?.superViewController?.navigationController?.pushViewController(listVc, animated: true)
        }else{
            let listVc = LNOtherListViewController()
            let model = LNNewMainLayoutModel()
            model.list_thumb = resource[indexPath.row].list_thumb
            model.name = resource[indexPath.row].name
            model.params = resource[indexPath.row].params
            
            listVc.model = model
            vc?.superViewController?.navigationController?.pushViewController(listVc, animated: true)
        }

    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = goodsHeight.constant
        if height > 200 {
            return CGSize(width: (goodsView.width-kSpace*5)/2, height: (goodsView.height-kSpace-22)/2)
        }else{
            return CGSize(width: (goodsView.width-kSpace*5)/2, height: (goodsView.height-kSpace-22))

        }
    }
    
    //    每个section的缩进
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
