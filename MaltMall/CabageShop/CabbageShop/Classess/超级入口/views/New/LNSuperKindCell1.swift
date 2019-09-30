//
//  LNSuperKindCell1.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/26.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNSuperKindCell1: UITableViewCell {

    @IBOutlet weak var theTitle: UILabel!
    
    @IBOutlet weak var collecView: UIView!
    

    fileprivate var resource = LNSuperMainModel()
    
    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    let identyfierTable  = "identyfierTable1"




    override func awakeFromNib() {
        super.awakeFromNib()
        //        配置UICollectionView
        let layout = UICollectionViewFlowLayout.init()
        //        滑动方向
        layout.scrollDirection = .vertical
        
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
        mainCollectionView?.isScrollEnabled = false
        collecView.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        self.backgroundColor = kBGColor()
        
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false
        
        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })

    }    
    
    func setValues(model:LNSuperMainModel) {
        theTitle.text = model.title
        resource = model
        mainCollectionView?.reloadData()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension LNSuperKindCell1:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resource.entrance.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LNSuperOptionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNSuperOptionsCell
        cell.setValues(model: resource.entrance[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let WebVC = CSStoreWebViewController()
        WebVC.webTitle = resource.entrance[indexPath.row].title
        WebVC.webUrl = resource.entrance[indexPath.row].url
        viewContainingController()?.navigationController?.pushViewController(WebVC, animated: true)
    }
    
    //    每个cell的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (kSCREEN_WIDTH-0.5*4)/4, height: 100)
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
