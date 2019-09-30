//
//  BaseMenuViewController.h
//  弹窗菜单
//
//  Created by EastSun on 2017/12/21.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DrawGraphics.h"

// 菜单展示位置单例
typedef NS_ENUM(NSInteger, MenuPlacements) {
    ShowAtTop = 0,
    ShowAtLeft,
    ShowAtBottom,
    ShowAtRight
};

// 菜单展示动画单例
typedef NS_ENUM(NSInteger, MenuShowAnimationStyle) {
    ShowAnimationDefault = 0,// 没有动画
    ShowAnimationZoom// 缩放动画
};

// 弹窗箭头的样式
typedef NS_ENUM(NSUInteger, MenuArrowStyle) {
    MenuArrowStyleRound = 0, // 圆角箭头
    MenuArrowStyleTriangle// 菱角箭头
};

@class BaseMenuViewController;
// 协议
@protocol MenuViewControllerDelegate <NSObject>

@optional

/**
 使用不带选中状态的菜单需要实现的协议方法

 @param tag 被点击的菜单单元标志值
 @param title 被点击的菜单单元标题
 */
- (void)menu:(BaseMenuViewController *)menu didClickedItemUnitWithTag:(NSInteger)tag andItemUnitTitle:(NSString *)title;

/**
 使用带选中状态的菜单需要实现的协议方法

 @param tag 被点击的菜单单元标志值
 @param title 被点击的菜单单元标题
 @param state 菜单单元点击后的状态
 */
- (void)menu:(BaseMenuViewController *)menu didClickedMenuItemUnitWithTag:(NSInteger)tag andItemUnitTitle:(NSString *)title itemiUnitPostClickState :(BOOL)state;

@end

// 菜单箭头高度
static CGFloat const ARROWHEIGHT = 10.f;
// 菜单圆润度
static CGFloat const MENUCORNERRADIUS = 5.f;

@interface BaseMenuViewController : UIViewController

/** 菜单弹出方法 */
- (void)presentMenuView;

/** 菜单移除方法 */
- (void)removeMenuView;

/** 代理对象 */
@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;

@end
