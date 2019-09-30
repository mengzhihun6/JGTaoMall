//
//  GYNoticeViewCell.m
//  RollingNotice
//
//  Created by qm on 2017/12/4.
//  Copyright © 2017年 qm. All rights reserved.
//

#import "GYNoticeViewCell.h"
#import <Masonry/Masonry.h>
#import "OCTools.h"
@implementation GYNoticeViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        if (GYRollingDebugLog) {
            NSLog(@"init a cell from code: %p", self);
        }
        _reuseIdentifier = reuseIdentifier;
        [self setupInitialUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        if (GYRollingDebugLog) {
            NSLog(@"init a cell from xib");
        }
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithReuseIdentifier:@""];
}

- (void)setupInitialUI
{
    self.backgroundColor = [UIColor whiteColor];
    _contentView = [[UIView alloc] init];

    [self addSubview:_contentView];
    
//    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
//    _contentView.frame = self.bounds;
    
    

//    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.width.greaterThanOrEqualTo(0);
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//
//    [_textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self->_textLabel.mas_right);
//        make.width.greaterThanOrEqualTo(0);
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//
//    [_textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self->_textLabel1.mas_right);
//        make.width.greaterThanOrEqualTo(0);
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];

    _textLabel.textColor = [UIColor colorWithRed:243.00/255.00 green:26.00/255.00 blue:56.00/255.00 alpha:1];
    _textLabel3.textColor = [UIColor colorWithRed:139.00/255.00 green:139.00/255.00 blue:139.00/255.00 alpha:1];
    _textLabel2.textColor = [UIColor colorWithRed:243.00/255.00 green:26.00/255.00 blue:56.00/255.00 alpha:1];
    
    _textLabel.font = [UIFont systemFontOfSize:11];
    _textLabel3.font = [UIFont systemFontOfSize:11];
    _textLabel2.font = [UIFont systemFontOfSize:11];
//
//    _textLabel.textAlignment = NSTextAlignmentCenter;
//    _textLabel2.textAlignment = NSTextAlignmentCenter;
//    textLabel3.textAlignment = NSTextAlignmentCenter;
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
////    _textLabel.frame = CGRectMake(10, 0, self.bounds.size.width, self.frame.size.height);
////    _textLabel.textAlignment = NSTextAlignmentLeft;
//}

//-(void)setValues:(NSString *)nameStr andText:(NSString *)text andMoney:(NSString *)money {
//    _textLabel.text = nameStr;
//    _textLabel1.text = text;
//    _textLabel2.text = money;
//}

- (void)dealloc
{
    if (GYRollingDebugLog) {
        NSLog(@"%p, %s", self, __func__);
    }
    
}


@end
