//
//  ArrowheadMenu.h
//  弹窗菜单
//
//  Created by EastSun on 2017/12/21.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import "BaseMenuViewController.h"

@interface ArrowheadMenu : BaseMenuViewController

@property(nonatomic, assign) int numInt;
#pragma mark- 自定义风格

/**
 自定义UI风格创建菜单，根据自己风格设置菜单UI元素

 @param titleArray 菜单单元标题
 @param iconArray 菜单单元图标，存放image的名字字符串
 @param size 菜单单元格的大小（宽和高）
 @param font 菜单标题字体
 @param fontColor 菜单字体颜色
 @param menuBackColor 菜单背景颜色
 @param separatorColor 菜单单元分割线颜色
 @param interval 菜单距离触发菜单的控件的距离，可为负数
 @param arrowStyle 菜单箭头的风格，尖角和圆角两种
 @param placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
 @param animation 菜单弹出动画
 @return 返回菜单对象
 */
- (instancetype _Nullable)initCustomArrowheadMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray menuUnitSize:(CGSize)size menuFont:(UIFont * _Nullable)font menuFontColor:(UIColor * _Nullable)fontColor menuBackColor:(UIColor *_Nullable)menuBackColor menuSegmentingLineColor:(UIColor *_Nullable)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation;

#pragma mark- 默认风格

/**
 默认UI风格菜单,快速创建菜单
 
 @param titleArray 菜单单元标题
 @param iconArray 菜单单元图标，存放image的名字字符串
 @param placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
 @return 返回菜单对象
 */
- (instancetype _Nullable)initDefaultArrowheadMenuWithTitle:(NSArray<NSString *>  *_Nonnull)titleArray icon:(NSArray<NSString *>  *_Nullable)iconArray menuPlacements:(MenuPlacements)placements;


/**
 菜单展示API

 @param sender 触发菜单的控件
 */
- (void)presentMenuView:(NSObject *_Nonnull)sender;

@end
