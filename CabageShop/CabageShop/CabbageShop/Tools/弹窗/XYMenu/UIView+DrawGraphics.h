//
//  UIView+DrawGraphics.h
//  贝塞尔曲线绘图
//
//  Created by EastSun on 2017/12/20.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DrawGraphics)

#pragma mark- 箭头始终在视图中间
- (void)getTopArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius;

- (void)getBottomArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius;

- (void)getLeftArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius;

- (void)getRightArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius;


#pragma mark- 尖角箭头始终指向触发位置的中间
- (void)getTopArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint;

- (void)getBottomArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint;

- (void)getLeftArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint;

- (void)getRightArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint;

#pragma mark- 圆角箭头始终指向触发位置的中间
- (void)getBottomRoundedArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint;

- (void)getTopRoundedArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint;
 

@end
