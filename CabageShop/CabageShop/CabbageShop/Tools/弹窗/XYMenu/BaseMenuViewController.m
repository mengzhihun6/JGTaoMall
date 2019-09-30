//
//  BaseMenuViewController.m
//  弹窗菜单
//
//  Created by EastSun on 2017/12/21.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import "BaseMenuViewController.h"

@interface BaseMenuViewController ()

@end

@implementation BaseMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 1.重写init方法，定义modalPresentationStyle
- (instancetype)init {
    self = [super init];
    if (self) {
        // VC的默认modalPresentationStyle是UIModalPresentationFullScreen，必须重新设置modal样式，否则推出来的VC不会是透明的
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    
    return self;
}

#pragma mark- 2.实现菜单推出方法
- (void)presentMenuView {
    
    // 获取根式控制器rootViewController，并将rootViewController设置为当前主控制器（防止菜单弹出时，部分被导航栏或标签栏遮盖）
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootVC = window.rootViewController;
    rootVC.definesPresentationContext = YES;
    // 当前主控制器推出菜单栏
    if (rootVC.presentedViewController == nil) {
        [rootVC presentViewController:self animated:NO completion:nil];
    }
}

#pragma mark- 3.菜单移除方法
- (void)removeMenuView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark- 4.点击菜单栏View，消失（根据需求，看虚不需要）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeMenuView];// 移除菜单
}

@end
