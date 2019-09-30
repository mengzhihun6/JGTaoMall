//
//  ArrowheadMenuSelectedState.h
//  Pop-upMenu
//
//  Created by EastSun on 2018/3/19.
//  Copyright © 2018年 EastSun. All rights reserved.
//

#import "BaseMenuViewController.h"



@interface ArrowheadMenuSelectedState : BaseMenuViewController

/**
 是否允许多选，默认是单选
 */
@property (nonatomic, assign) BOOL allowsMultipleSelection;

#pragma mark- 默认风格

/**
 默认UI风格创建菜单

 @param normalTitleArray 非选中状态下，菜单单元标题
 @param selectedTitleArray 选中状态下，菜单单元标题
 @param normalIconArray 非选中状态下，菜单单元图标，存放image的名字字符串
 @param selectedIconArray 选中状态下，菜单单元图标，存放image的名字字符串
 @param normalTitleColor 非选中状态下，菜单单元字体颜色
 @param selectedTitleColor 选中状态下，菜单单元字体颜色
 @param placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
 @return 返回菜单对象
 */
- (instancetype _Nullable)initDefaultArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *>  *_Nonnull)normalTitleArray selectedTitle:(NSArray<NSString *>  *_Nonnull)selectedTitleArray normalIcon:(NSArray<NSString *>  *_Nullable)normalIconArray selectedIcon:(NSArray<NSString *>  *_Nullable)selectedIconArray menuNormalTitleColor:(UIColor * _Nullable)normalTitleColor menuSelectedTitleColor:(UIColor * _Nullable)selectedTitleColor menuPlacements:(MenuPlacements)placements;

#pragma mark- 自定义风格
/**
 自定义UI风格创建菜单，根据自己风格设置菜单UI元素，菜单每个单元的非选中状态下字体颜色相同，菜单每个单元的选中状态下字体颜色也相同

 @param normalTitleArray 非选中状态下，菜单单元标题
 @param selectedTitleArray 选中状态下，菜单单元标题
 @param normalIconArray 非选中状态下，菜单单元图标，存放image的名字字符串
 @param selectedIconArray 选中状态下，菜单单元图标，存放image的名字字符串
 @param normalTitleColor 非选中状态下，菜单单元字体颜色
 @param selectedTitleColor 选中状态下，菜单单元字体颜色
 @param size 菜单单元格的大小（宽和高）
 @param font 菜单单元格标题字体
 @param menuBackColor 菜单背景颜色
 @param separatorColor 菜单单元分割线颜色
 @param interval 菜单距离触发菜单的控件的距离，可为负数
 @param arrowStyle 菜单箭头的风格，尖角和圆角两种
 @param placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
 @param animation 菜单弹出动画
 @return 返回菜单对象
 */
- (instancetype _Nullable)initCustomArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *>  *_Nonnull)normalTitleArray selectedTitle:(NSArray<NSString *>  *_Nonnull)selectedTitleArray normalIcon:(NSArray<NSString *>  *_Nullable)normalIconArray selectedIcon:(NSArray<NSString *>  *_Nullable)selectedIconArray menuNormalTitleColor:(UIColor * _Nonnull)normalTitleColor menuSelectedTitleColor:(UIColor * _Nonnull)selectedTitleColor  menuUnitSize:(CGSize)size menuFont:(UIFont * _Nonnull)font menuBackColor:(UIColor *_Nonnull)menuBackColor menuSegmentingLineColor:(UIColor *_Nonnull)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation;

/**
 自定义UI风格创建菜单，根据自己风格设置菜单UI元素，菜单每个单元的非选中状态下字体颜色不相同，菜单每个单元的选中状态下字体颜色也不相同 
 
 @param normalTitleArray 非选中状态下，菜单单元标题
 @param selectedTitleArray 选中状态下，菜单单元标题
 @param normalIconArray 非选中状态下，菜单单元图标，存放image的名字字符串
 @param selectedIconArray 选中状态下，菜单单元图标，存放image的名字字符串
 @param normalTitleColorArray 非选中状态下，菜单单元字体颜色
 @param selectedTitleColorArray 选中状态下，菜单单元字体颜色
 @param size 菜单单元格的大小（宽和高）
 @param font 菜单单元格标题字体
 @param menuBackColor 菜单背景颜色
 @param separatorColor 菜单单元分割线颜色
 @param interval 菜单距离触发菜单的控件的距离，可为负数
 @param arrowStyle 菜单箭头的风格，尖角和圆角两种
 @param placements 菜单相对于触发菜单的控件的位置（上、下、左、右四种）
 @param animation 菜单弹出动画
 @return 返回菜单对象
 */
- (instancetype _Nullable)initCustomArrowheadStatusMenuWithNormalTitle:(NSArray<NSString *>  *_Nonnull)normalTitleArray selectedTitle:(NSArray<NSString *>  *_Nonnull)selectedTitleArray normalIcon:(NSArray<NSString *>  *_Nullable)normalIconArray selectedIcon:(NSArray<NSString *>  *_Nullable)selectedIconArray menuNormalTitleColorArray:(NSArray<UIColor *>  *_Nonnull)normalTitleColorArray menuSelectedTitleColorArray:(NSArray<UIColor *>  *_Nonnull)selectedTitleColorArray  menuUnitSize:(CGSize)size menuFont:(UIFont * _Nonnull)font menuBackColor:(UIColor *_Nonnull)menuBackColor menuSegmentingLineColor:(UIColor *_Nonnull)separatorColor distanceFromTriggerSwitch:(CGFloat)interval menuArrowStyle:(MenuArrowStyle)arrowStyle menuPlacements:(MenuPlacements)placements showAnimationEffects:(MenuShowAnimationStyle)animation;


/**
 菜单展示API
 
 @param sender 触发菜单的控件
 */
- (void)presentMenuView:(NSObject *_Nonnull)sender;

/**
 菜单项消除选中状态

 @param tag 菜单的tag标志值
 */
- (void)whenClickedUncheckOwnStatus:(NSInteger)tag;


@end
