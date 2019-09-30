//
//  LNSuperKindCell2.swift
//  CabbageShop
//
//  Created by 吴伟助 on 2018/12/26.
//  Copyright © 2018年 付耀辉. All rights reserved.
//

import UIKit

class LNSuperKindCell2: UITableViewCell {

    @IBOutlet weak var collecView: UIView!
    @IBOutlet weak var selectView: UIView!

    fileprivate var resource = [LNSuperChildrenEntranceModel]()

    //    collectionView
    fileprivate var mainCollectionView:UICollectionView?
    let identyfierTable  = "identyfierTable1"

    var topView : LNTopScrollView!
    //    顶部选择
    fileprivate var topView2 = LNTopSelectView()

    //    回调
    typealias swiftBlock = ( _ index:NSInteger) -> Void
    var willClick : swiftBlock? = nil
    func callBackBlock(block: @escaping ( _ index:NSInteger) -> Void ) {
        willClick = block
    }

    
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
        
        collecView.addSubview(mainCollectionView!)
        mainCollectionView?.backgroundColor = kBGColor()
        self.backgroundColor = kBGColor()
        
        mainCollectionView?.showsHorizontalScrollIndicator = false
        mainCollectionView?.showsVerticalScrollIndicator = false
        
        mainCollectionView?.snp.makeConstraints({ (ls) in
            ls.left.right.bottom.equalToSuperview()
            ls.top.equalToSuperview()
        })
        topView = LNTopScrollView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 40))
        topView.textColor = kGaryColor(num: 69)
        weak var weakSelf = self
        topView.callBackBlock2 { (index,model) in
            if weakSelf?.willClick != nil {
                weakSelf?.willClick!(index)
            }
            weakSelf?.requestData(model: model)
        }
        selectView.addSubview(topView)
        mainCollectionView?.isScrollEnabled = false
        
        
        topView2 = LNTopSelectView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 50))
        topView2.theFont = UIFont.systemFont(ofSize: 15)
        topView2.callBackBlock2 { (index, model) in
            DispatchQueue.main.async(execute: { () -> Void in
                if weakSelf?.willClick != nil {
                    weakSelf?.willClick!(Int(index)!)
                }
                weakSelf?.requestData(model: model)
            })
        }
        selectView.addSubview(topView2)

    }
    
    func setTopViews(model:LNSuperMainModel,selecIndex:NSInteger,index:NSInteger) {
        
        if index == 2 {
            topView.setTopView2(titles: model.children, selectIndex: selecIndex)
            topView.setSelectIndex(index: selecIndex, animation: false)
            topView2.isHidden = true
            topView.isHidden = false
        }else{
            topView2.isHidden = false
            topView.isHidden = true
            topView2.setTopViewModel(titles: model.children, selectIndex: selecIndex)
            topView2.setSelectColor(color: kGaryColor(num: 35))
        }

        requestData(model: model.children[selecIndex])
    }

    func requestData(model:LNSuperChildrenModel) {
        resource = model.entrance
        mainCollectionView?.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension LNSuperKindCell2:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LNSuperOptionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: identyfierTable, for: indexPath) as! LNSuperOptionsCell
        cell.setValues2(model: resource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let WebVC = CSStoreWebViewController()
        WebVC.webTitle = resource[indexPath.row].title
        WebVC.webUrl = resource[indexPath.row].url
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
