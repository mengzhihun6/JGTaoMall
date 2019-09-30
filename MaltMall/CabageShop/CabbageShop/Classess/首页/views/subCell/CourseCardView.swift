//
//  CardView.swift
//  ScrollCard
//
//  Created by Tony on 2017/9/26.
//  Copyright © 2017年 Tony. All rights reserved.
//

import UIKit

class CourseCardView: UIView {
    
    var selectedIndex = 0
    var models: [LNYHQListModel] = [LNYHQListModel]() {
        didSet {
            collectionView.reloadData()
            if models.count < 2 {
                collectionView.isScrollEnabled = false
            }
            
            if models.count>2 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {                    
                    self.collectionView.setContentOffset(CGPoint(x: 5, y: 0), animated: true)
                }
            }
        }
    }
    var selectedCourseClosure: ((LNYHQListModel) -> Void)?
    
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = CourseCardFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = -FIT_SCREEN_WIDTH(16)
        layout.itemSize = CGSize(width: kSCREEN_WIDTH/3+16, height: self.height-8)
        
        let xPadding = FIT_SCREEN_WIDTH(8)
        let collectionView = UICollectionView(frame: CGRect(x: xPadding, y: 0, width: kSCREEN_WIDTH - xPadding * 2, height: self.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CourseCardCell", bundle: nil), forCellWithReuseIdentifier: "CourseCardCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeBtnClicked() {
        remove()
    }
    
    // 展示
    public func show() {
        DispatchQueue.main.async(execute: { () -> Void in
            UIApplication.shared.keyWindow?.addSubview(self)
            self.scrollToItem(withAnimation: true, index: self.selectedIndex)
            UIView.animate(withDuration: 1, animations: {
                self.y = 0
            }) { (finished) in
            }
        })
    }
    
    // 移除
    private func remove() {
        DispatchQueue.main.async(execute: { () -> Void in
            UIView.animate(withDuration: 0.5, animations: {
                self.y = self.height
            }) { (finished) in
                self.removeFromSuperview()
            }
        })
    }
}


extension CourseCardView: UICollectionViewDataSource, UICollectionViewDelegate, CAAnimationDelegate {
    
    // MARK:- CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCardCell", for: indexPath) as! CourseCardCell
        let index = indexPath.row
        cell.model = models[index]
        cell.cornerRadius = 4
        cell.clipsToBounds = true
        
//        if index == 2 {
//            if let cell = collectionView.cellForItem(at: IndexPath.init(row: 1, section: 0)) {
//                collectionView.bringSubview(toFront: cell)
//                self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
//            }
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let pointInView = self.convert(collectionView.center, to: collectionView)
        let centerIndex = collectionView.indexPathForItem(at: pointInView)?.row ?? 0
        print("cnterIndex: ", centerIndex)
        
        selectedCourseClosure?(models[index])

        if index == centerIndex { // 若点击的是中间位置的书，则选择完成
            selectedIndex = index
        } else { // 若点击旁边的书，则让其滚动至中间位置
            scrollToItem(withAnimation: true, index: index)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pointInView = self.convert(collectionView.center, to: collectionView)
        let index = collectionView.indexPathForItem(at: pointInView)?.row ?? 0
        print("滚动至下标：\(index)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pointInView = self.convert(collectionView.center, to: collectionView)
        let index = collectionView.indexPathForItem(at: pointInView)?.row ?? 0

        if let cell = collectionView.cellForItem(at: IndexPath.init(row: index - 1, section: 0)) {
            collectionView.bringSubview(toFront: cell)
            let theCell = cell as! CourseCardCell
            theCell.coverView.isHidden = false
        }
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: index + 1, section: 0)) {
            collectionView.bringSubview(toFront: cell)
            let theCell = cell as! CourseCardCell
            theCell.coverView.isHidden = false
        }
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: index, section: 0))  {
            collectionView.bringSubview(toFront: cell)
            let theCell = cell as! CourseCardCell
            theCell.coverView.isHidden = true
            theCell.layer.shadowOpacity = 0.8
            theCell.layer.shadowColor = UIColor.black.cgColor
            theCell.layer.shadowOffset = CGSize(width: 5, height: 5)
            theCell.layer.shadowRadius = 1

            let shadowFrame = theCell.layer.bounds
            let shadowPath = UIBezierPath.init(rect: shadowFrame).cgPath
            cell.layer.shadowPath = shadowPath
        }
    }
    
    fileprivate func scrollToItem(withAnimation animation: Bool, index: Int) {
        
        let index = index < models.count ? index : 0
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animation)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("stop")
        remove()
    }
}
