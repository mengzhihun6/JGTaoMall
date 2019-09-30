//
//  Healp.h
//  卡片CollectionVIew
//
//  Created by 栗子 on 2017/8/16.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Healp : NSObject

+(void)blurEffect:(UIView *)view;
//判断颜色是不是亮色
+(BOOL) isLightColor:(UIColor*)clr;
//获取RGB值
+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;

//获得某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;
@end
