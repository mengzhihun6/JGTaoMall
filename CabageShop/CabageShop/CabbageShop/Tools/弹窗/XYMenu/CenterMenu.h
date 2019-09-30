//
//  CenterMenu.h
//  弹窗菜单
//
//  Created by EastSun on 2017/12/21.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import "BaseMenuViewController.h"

@interface CenterMenu : BaseMenuViewController

#pragma mark- 默认风格
- (instancetype _Nullable)initDefaultCenterMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray;

#pragma mark- 自定义风格
- (instancetype _Nullable)initCustomCenterMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray menuUnitSize:(CGSize)size  menuCornerRadius:(CGFloat)menuRoundedRadius menuFont:(UIFont * _Nullable)font menuFontColor:(UIColor * _Nullable)fontColor menuBackColor:(UIColor *_Nullable)menuBackColor menuSegmentingLineColor:(UIColor *_Nullable)separatorColor menuMaskColor:(UIColor *_Nullable)menuMaskColor;

@end
