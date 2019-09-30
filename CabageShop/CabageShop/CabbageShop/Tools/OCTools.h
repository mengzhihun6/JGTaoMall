//
//  OCTools.h
//  CorrectsPapers
//
//  Created by RongXing on 2017/11/10.
//  Copyright © 2017年 Fu Yaohui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface OCTools : NSObject

//渲染动画
- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration;


//获取有效地址
+(NSURL *)getEfficientAddress:(NSString *)string;


//多位数加,号
- (NSString *)positiveFormat:(NSString *)text;


//手机号正则
+(BOOL)checkoutPhoneNum:(NSString *)phoneNum;


/**
 *  验证身份证号
 *
 *  @param cardNo 身份证号
 *
 *  @return 是否正确
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;


-(float)folderSizeAtPath;


-(void)clearCache;


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC;


-(BOOL)judgeTimeByStartAndEnd;


- (void)videoImageWithvideoURL:(NSURL *)videoURL AndCallback:(void(^)(UIImage *))callback;

//替换字符串
-(NSString *)replaceEnStr:(NSString *)enString withCHStr:(NSString *)CHString inDateStr:(NSString *)dateString;


-(void)presnet:(UIViewController *)vc imageUrl:(NSString *)imageUrl callback:(void(^)(NSString* result))callback;


-(NSString *)getStrWithFloatStr:(NSString *)floatStr;
-(NSString *)getStrWithFloatStr1:(NSString *)floatStr;
-(NSString *)getStrWithFloatStr2:(NSString *)floatStr;

-(NSString *)getStrWithIntStr:(NSString *)intStr;


-(void)presnetSearchVc:(UIViewController *)vc callback:(void(^)(NSString* result))callback;

+ (NSArray <NSString *> *)filterImage:(NSString *)html isJD:(BOOL)flag;

-(void)presnetShareVc2:(UIViewController *)vc withImageUrls:(NSArray <NSString *> *)images andImages:(NSArray <UIImage *> *)shareImages;
-(void)presnetShareVc2:(UIViewController *)vc withImageUrls:(NSArray <NSString *> *)images andImages:(NSArray <UIImage *> *)shareImages type:(NSString *)typeString;
-(void)presnetShareVc3:(UIViewController *)vc withImageUrls:(NSArray <NSString *> *)images andImages:(NSArray <UIImage *> *)shareImages;
-(void)presnetShareVc3:(UIViewController *)vc Controller:(UIViewController *)NavigationController vip:(NSString *)vipStr;
-(NSString *)getSubString:(NSString *)string WithRangeStardIndex:(NSInteger)startIndex andLength:(NSInteger)length;
+ (UIColor *) colorWithHexString: (NSString *)color;

-(void)presnetMainADs:(UIViewController *)vc withAdModel:(id)model;

-(CGFloat)getStrWidth:(NSString *)str AndFont:(NSInteger)font;

-(void)presnetSearchVc:(UIViewController *)vc andModel:(id)model;

@end
