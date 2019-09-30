

//
//  UIView+DrawGraphics.m
//  贝塞尔曲线绘图
//
//  Created by EastSun on 2017/12/20.
//  Copyright © 2017年 EastSun. All rights reserved.
//

#import "UIView+DrawGraphics.h"

#define SELFWIDTH CGRectGetWidth(self.frame)
#define SELFHEIGHT CGRectGetHeight(self.frame)

@implementation UIView (DrawGraphics)

- (void)getTopRoundedArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat filletRadius = 3;// 圆角半径
    
    // 顺时针设置三角圆弧
    [path addArcWithCenter:CGPointMake(startPoint.x, startPoint.y + filletRadius) radius:filletRadius startAngle:M_PI endAngle:0 clockwise:YES];
    
    
    [path addLineToPoint:CGPointMake(startPoint.x+arrowHeight, startPoint.y+arrowHeight)];// 和在左侧化箭头刚好颠倒过来
    
    [path addLineToPoint:CGPointMake(SELFWIDTH - radianRadius,startPoint.y+arrowHeight)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(SELFWIDTH,startPoint.y+arrowHeight+radianRadius) controlPoint1:CGPointMake(SELFWIDTH - radianRadius,startPoint.y+arrowHeight) controlPoint2:CGPointMake(SELFWIDTH, startPoint.y+arrowHeight)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT - radianRadius)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH - radianRadius, SELFHEIGHT) controlPoint1:CGPointMake(SELFWIDTH, SELFHEIGHT - radianRadius) controlPoint2:CGPointMake(SELFWIDTH, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(radianRadius, SELFHEIGHT)];
    
    [path addCurveToPoint:CGPointMake(0, SELFHEIGHT-radianRadius) controlPoint1:CGPointMake(radianRadius, SELFHEIGHT) controlPoint2:CGPointMake(0, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(0, startPoint.y+arrowHeight+radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, startPoint.y+arrowHeight) controlPoint1:CGPointMake(0, startPoint.y+arrowHeight+radianRadius) controlPoint2:CGPointMake(0, startPoint.y+arrowHeight)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(startPoint.x - arrowHeight, startPoint.y+arrowHeight)];
    
    
    //    [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y)];
    [path addLineToPoint:CGPointMake(startPoint.x - filletRadius, startPoint.y +filletRadius)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
    
}

- (void)getBottomRoundedArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat filletRadius = 3;// 圆角半径
    
    // 顺时针设置三角圆弧
    [path addArcWithCenter:CGPointMake(startPoint.x, startPoint.y - filletRadius) radius:filletRadius startAngle:0 endAngle:M_PI clockwise:YES];
    
    
    [path addLineToPoint:CGPointMake(startPoint.x-arrowHeight, startPoint.y-arrowHeight)];// 和在左侧化箭头刚好颠倒过来
    
    [path addLineToPoint:CGPointMake(radianRadius,startPoint.y-arrowHeight)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(0, startPoint.y-(arrowHeight+radianRadius)) controlPoint1:CGPointMake(radianRadius,startPoint.y-arrowHeight) controlPoint2:CGPointMake(0, startPoint.y-arrowHeight)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(0, radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, 0) controlPoint1:CGPointMake(0, radianRadius) controlPoint2:CGPointMake(0, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH-radianRadius, 0)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH, radianRadius) controlPoint1:CGPointMake(SELFWIDTH-radianRadius, 0) controlPoint2:CGPointMake(SELFWIDTH, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, startPoint.y-(arrowHeight+radianRadius))];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH-radianRadius, startPoint.y-arrowHeight) controlPoint1:CGPointMake(SELFWIDTH, startPoint.y-(arrowHeight+radianRadius)) controlPoint2:CGPointMake(SELFWIDTH, startPoint.y-arrowHeight)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(startPoint.x + arrowHeight, startPoint.y-arrowHeight)];
    
    
    //    [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y)];
    [path addLineToPoint:CGPointMake(startPoint.x + filletRadius, startPoint.y -filletRadius)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
}

- (void)getTopArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];// 上下画箭头，起点是（宽的一半，0/高）;左右画箭头，起点是（0/宽，高的一半）
    
    [path addLineToPoint:CGPointMake(startPoint.x+arrowHeight*atanh(M_PI/6), startPoint.y+arrowHeight)];// 和在左侧化箭头刚好颠倒过来
    
    [path addLineToPoint:CGPointMake(SELFWIDTH - radianRadius,startPoint.y+arrowHeight)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(SELFWIDTH,startPoint.y+arrowHeight+radianRadius) controlPoint1:CGPointMake(SELFWIDTH - radianRadius,startPoint.y+arrowHeight) controlPoint2:CGPointMake(SELFWIDTH, startPoint.y+arrowHeight)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT - radianRadius)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH - radianRadius, SELFHEIGHT) controlPoint1:CGPointMake(SELFWIDTH, SELFHEIGHT - radianRadius) controlPoint2:CGPointMake(SELFWIDTH, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(radianRadius, SELFHEIGHT)];
    
    [path addCurveToPoint:CGPointMake(0, SELFHEIGHT-radianRadius) controlPoint1:CGPointMake(radianRadius, SELFHEIGHT) controlPoint2:CGPointMake(0, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(0, startPoint.y+arrowHeight+radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, startPoint.y+arrowHeight) controlPoint1:CGPointMake(0, startPoint.y+arrowHeight+radianRadius) controlPoint2:CGPointMake(0, startPoint.y+arrowHeight)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(startPoint.x - arrowHeight*atanh(M_PI/6), startPoint.y+arrowHeight)];
    [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
}

- (void)getBottomArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];// 上下画箭头，起点是（宽的一半，0/高）;左右画箭头，起点是（0/宽，高的一半）
    
    [path addLineToPoint:CGPointMake(startPoint.x-arrowHeight*atanh(M_PI/6), startPoint.y-arrowHeight)];// 和在左侧化箭头刚好颠倒过来
    
    [path addLineToPoint:CGPointMake(radianRadius,startPoint.y-arrowHeight)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(0, startPoint.y-(arrowHeight+radianRadius)) controlPoint1:CGPointMake(radianRadius,startPoint.y-arrowHeight) controlPoint2:CGPointMake(0, startPoint.y-arrowHeight)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(0, radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, 0) controlPoint1:CGPointMake(0, radianRadius) controlPoint2:CGPointMake(0, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH-radianRadius, 0)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH, radianRadius) controlPoint1:CGPointMake(SELFWIDTH-radianRadius, 0) controlPoint2:CGPointMake(SELFWIDTH, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, startPoint.y-(arrowHeight+radianRadius))];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH-radianRadius, startPoint.y-arrowHeight) controlPoint1:CGPointMake(SELFWIDTH, startPoint.y-(arrowHeight+radianRadius)) controlPoint2:CGPointMake(SELFWIDTH, startPoint.y-arrowHeight)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(startPoint.x + arrowHeight*atanh(M_PI/6), startPoint.y-arrowHeight)];
    [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
}

- (void)getLeftArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
    [path addLineToPoint:CGPointMake(startPoint.x+arrowHeight, startPoint.y-arrowHeight*atanh(M_PI/6))];
    [path addLineToPoint:CGPointMake(startPoint.x+arrowHeight, radianRadius)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(startPoint.x+arrowHeight+radianRadius, 0) controlPoint1:CGPointMake(startPoint.x+arrowHeight, radianRadius) controlPoint2:CGPointMake(startPoint.x+arrowHeight, 0)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH - radianRadius, 0)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH, radianRadius) controlPoint1:CGPointMake(SELFWIDTH - radianRadius, 0) controlPoint2:CGPointMake(SELFWIDTH, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT-radianRadius)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH - radianRadius, SELFHEIGHT) controlPoint1:CGPointMake(SELFWIDTH, SELFHEIGHT-radianRadius) controlPoint2:CGPointMake(SELFWIDTH, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(startPoint.x+arrowHeight+radianRadius, SELFHEIGHT)];
    
    [path addCurveToPoint:CGPointMake(startPoint.x+arrowHeight, SELFHEIGHT-radianRadius) controlPoint1:CGPointMake(startPoint.x+arrowHeight+radianRadius, SELFHEIGHT) controlPoint2:CGPointMake(startPoint.x+arrowHeight, SELFHEIGHT)];// 添加弧线
    [path addLineToPoint:CGPointMake(startPoint.x+arrowHeight, startPoint.y+arrowHeight*atanh(M_PI/6))];
    [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
    
}

- (void)getRightArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius startPoint:(CGPoint)startPoint {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
    
    [path addLineToPoint:CGPointMake(startPoint.x - arrowHeight, startPoint.y+arrowHeight*atanh(M_PI/6))];
    
    [path addLineToPoint:CGPointMake(startPoint.x - arrowHeight, SELFHEIGHT-radianRadius)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(startPoint.x-(arrowHeight+radianRadius), SELFHEIGHT) controlPoint1:CGPointMake(startPoint.x - arrowHeight, SELFHEIGHT-radianRadius) controlPoint2:CGPointMake(startPoint.x - arrowHeight, SELFHEIGHT)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(radianRadius, SELFHEIGHT)];
    
    [path addCurveToPoint:CGPointMake(0, SELFHEIGHT-radianRadius) controlPoint1:CGPointMake(radianRadius, SELFHEIGHT) controlPoint2:CGPointMake(0, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(0, radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, 0) controlPoint1:CGPointMake(0, radianRadius) controlPoint2:CGPointMake(0, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(startPoint.x-(arrowHeight+radianRadius), 0)];
    
    [path addCurveToPoint:CGPointMake(startPoint.x-arrowHeight, radianRadius) controlPoint1:CGPointMake(startPoint.x-(arrowHeight+radianRadius), 0) controlPoint2:CGPointMake(startPoint.x-arrowHeight, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(startPoint.x-arrowHeight, startPoint.y-arrowHeight*atanh(M_PI/6))];
    
    [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
    
}


#pragma mark- 中间三角
/**
 绘制箭头

 @param arrowHeight 箭头的高度
 @param radianRadius 圆弧半径
 */
- (void)getTopArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(SELFWIDTH/2, 0)];// 上下画箭头，起点是（宽的一半，0/高）;左右画箭头，起点是（0/宽，高的一半）
    
    [path addLineToPoint:CGPointMake(SELFWIDTH/2+arrowHeight*atanh(M_PI/6), arrowHeight)];// 和在左侧化箭头刚好颠倒过来
    
    [path addLineToPoint:CGPointMake(SELFWIDTH - radianRadius,arrowHeight)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(SELFWIDTH, arrowHeight+radianRadius) controlPoint1:CGPointMake(SELFWIDTH - radianRadius,arrowHeight) controlPoint2:CGPointMake(SELFWIDTH, arrowHeight)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT - radianRadius)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH - radianRadius, SELFHEIGHT) controlPoint1:CGPointMake(SELFWIDTH, SELFHEIGHT - radianRadius) controlPoint2:CGPointMake(SELFWIDTH, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(radianRadius, SELFHEIGHT)];
    
    [path addCurveToPoint:CGPointMake(0, SELFHEIGHT-radianRadius) controlPoint1:CGPointMake(radianRadius, SELFHEIGHT) controlPoint2:CGPointMake(0, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(0, arrowHeight+radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, arrowHeight) controlPoint1:CGPointMake(0, arrowHeight+radianRadius) controlPoint2:CGPointMake(0, arrowHeight)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH/2 - arrowHeight*atanh(M_PI/6), arrowHeight)];
    [path addLineToPoint:CGPointMake(SELFWIDTH/2, 0)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
}

- (void)getBottomArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(SELFWIDTH/2, SELFHEIGHT)];// 上下画箭头，起点是（宽的一半，0/高）;左右画箭头，起点是（0/宽，高的一半）
    
    [path addLineToPoint:CGPointMake(SELFWIDTH/2-arrowHeight*atanh(M_PI/6), SELFHEIGHT-arrowHeight)];// 和在左侧化箭头刚好颠倒过来
    
    [path addLineToPoint:CGPointMake(radianRadius,SELFHEIGHT-arrowHeight)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(0, SELFHEIGHT-(arrowHeight+radianRadius)) controlPoint1:CGPointMake(radianRadius,SELFHEIGHT-arrowHeight) controlPoint2:CGPointMake(0, SELFHEIGHT-arrowHeight)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(0, radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, 0) controlPoint1:CGPointMake(0, radianRadius) controlPoint2:CGPointMake(0, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH-radianRadius, 0)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH, radianRadius) controlPoint1:CGPointMake(SELFWIDTH-radianRadius, 0) controlPoint2:CGPointMake(SELFWIDTH, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT-(arrowHeight+radianRadius))];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH-radianRadius, SELFHEIGHT-arrowHeight) controlPoint1:CGPointMake(SELFWIDTH, SELFHEIGHT-(arrowHeight+radianRadius)) controlPoint2:CGPointMake(SELFWIDTH, SELFHEIGHT-arrowHeight)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH/2 + arrowHeight*atanh(M_PI/6), SELFHEIGHT-arrowHeight)];
    [path addLineToPoint:CGPointMake(SELFWIDTH/2, SELFHEIGHT)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
}

- (void)getLeftArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, SELFHEIGHT/2)];
    [path addLineToPoint:CGPointMake(arrowHeight, SELFHEIGHT/2-arrowHeight*atanh(M_PI/6))];
    [path addLineToPoint:CGPointMake(arrowHeight, radianRadius)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(arrowHeight+radianRadius, 0) controlPoint1:CGPointMake(arrowHeight, radianRadius) controlPoint2:CGPointMake(arrowHeight, 0)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH - radianRadius, 0)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH, radianRadius) controlPoint1:CGPointMake(SELFWIDTH - radianRadius, 0) controlPoint2:CGPointMake(SELFWIDTH, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT-radianRadius)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH - radianRadius, SELFHEIGHT) controlPoint1:CGPointMake(SELFWIDTH, SELFHEIGHT-radianRadius) controlPoint2:CGPointMake(SELFWIDTH, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(arrowHeight+radianRadius, SELFHEIGHT)];
    
    [path addCurveToPoint:CGPointMake(arrowHeight, SELFHEIGHT-radianRadius) controlPoint1:CGPointMake(arrowHeight+radianRadius, SELFHEIGHT) controlPoint2:CGPointMake(arrowHeight , SELFHEIGHT)];// 添加弧线
    [path addLineToPoint:CGPointMake(arrowHeight, SELFHEIGHT/2+arrowHeight*atanh(M_PI/6))];
    [path addLineToPoint:CGPointMake(0, SELFHEIGHT/2)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
    
}

- (void)getRightArrowWitharrowHeight:(CGFloat)arrowHeight radianRadius:(CGFloat)radianRadius {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT/2)];
    
    [path addLineToPoint:CGPointMake(SELFWIDTH - arrowHeight, SELFHEIGHT/2+arrowHeight*atanh(M_PI/6))];
    
    [path addLineToPoint:CGPointMake(SELFWIDTH - arrowHeight, SELFHEIGHT-radianRadius)];
    
    // 第一个参数是目的点，第二个参数是控制画弧线的第一个控制点，第三个参数是控制画弧线的第二个控制点
    [path addCurveToPoint:CGPointMake(SELFWIDTH-(arrowHeight+radianRadius), SELFHEIGHT) controlPoint1:CGPointMake(SELFWIDTH - arrowHeight, SELFHEIGHT-radianRadius) controlPoint2:CGPointMake(SELFWIDTH - arrowHeight, SELFHEIGHT)];// 添加第一段弧线
    
    [path addLineToPoint:CGPointMake(radianRadius, SELFHEIGHT)];
    
    [path addCurveToPoint:CGPointMake(0, SELFHEIGHT-radianRadius) controlPoint1:CGPointMake(radianRadius, SELFHEIGHT) controlPoint2:CGPointMake(0, SELFHEIGHT)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(0, radianRadius)];
    
    [path addCurveToPoint:CGPointMake(radianRadius, 0) controlPoint1:CGPointMake(0, radianRadius) controlPoint2:CGPointMake(0, 0)];// 添加弧线
    
    [path addLineToPoint:CGPointMake(SELFWIDTH-(arrowHeight+radianRadius), 0)];
    
    [path addCurveToPoint:CGPointMake(SELFWIDTH-arrowHeight, radianRadius) controlPoint1:CGPointMake(SELFWIDTH-(arrowHeight+radianRadius), 0) controlPoint2:CGPointMake(SELFWIDTH-arrowHeight, 0)];// 添加弧线
    [path addLineToPoint:CGPointMake(SELFWIDTH-arrowHeight, SELFHEIGHT/2-arrowHeight*atanh(M_PI/6))];
    
    [path addLineToPoint:CGPointMake(SELFWIDTH, SELFHEIGHT/2)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.lineWidth = 0;
    pathLayer.strokeColor = [UIColor whiteColor].CGColor;
    pathLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.layer.mask = pathLayer;
    
}

@end
