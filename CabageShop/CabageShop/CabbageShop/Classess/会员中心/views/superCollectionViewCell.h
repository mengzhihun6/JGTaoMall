//
//  superCollectionViewCell.h
//  MyNewProject
//
//  Created by 赵马刚 on 2018/12/19.
//  Copyright © 2018 sun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    SYCellBorderDirectionTop = 1 << 0,
    SYCellBorderDirectionBottom = 1<<1,
    SYCellBorderDirectionRight = 1 <<2,
    SYCellBorderDirectionLeft = 1<<3,
    
} SYCellBorderDirection;


NS_ASSUME_NONNULL_BEGIN

@interface superCollectionViewCell : UICollectionViewCell
@property(nonatomic) NSInteger tag;
@property (nonatomic, strong) NSDictionary *entranceDic;



@end

NS_ASSUME_NONNULL_END
