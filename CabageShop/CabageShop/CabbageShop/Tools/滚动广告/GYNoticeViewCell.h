//
//  GYNoticeViewCell.h
//  RollingNotice
//
//  Created by qm on 2017/12/4.
//  Copyright © 2017年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

// 调试cell内存地址log
static BOOL GYRollingDebugLog = NO;

@interface GYNoticeViewCell : UIView

@property (nonatomic, readonly, strong) UIView *contentView;
//@property (nonatomic, readonly, strong) UILabel *textLabel;
//@property (nonatomic, readonly, strong) UILabel *textLabel1;
//@property (nonatomic, readonly, strong) UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel3;


@property (nonatomic, readonly,   copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
-(void)setValues:(NSString *)nameStr andText:(NSString *)text andMoney:(NSString *)money;

@end
