//
//  UIImageView+blurry.h
//  图片的模糊处理
//
//  Created by 梁森 on 2018/3/20.
//  Copyright © 2018年 梁森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (blurry)
/**
 *  对图片进行模糊
 *
 *  @param image 要处理图片
 *  @param blur  模糊系数 (0.0-1.0)
 *
 *  @return 处理后的图片
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

+ (UIImage *)blurryCoreImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
