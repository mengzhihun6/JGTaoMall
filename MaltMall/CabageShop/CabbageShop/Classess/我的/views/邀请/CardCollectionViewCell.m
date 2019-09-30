//
//  CardCollectionViewCell.m
//  卡片CollectionVIew
//
//  Created by 栗子 on 2017/8/16.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "CardCollectionViewCell.h"

@implementation CardCollectionViewCell



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
        
    }
    return self;
}

-(void)addSubviews{
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds=YES;
    
    self.imageIV = [[UIImageView alloc]initWithFrame:self.bounds];
//    self.imageIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imageIV];
    
    self.codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 105, 105)];
//    self.codeImage.center = CGPointMake(self.bounds.size.width / 2.0, 1000 * self.bounds.size.height / 666);
    [self.contentView addSubview:self.codeImage];
    
    self.codeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.codeLab.font = [UIFont systemFontOfSize:13];
    self.codeLab.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];
    [self.contentView addSubview:self.codeLab];
}

@end
