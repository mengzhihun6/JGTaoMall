//
//  CardCollectionVIewLayout.m
//  卡片CollectionVIew
//
//  Created by 栗子 on 2017/8/16.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "CardCollectionVIewLayout.h"

//设置item的大小
#define LZScreenW [UIScreen mainScreen].bounds.size.width
#define LZScreenH [UIScreen mainScreen].bounds.size.height

#define  ITEMW LZScreenW*0.7
#define  ITENH LZScreenH / 7*4


@implementation CardCollectionVIewLayout

-(instancetype)init{

    if (self = [super init]) {
        
        CGFloat width = ITEMW;
        
        if (LZScreenH < 800) {
            width = LZScreenW*0.62;
        }
        
        //设置item的大小
        self.itemSize = CGSizeMake(width, ITENH);
        self.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
//        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 250);
        self.minimumLineSpacing = 25;
    }
    return self;
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [self copyAttributes: [super layoutAttributesForElementsInRect:rect]];
    //屏幕中间线
    CGFloat centerX = self.collectionView.contentOffset.x  + self.collectionView.bounds.size.width /2.0f;
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        CGFloat distance = fabs(attribute.center.x - centerX);
    //移动的距离和屏幕宽的比例
        CGFloat screenScale = distance /self.collectionView.bounds.size.width;
    //卡片移动到固定范围内 -π/4 到 π/4
        CGFloat scale = fabs(cos(screenScale * M_PI/4));
        //设置cell的缩放 按照余弦函数曲线  越居中越接近于1
        attribute.transform = CGAffineTransformMakeScale(1.0, scale);
        //透明度
        attribute.alpha = scale;
    }
    
    
    return arr;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
-(NSArray *)copyAttributes:(NSArray  *)arr{
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in arr) {
        [copyArr addObject:[attribute copy]];
    }
    
    
    return copyArr;
}
@end
