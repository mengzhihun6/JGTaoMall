//
//  LXFChatEmotionCollectionLayout.swift
//  qwer
//
//  Created by 宋宗宇 on 2019/4/11.
//  Copyright © 2019 宋宗宇. All rights reserved.
//

import UIKit



class LXFChatEmotionCollectionLayout: UICollectionViewFlowLayout {
    
    let kEmotionCellNumberOfOneRow = 5
    let kEmotionCellRow = 2
    
    var numberOfPages = 0
    
    // 保存所有item
    fileprivate var attributesArr: [UICollectionViewLayoutAttributes] = []
    
    // MARK:- 重新布局
    override func prepare() {
        super.prepare()
        
//        let itemWH: CGFloat = kScreenW / CGFloat(kEmotionCellNumberOfOneRow)
        
        // 设置itemSize
//        return CGSize(width: kSCREEN_WIDTH / 4, height: bg_view.height / 2)
//        itemSize = CGSize(width: itemWH, height: 150)
        let kScreenW = itemSize.width
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        var page = 0
        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        numberOfPages = Int(jisuan(itemsInPage: UInt(kEmotionCellNumberOfOneRow * kEmotionCellRow), totalCount: UInt(itemsCount)))
        for itemIndex in 0..<itemsCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            page = itemIndex / (kEmotionCellNumberOfOneRow * kEmotionCellRow)
            // 通过一系列计算, 得到x, y值
            let x = itemSize.width * CGFloat(itemIndex % Int(kEmotionCellNumberOfOneRow)) + (CGFloat(page) * kScreenW)
            let y = itemSize.height * CGFloat((itemIndex - page * kEmotionCellRow * kEmotionCellNumberOfOneRow) / kEmotionCellNumberOfOneRow)
            
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 把每一个新的属性保存起来
            attributesArr.append(attributes)
        }
        
    }
    
    func jisuan(itemsInPage: UInt, totalCount: UInt) -> UInt {
        if totalCount == 0 {
            return 0
        }
        
        return (totalCount > itemsInPage) ? ((totalCount - 1) / itemsInPage + 1) : 1
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        _ = attributesArr.map({
            if rect.contains($0.frame) {
                rectAttributes.append($0)
            }
        })
        
        return rectAttributes
    }
    
    override open var collectionViewContentSize: CGSize {
        
        return CGSize.init(width: (self.collectionView!.bounds.size.width) * CGFloat(numberOfPages), height: (self.collectionView!.bounds.size.height))
    }
}
